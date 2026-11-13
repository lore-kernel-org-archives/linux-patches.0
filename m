Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591073;
	b=S83zrkRy1bYouiFlqhuGfjm5iUFgka1Nb9KwBTIO/VYzjuTyUOOSegXjOeTO7arfBxBs
	 XK37Zjfyv9zw5SEG0OCVDOuQYX2IJf1QrMaYNK8OdHnrSOP3WqJ0iQ8+V90a9rfHpyjtW
	 IVrJ4Jj5s2RKkleBs5aZjuplV66C4YLYlAquVg72UkVR+D+BjKkSJnLiI39YPPxnmdLwg
	 Nj4gwseYJw7iH0UIVXVxOZZm5qQB7yL895DRTC74SGxK0cCEj17Lm5fogQ2yS6UaIWgxo
	 zOrU4ce7GyOI1ZhjRDr7v9NIrL373en/T3tTtzuCJrjfHeOd51O8+Ct/KAwdBqNWewg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TPRbzU5yGLzwKbPDyAHwY6tqc4Q7YvYInkCbAG+gYAs=;
	b=mfpgK0NbxQzYwJ2eOGO0Tvh+GCcYbCV31XxiP6MYot9fTPRuIFl4igl2ox6lRCGF5ofm
	 RWqLqGQGKKmpRd7gbs2fCL5zQMMFwKkRzeCzvEbvC6mQ2u1O89OaksqdWsRYJhuUJN5jD
	 1kGj+ce1HNymHVimi22R7slWprV1IZPbReCkgiJ4L/Ujww8PWK1vwi9kVLBB58jB+edBr
	 KsS5f5v2kwfuRMlQ3Qw0SvIMErHBeXm+di5UH5C2ERoOCzUEXawP6paHRIc29rMFM62n1
	 9Y2+d4wnFw90fuMQls5qa8/roykZpMkDr0YwmtmzfmdWIK5/HPxt5DiGw4pBZfoWevg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUCvA52H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF75606B83B;
	Fri, 13 Nov 2026 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUCvA52H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D1A1F000C6;
	Fri, 13 Nov 2026 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591072;
	bh=TPRbzU5yGLzwKbPDyAHwY6tqc4Q7YvYInkCbAG+gYAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUCvA52HQu2UIPajcFMfYuxxb/JZZF+qEkSESaOJoNLd8q7NjjQwfyG8TpP7kixNE
	 wbTEN8QtFQsgFX4LkT22QwENJZe6czG4K5d3pQeiNpFfoNrOflb80QwSSouxUWyLBu
	 XAJGgbQcxMyrjugtaRdkQMhwtWh6qp+Zc1ONeTZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/670] mm/shmem: fix truncation of files containing only swapin-error markers
Date: Fri, 13 Nov 2026 10:46:34 -0500
Message-ID: <20261113153819.656636634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 59511d630a6942356ac4b6984797998a8f3a9017 ]

It might not be very common, but we can end up with shmem files that are
composed only of swapin-error/poison markers.

Such markers are not counted in info->alloced. Consequently,
shmem_setattr() can skip shmem_truncate_range(), leaving the markers
behind.

Truncating the file to zero and growing it again will result in reads
failing with -EIO instead of returning zeroes.

Check whether the mapping contains entries, in addition to
info->alloced, before skipping the truncation. Keep the info->alloced
check so that shmem_recalc_inode(), called at the end of
shmem_undo_range(), can fix up accounting after reclaim has emptied the
mapping.

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-15-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 28157cb2e4cec..986d667a3bb92 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1285,7 +1285,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-			if (info->alloced)
+			/* Swapin-error markers are not counted in alloced. */
+			if (info->alloced || !mapping_empty(inode->i_mapping))
 				shmem_truncate_range(inode,
 							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */
-- 
2.53.0



