Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5D51A6195;
	Tue, 30 Jul 2024 16:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358474; cv=none; b=Dw18X1h5/RGVavAYUI0VvTATY70eImAx9HCZnyoA58xp2Z4dRWQ7aIfQifgbf44atfY+R16fC3Cm1N4pkPDXP+4N54iNo3tU19yAvxV7XtzGpkQYK4XnsUuiVNlixfMBPeI/qHLUXaeu2VOfLqHD2xsGJJsFlFlCmd3JZOkOg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358474; c=relaxed/simple;
	bh=fuVksvIHhXtE3jbER/w6GXrHJaWrxlBvEUBQ39NBm9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guC+T+gVP8Ft9lfhNvKlplC6TaAJZLdHUzW/CL4CvDiEVTpehjtLkwzcGLoGZ+Pgkkg2ZqeCjGL9uOiqfoTzscLboCqEPPCtUc5zo+aYprdXLW21vBMT4EqKMyj8ZYeSzj736gdVbkAKEphlSzlzoIw+VhkVOcMCBcokyptLrAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgB1crV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgB1crV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9D7C32782;
	Tue, 30 Jul 2024 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358474;
	bh=fuVksvIHhXtE3jbER/w6GXrHJaWrxlBvEUBQ39NBm9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgB1crV3pxKZg9dCsZ7x80coOYi8E10bRjrobPEj3i/4Vyd3tTM76ZGN1HGODuOOP
	 xu1hfday56RTkTORoKiO/9+QaLxbgw3g8Q49YJXw8WM3EYYcVwk+2OLG8ajgSHtPR5
	 j81Hoqtl9t+QItkikcgMGEOcUOhV/K9lYqxbFcys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+412a392a2cd4a65e71db@syzkaller.appspotmail.com,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 365/568] exfat: fix potential deadlock on __exfat_get_dentry_set
Date: Tue, 30 Jul 2024 17:47:52 +0200
Message-ID: <20240730151654.127289235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -890,7 +890,7 @@ int exfat_get_dentry_set(struct exfat_en
 
 	num_bh = EXFAT_B_TO_BLK_ROUND_UP(off + num_entries * DENTRY_SIZE, sb);
 	if (num_bh > ARRAY_SIZE(es->__bh)) {
-		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_KERNEL);
+		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_NOFS);
 		if (!es->bh) {
 			brelse(bh);
 			return -ENOMEM;


