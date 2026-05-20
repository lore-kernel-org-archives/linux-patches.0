Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9FF3A6B6D;
	Wed, 20 May 2026 18:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300378; cv=none; b=I6z/tSeVo+fRMT8S1UAxUKLw3P6SnYZMvn875sJfyxPHqY1vPv+VPPvn8PsPQzDG2MIQx1Gf4xuWgDqc17fPhDRZ37IR/aNCfpUfE3C9RygtL72fpAVJAmfILxt8ZI1RBxKk1hB40kL8ERqtUiMX8UCSTBxl8jlelNbJ1vp760M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300378; c=relaxed/simple;
	bh=n+K0zeDeGAG3uf91c/pJ4839aedqWkBYIaCYOq/rCk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZp6sudRtQeyCZ0lfmKgv3scJ1K0dga0EKVua8ynff+zGch2Rxc6OP6jSmGYeQO8LKybO4pdVyc3MUPJiSspVt9VjWsJ5l0svEK7QLfAKakYafCG2rcYm1GHloDZQ7bDd1GBswgSV5cw+8RhwUL9NJvw/zwzZqyCyA2uMt5adhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGds4StA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGds4StA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029C91F000E9;
	Wed, 20 May 2026 18:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300377;
	bh=wS3yCGXUQ8TjF2yKvrdtUVcHcBgaftyGvt8zVuyJRTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGds4StAHRkgtuFP24WMR8kyn9CKSc2bw2DuThFvLW9iopdxMACYWrLphInWWBJt6
	 ZnmaLwPJ4UMfmscTrIumcSwJwbbk3RkTZx/ak0e2Wb6oaVSBwgidBW4Hbs5dvFazJX
	 9XtIFOPQ5AK6Z/WnnaHk+0526r3UCKW/lPvzhVAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/666] dm init: ensure device probing has finished in dm-mod.waitfor=
Date: Wed, 20 May 2026 18:16:02 +0200
Message-ID: <20260520162114.481032426@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Gonnet <ggonnet.linux@gmail.com>

[ Upstream commit 99a2312f69805f4ba92d98a757625e0300a747ab ]

The early_lookup_bdev() function returns successfully when the disk
device is present but not necessarily its partitions. In this situation,
dm_early_create() fails as the partition block device does not exist
yet.

In my case, this phenomenon occurs quite often because the device is
an SD card with slow reading times, on which kernel takes time to
enumerate available partitions.

Fortunately, the underlying device is back to "probing" state while
enumerating partitions. Waiting for all probing to end is enough to fix
this issue.

That's also the reason why this problem never occurs with rootwait=
parameter: the while loop inside wait_for_root() explicitly waits for
probing to be done and then the function calls async_synchronize_full().
These lines were omitted in 035641b, even though the commit says it's
based on the rootwait logic...

Anyway, calling wait_for_device_probe() after our while loop does the
job (it both waits for probing and calls async_synchronize_full).

Fixes: 035641b01e72 ("dm init: add dm-mod.waitfor to wait for asynchronously probed block devices")
Signed-off-by: Guillaume Gonnet <ggonnet.linux@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b37bbe7625003..423269cbdd2bb 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -303,8 +303,10 @@ static int __init dm_init_init(void)
 		}
 	}
 
-	if (waitfor[0])
+	if (waitfor[0]) {
+		wait_for_device_probe();
 		DMINFO("all devices available");
+	}
 
 	list_for_each_entry(dev, &devices, list) {
 		if (dm_early_create(&dev->dmi, dev->table,
-- 
2.53.0



