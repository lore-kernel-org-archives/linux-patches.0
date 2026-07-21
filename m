Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F011C40803B;
	Tue, 21 Jul 2026 19:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660731; cv=none; b=lICIk2Yu6sRDt6m8Mjd3PbYgPupFu6cmn92ybdEM7YyPP93WQ9DTJPhxJ1aw5fC000F33h23a32Ye5lsIS6zZSD3dOlS7YaLGjsASwofYuv/SbON5+doqzPtjmEzAdi5oCdeRc0HuOliTNOVBmdIkwaNNQ9qVzCbRJtq7ueE3Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660731; c=relaxed/simple;
	bh=A+s7m4Hji2YyiKCOWRpQ9JXavVLKQI8QVPGjAG0TOVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQOSoCbze67iGpxjn08+06fI+YM0Q8nNcfIOjSaVIt7woBmWaJy+ktQKX1YPasodersEwqmyFuj9q5Jaj6w5AEm3vZICHLof4p1ipDsSYnwLEzDEiSFAHCAqQiem9NKpIJMh+f/OC7q1PECskaXRsA4FqNr1mBhWH4yGXPp6bJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnlCTelH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnlCTelH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C78B1F000E9;
	Tue, 21 Jul 2026 19:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660729;
	bh=mgalsuU1BQzAPph5645nzgNaZaW3twXuCAwvPGtxx6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnlCTelH1RBRcAHtH/M/f9X/5GnF31wrLOExRh7G5INN3uO9FfqJGkyJgOjeXjabx
	 lT+M5aZ9h07L+MuTrfn7/g+oQxZogAaPqvnsOz2t+36helvNRXLsxqIRZyOAUT4ZdS
	 qyFVs7yaxwd0fUViegN8fdAeDVQucQDkXeKzv9CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1089/2077] erofs: call erofs_exit_ishare() before rcu_barrier()
Date: Tue, 21 Jul 2026 17:12:42 +0200
Message-ID: <20260721152618.509388168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 289cf458a69ccda4a4aee2b0274d233d415814ca ]

Ensure all inode free callbacks have completed before
destroying the inode slab cache.

Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 802add6652fda6..579443e6acfeb6 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -1048,11 +1048,11 @@ static int __init erofs_module_init(void)
 static void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
+	erofs_exit_ishare();
 
-	/* Ensure all RCU free inodes / pclusters are safe to be destroyed. */
+	/* ensure all delayed rcu free inodes & pclusters are flushed */
 	rcu_barrier();
 
-	erofs_exit_ishare();
 	erofs_exit_sysfs();
 	z_erofs_exit_subsystem();
 	erofs_exit_shrinker();
-- 
2.53.0



