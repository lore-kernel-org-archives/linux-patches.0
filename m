Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F51A76A7;
	Tue, 30 Jul 2024 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359853; cv=none; b=lXrWP0nKEjCKX0tWoRfsuFfaVMfd/pxrnQ9aGTMA4bnKNAo8VBKiNSKbAiRIbSZ3X6AeIM6to07jABfSzz4ycN4CL6qdcvEC+qB+HakJkC86cxW0/Ea1qH1t9S534JaeTW94HUO9fmemMnZzNw1Dk4kT7ToHYrv/rqMX6LEd0bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359853; c=relaxed/simple;
	bh=ahx8Vdp9NlT6ovlhRKbsb6BjhKiK1USLNOsqvBJ506g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsKtHWnIDdBFZx23TEbaaJOX66JEr5vtdQJqZrvn7y5LmCIwFYLbaSH5RWYWotNGTdLZ+aAsJsVQbBgbKi4V6LyYNfQ0r2Xvf5cC6xZ/sbT+FxLFAsSivLgFbA3U6UbIIzf6sGl3cVbKvT6AQSMdOP8AkrI6bD7tNXB4YHk69SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvxUXJhn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvxUXJhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9430C32782;
	Tue, 30 Jul 2024 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359853;
	bh=ahx8Vdp9NlT6ovlhRKbsb6BjhKiK1USLNOsqvBJ506g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvxUXJhnL6uWc/F9YzdpzNyAeDUv7yEcDn6S9ciTTEBWDl3byxiR4QZhYsk6ol5g3
	 eqaS9F553gSYjLyGDO/6pO7ntd84bDbYWjl233FEBUKq26lKSRxKHSjCmI0TjENIPT
	 b6hQNkNECe8JJ07qUBVbbdP6yZrfJbkTopqtHoTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+412a392a2cd4a65e71db@syzkaller.appspotmail.com,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.10 545/809] exfat: fix potential deadlock on __exfat_get_dentry_set
Date: Tue, 30 Jul 2024 17:47:01 +0200
Message-ID: <20240730151746.278683112@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungjong Seo <sj1557.seo@samsung.com>

commit 89fc548767a2155231128cb98726d6d2ea1256c9 upstream.

When accessing a file with more entries than ES_MAX_ENTRY_NUM, the bh-array
is allocated in __exfat_get_entry_set. The problem is that the bh-array is
allocated with GFP_KERNEL. It does not make sense. In the following cases,
a deadlock for sbi->s_lock between the two processes may occur.

       CPU0                CPU1
       ----                ----
  kswapd
   balance_pgdat
    lock(fs_reclaim)
                      exfat_iterate
                       lock(&sbi->s_lock)
                       exfat_readdir
                        exfat_get_uniname_from_ext_entry
                         exfat_get_dentry_set
                          __exfat_get_dentry_set
                           kmalloc_array
                            ...
                            lock(fs_reclaim)
    ...
    evict
     exfat_evict_inode
      lock(&sbi->s_lock)

To fix this, let's allocate bh-array with GFP_NOFS.

Fixes: a3ff29a95fde ("exfat: support dynamic allocate bh for exfat_entry_set_cache")
Cc: stable@vger.kernel.org # v6.2+
Reported-by: syzbot+412a392a2cd4a65e71db@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/000000000000fef47e0618c0327f@google.com
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -813,7 +813,7 @@ static int __exfat_get_dentry_set(struct
 
 	num_bh = EXFAT_B_TO_BLK_ROUND_UP(off + num_entries * DENTRY_SIZE, sb);
 	if (num_bh > ARRAY_SIZE(es->__bh)) {
-		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_KERNEL);
+		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_NOFS);
 		if (!es->bh) {
 			brelse(bh);
 			return -ENOMEM;


