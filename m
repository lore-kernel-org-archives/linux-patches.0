Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD531F8697;
	Tue, 17 Dec 2024 17:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455766; cv=none; b=sZl7VvxhPlz8VzapFPtKj1ImcPAb67EYXdh/cNOgIvSP1tl1I9sjFB1bGpZpTeB+ecEaZSJdhJ8Iq+RH9q7cFcuT+F3S6yfxkezlDi78nCoBRKSoI6YnUWS65GiDNUXWc+NirGxoelrhBrwF9LvB5Tyz05h0yaHpcLIq+0a09B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455766; c=relaxed/simple;
	bh=HuUAIlXDU6Q7dykYoO4U2rcBAXNztwJOSxKUhVAfB8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkGJeCziwhWjAjQ5/gA+Bo2nIPOFhB5FZINrZ+G8yYRBC/+JZYDdMMOVvq6WN1vgqIdWIEurGvYQ+KR/KlvGk+bQeeKwhIB3sYZHkMN1qPuvZ/n08Axc38mVGFLaWhDeAfi2WUo52BXJq32euNlIusquuoqV04Yg/PbCQZ9dFxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7BrVZck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7BrVZck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435B4C4CED3;
	Tue, 17 Dec 2024 17:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455766;
	bh=HuUAIlXDU6Q7dykYoO4U2rcBAXNztwJOSxKUhVAfB8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7BrVZckxkgfm11tRPUhM39spN0s7kmakGUxGyWooAlvRBNgjpwj7Qfmm08tAfJnC
	 lRgG0eF/kVnOtH0r+5NxpKye+dWqtC2gI/zlw3b4W+NGU21FMAF9eiM87MN65kP2H2
	 9MKsUS/Hi9Kd1vzf3hn/6dKfPeJsl0aRwiztWclY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+412a392a2cd4a65e71db@syzkaller.appspotmail.com,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.1 26/76] exfat: fix potential deadlock on __exfat_get_dentry_set
Date: Tue, 17 Dec 2024 18:07:06 +0100
Message-ID: <20241217170527.349247823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -870,7 +870,7 @@ struct exfat_entry_set_cache *exfat_get_
 
 	num_bh = EXFAT_B_TO_BLK_ROUND_UP(off + num_entries * DENTRY_SIZE, sb);
 	if (num_bh > ARRAY_SIZE(es->__bh)) {
-		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_KERNEL);
+		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_NOFS);
 		if (!es->bh) {
 			brelse(bh);
 			kfree(es);


