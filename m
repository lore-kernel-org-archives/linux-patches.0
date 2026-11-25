Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622700;
	b=ofBQtuHqPL/wLGpDLOQwlU/JbEW0w+e99qHpO9Fw0F+MjkZaDiQAlbWql93U5dakhY5K
	 Vyc94qwsywLK6VgcvNjQvLdmDnwdlROeWErgTE/FaLGkcy4hL7bQ960SqHG1WYBuTJsiB
	 w/ZxklBhAPD0NyOzXq/TJZx7Y17t15lkYrb0OfoHAtaqvmCl52O57ygoWP/GZMN5blKX4
	 Z1PLU+qOjZw7Ie/XSib12Iot4HQRquJTF+uWBlqCcZ0N0JDUYP8cffudQqxj65X0Hz2rw
	 zLFmhI449xhULFzHSVHBVLwmduDaTDgWlFzani/ZqvMzhuB7ZHDoCkrXM9xuek7wPvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2jfprxTdcKKgQv14BENag4jGBYH4v+laOHmjZQ8jURA=;
	b=REw9O1/1EZmz6FsH5zerbAJTD6SWbh5NY2Hm7bjWEgg3Sl+NLdKG0lxK+AyaKroWT7NN
	 mhMLdJeKgvCZ1mU+6vF9y22zl5spwvVv+Fe8coCqXSHjW/Ddda98E1aHJt2aZm8YBvuGT
	 MPofhLwk22n6YMh8eP9AS8wOFRI1VPN3STT7o/QkOXKwNsREoJ//RxeGn+h6ALc2p2oQ5
	 kVh49p20EE/2LLp9RdzngsIlVRuk67cyoreA+cSNlhzDP9qLh/z+zHvt+tKRKXD5I121y
	 XZJaVjxblfjelCBtzfyEymOVm/2gZqpSPExlgfqvr5Ia8gZNaiJyCXv5BjjWm1kM+aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XclyehVE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A75C606A327;
	Wed, 25 Nov 2026 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XclyehVE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9ED1F000D1;
	Wed, 25 Nov 2026 16:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622700;
	bh=2jfprxTdcKKgQv14BENag4jGBYH4v+laOHmjZQ8jURA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XclyehVEUQaClTQroIqzr44m4+C9umw5knWhanoh8QqNnpcFn0qQjBBBSdtK4/Y/q
	 S+uFVqHenaYWvsGl0fLKaa0mj/OBZSoWFkjoDwXQLsTf4CpHGlXA9OfX7sz0rmchyn
	 klZLPuP78+kEO4m07MGt6TdH5WBXGYT0lk/6YCZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 620/990] exfat: fix used_clusters accounting during cluster allocation
Date: Wed, 25 Nov 2026 15:33:07 +0100
Message-ID: <20261125143836.623783863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit cb9dbf8a4e34b4fdf311598835ab4d76ed7e07c1 ]

In the current exfat_alloc_cluster(), p_chain->size is incremented as
each cluster is allocated so that the partially allocated chain can
be freed by __exfat_free_cluster() on the error path.

However, sbi->used_clusters is still updated only after all clusters
have been allocated, while __exfat_free_cluster() unconditionally
subtracts the number of freed clusters from sbi->used_clusters.
Therefore, when allocation fails partway through, the partially
allocated clusters are subtracted from sbi->used_clusters even
though they were never added to it. This corrupts the free-space
accounting and can cause sbi->used_clusters to underflow.

Increment sbi->used_clusters together with p_chain->size as each
cluster is allocated. This keeps the accounting consistent with
__exfat_free_cluster() on both the success and error paths.

This issue is caught by generic/476 with 256k cluster size:

    Ran: generic/476
    Failures: generic/476
    Failed 1 of 1 tests

    *** fsck.exfat output ***
    ERROR: <path>: more clusters are allocated. truncate to N bytes
    ...
    /dev/vdc: corrupted. directories 331, files 526
    /dev/vdc: files corrupted 9, files fixed 0
    *** end fsck.exfat output ***

Fixes: d5c514b6a0c0 ("exfat: fix the newly allocated clusters are not freed in error handling")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Dropped the blank line after the removed sbi->used_clusters += num_alloc; because this tree's success block lacks the done: label and uses num_alloc instead of p_chain->size. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 825083634ba2d..13a79845be016 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -431,13 +431,12 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 			}
 		}
 		p_chain->size++;
+		sbi->used_clusters++;
 
 		last_clu = new_clu;
 
 		if (p_chain->size == num_alloc) {
 			sbi->clu_srch_ptr = hint_clu;
-			sbi->used_clusters += num_alloc;
-
 			mutex_unlock(&sbi->bitmap_lock);
 			return 0;
 		}
-- 
2.53.0



