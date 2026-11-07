Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062868;
	b=dIrTdf/oJ4BpJiod514rHNndvrrncWRcKR2qQpLPshvDDiWx/7hBJqOZIkvMjKMBswzU
	 lLfuklxuY0SakGA7qwnYvImo0OoPij7MtpRKEB9nQpIoRY5B918vk5o4PtB6NyJMn/PNT
	 0K2YGjENm97csAQ0Y3ULAEZ/1O9P+3+0MrhLNMPNy8L4PJ2nnihy/p/+vtC+jslid91Y1
	 IxatxfbhKSh/aTlSsJW7D03OCYKzL5zHbUXnfggzyyeLIo+bWpR4MDNGn0BauAsfonM22
	 GQW/40Aq2b0cQVjwZQRxKU+SSyfa0j1oX6uxBHdDWC6sACrARNgLcXjpG1TV84BY4pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3wDCLEskeYTZg7FuGblA00IozpDyD6uwKWXaJ/SOvHE=;
	b=miSzemW0LQ8S/tk7N+tLmcJwlI+Y8YdcVJgwtUXdq4+xQxyeCKZu+hyMBmHooKVOqY83
	 qEY39Ti2GYltFdDFDqfdjjCkj2V9ciTUh4vBBjWotrZEPx+CmEWuHLPxsnzlv+Mht7ZnE
	 uQ02WMJtSHRwY82yIpnRH8RJqnA9m6r8/4AvSvLo/N0+mpHtEKwU2aemH2ZOWFfMZwqFs
	 4gG3BOPCPDAEGJm9/IkXoxTZOD2UO9saXxeyJDfs3gVG/8gwQb3ktvlrHuv42LWwAAVYF
	 FGJ0lT7OQhYoumx84WOXK7UJh2n9nplzR4p8BYwNDm/zj7DBiuFgefTlNfgNLG9O+YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okhDVCxS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D23606A335;
	Sat,  7 Nov 2026 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okhDVCxS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5DD1F0089F;
	Sat,  7 Nov 2026 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062868;
	bh=3wDCLEskeYTZg7FuGblA00IozpDyD6uwKWXaJ/SOvHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okhDVCxSk52OmQDkmpwUNJBghHgutHjXpIpkauORFYjxrnGRx+6PJnQx26M0LENNu
	 n3AxQbHPli/ymzT+7O65dPmlk/b6ZoK6p3MsOagSB0HufoLJOkgKcyrNni0p/+7oUP
	 V+cYmFwZEaM+v7Hz5WdEvBwH/Dc4p0ohvS17v51k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/869] md/raid5: track disks array size to fix extra_page leak on error paths
Date: Sat,  7 Nov 2026 08:47:15 -0500
Message-ID: <20261107134857.514526212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Cao Guanghui <caoguanghui@kylinos.cn>

[ Upstream commit 5028ceee173bfcf844469cfb0d1c151d3f6d0296 ]

free_conf() iterates conf->pool_size entries to free extra_page
allocations, but pool_size may not reflect the actual size of the
conf->disks array.  Two scenarios cause a mismatch:

1. setup_conf() early abort: pool_size is 0 (not yet set by
   grow_stripes) but conf->disks has max_disks entries with
   extra_page allocated.  The loop iterates 0 times, leaking all
   pages.

2. resize_stripes() Step 4 failure: conf->disks was replaced with
   a newsize-entry array in Step 3, but pool_size is only updated
   on success.  The loop iterates pool_size (old, smaller value)
   times, leaking (newsize - pool_size) pages.

Add a dedicated disks_cnt field to track the actual number of
entries in conf->disks.  Set it immediately after each allocation
or replacement (in setup_conf and resize_stripes Step 3, where the
array is safely stalled with no concurrent access), and use it in
free_conf() instead of pool_size.

This leaves pool_size untouched, preserving the check_reshape()
retry behavior that depends on pool_size only being updated on
full success.

Fixes: d7bd398e97f2 ("md/r5cache: handle alloc_page failure")
Cc: stable@vger.kernel.org
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
Link: https://patch.msgid.link/20260827080341.112296-1-ghuicao@163.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 5 +++--
 drivers/md/raid5.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 56d7e05e94ce6..fded4b3eb88b9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2627,6 +2627,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		} else {
 			kfree(conf->disks);
 			conf->disks = ndisks;
+			conf->disks_cnt = newsize;
 		}
 	} else
 		err = -ENOMEM;
@@ -7405,7 +7406,7 @@ static void free_conf(struct r5conf *conf)
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
-	for (i = 0; i < conf->pool_size; i++)
+	for (i = 0; i < conf->disks_cnt; i++)
 		if (conf->disks[i].extra_page)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
@@ -7588,7 +7589,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	if (!conf->disks)
 		goto abort;
-
+	conf->disks_cnt = max_disks;
 	for (i = 0; i < max_disks; i++) {
 		conf->disks[i].extra_page = alloc_page(GFP_KERNEL);
 		if (!conf->disks[i].extra_page)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index eafc6e9ed6ee1..fa9647a862add 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -668,6 +668,7 @@ struct r5conf {
 	unsigned long		cache_state;
 	struct shrinker		*shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
+	int			disks_cnt; /* number of entries in disks[] array */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
 	struct bio_set		bio_split;
-- 
2.53.0



