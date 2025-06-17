Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A764A2ED171;
	Tue, 17 Jun 2025 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175584; cv=none; b=FBEhLM1pG5DNNOyfYDO0sqTA+ICBwFOj+nv1umHGvidvP6kbm9bDUgdlz2rLcFlO4et4mZIyLPH13w3vBHiiksiojtKizTE3vLJ0xJWjfqbbZHHdALCcLVhj/Su+3Flr90pc9eJNBL87qhiyNRM5x22QOjyfTWaSt77R3r8jJpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175584; c=relaxed/simple;
	bh=Lb9wUdGJOWwO6l+rD3D9BvrPLGYBux4Bvmn6fibytEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZqFIyrDDteGc7J7s9SPOaxchx/fayDGhPN4A/A66lTR6dvG1+tT8H+/wEJpc8wIm0qsn1Q0Z/td3sVdx72c6VKM3v0tWkLa0MZbRS9OsOr0XMoO+/Oi9upFmE7/0Rwc/oAVSOHLASwFGSm+u8+fTtlUkVh1nCFOyTXRv6fVfeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7NWbiaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7NWbiaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174C3C4CEE3;
	Tue, 17 Jun 2025 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175584;
	bh=Lb9wUdGJOWwO6l+rD3D9BvrPLGYBux4Bvmn6fibytEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7NWbiaVozJJzG/WOyDtReCv+oa7taZ00E3QSpTzNB7+RaYCE91GkhoqV4OJfd2iL
	 KuF051IqYbpkdLVToQSa2ERaIu4Ymr0WFfYO9YmbdvdYdQWyHsHVRq1lBORwDb4H+w
	 GqTCoBYN9t9AVkVDitrlW4mc2cD5/F0NwrZO42WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/512] libbpf: Use proper errno value in linker
Date: Tue, 17 Jun 2025 17:21:50 +0200
Message-ID: <20250617152425.439885117@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 358b1c0f56ebb6996fcec7dcdcf6bae5dcbc8b6c ]

Return values of the linker_append_sec_data() and the
linker_append_elf_relos() functions are propagated all the
way up to users of libbpf API. In some error cases these
functions return -1 which will be seen as -EPERM from user's
point of view. Instead, return a more reasonable -EINVAL.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250430120820.2262053-1-a.s.protopopov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 179f6b31cbd6f..d4ab9315afe71 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1220,7 +1220,7 @@ static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj
 		} else {
 			if (!secs_match(dst_sec, src_sec)) {
 				pr_warn("ELF sections %s are incompatible\n", src_sec->sec_name);
-				return -1;
+				return -EINVAL;
 			}
 
 			/* "license" and "version" sections are deduped */
@@ -2067,7 +2067,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 			}
 		} else if (!secs_match(dst_sec, src_sec)) {
 			pr_warn("sections %s are not compatible\n", src_sec->sec_name);
-			return -1;
+			return -EINVAL;
 		}
 
 		/* shdr->sh_link points to SYMTAB */
-- 
2.39.5



