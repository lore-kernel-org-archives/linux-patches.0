Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8294F1F4628;
	Mon, 23 Jun 2025 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714028; cv=none; b=pqeeDDa2Ca2qmTKj/lc8HycIow8B6TjVftgJRf4Fb63hP1pkFFhF8qDRzothFodaniLwuHNs6DzpMrJot5EpcQG0I+wml3v5cJumtU6p+tKxQzklpJGed39Tb3g/yaJ6h56kapULut3yoRQ72OnqYOu/ze2/OiNHaW/QC8h2DXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714028; c=relaxed/simple;
	bh=aALxbmLdA+7ihN3Ilx8+3woHpcDWh+R9uhx9M9KIftc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOTYDvyyIV0Pu9BD+JEkRP8NykbawPU7q6b3XCBhxZ1gFW52EnK8ixd7wLw+EhTET0nkIYexonJd8mFdljamQNTeWeMy/lpPiP8VtMmydEOG5ttDaN+fsof3HRGMR6u/32A+Du5OzW1AWabTbrW9sBj5wxVQaJbET5/VSIRHt1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJZJlu/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJZJlu/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6F3C4CEEA;
	Mon, 23 Jun 2025 21:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714028;
	bh=aALxbmLdA+7ihN3Ilx8+3woHpcDWh+R9uhx9M9KIftc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJZJlu/1SIan69WGbPQdT7AeAUJWB8lQoJUrkdo3b4sRTfaF9/Ym2JtzBSDxi4tq8
	 7Qm9AAxBxCTQOw4UkPzW6J5dlkLpBXS/mcnoOseHBl3jBElXcBnTLstfnB+9wlbUBe
	 C+vL8hTNhtpLnVl7GMWU08tLR7SiCqmANgWi5AVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 359/592] libbpf: Check bpf_map_skeleton link for NULL
Date: Mon, 23 Jun 2025 15:05:17 +0200
Message-ID: <20250623130708.982154406@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit d0445d7dd3fd9b15af7564c38d7aa3cbc29778ee ]

Avoid dereferencing bpf_map_skeleton's link field if it's NULL.
If BPF map skeleton is created with the size, that indicates containing
link field, but the field was not actually initialized with valid
bpf_link pointer, libbpf crashes. This may happen when using libbpf-rs
skeleton.
Skeleton loading may still progress, but user needs to attach struct_ops
map separately.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250514113220.219095-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 147964bb64c8f..30cf210261032 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -14078,6 +14078,12 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
 		}
 
 		link = map_skel->link;
+		if (!link) {
+			pr_warn("map '%s': BPF map skeleton link is uninitialized\n",
+				bpf_map__name(map));
+			continue;
+		}
+
 		if (*link)
 			continue;
 
-- 
2.39.5



