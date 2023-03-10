Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AD58820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46D1C4339B;
	Fri, 10 Mar 2023 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459690;
	bh=hzSE+z/Q8Ax8Qzy5m4QvAb8w/i1NuIE1p3MZgEAatcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXBnUjNWEzKHzKlI8RbQD24v2kPKxcDWX1ChIEv51FoPCKWgyVW83Es0kLnj3kLQB
	 uBEHJdc77EFnGDd54OrLHc0e72y1yiopGehPcV9dfbLzsASWPvAWb9NM/BfU1qtqsx
	 aNROO2I3IX0gKj1EQHjOev0/o2fYoJpMFImSH+zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/529] libbpf: Fix btf__align_of() by taking into account field offsets
Date: Fri, 10 Mar 2023 14:33:21 +0100
Message-Id: <20230310133807.689045148@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 25a4481b4136af7794e1df2d6c90ed2f354d60ce ]

btf__align_of() is supposed to be return alignment requirement of
a requested BTF type. For STRUCT/UNION it doesn't always return correct
value, because it calculates alignment only based on field types. But
for packed structs this is not enough, we need to also check field
offsets and struct size. If field offset isn't aligned according to
field type's natural alignment, then struct must be packed. Similarly,
if struct size is not a multiple of struct's natural alignment, then
struct must be packed as well.

This patch fixes this issue precisely by additionally checking these
conditions.

Fixes: 3d208f4ca111 ("libbpf: Expose btf__align_of() API")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221212211505.558851-5-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index e6f644cdc9f15..f7c48b1fb3a05 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -614,8 +614,21 @@ int btf__align_of(const struct btf *btf, __u32 id)
 			if (align <= 0)
 				return align;
 			max_align = max(max_align, align);
+
+			/* if field offset isn't aligned according to field
+			 * type's alignment, then struct must be packed
+			 */
+			if (btf_member_bitfield_size(t, i) == 0 &&
+			    (m->offset % (8 * align)) != 0)
+				return 1;
 		}
 
+		/* if struct/union size isn't a multiple of its alignment,
+		 * then struct must be packed
+		 */
+		if ((t->size % max_align) != 0)
+			return 1;
+
 		return max_align;
 	}
 	default:
-- 
2.39.2



