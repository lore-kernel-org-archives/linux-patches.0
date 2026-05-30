Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8512FDC5E;
	Sat, 30 May 2026 18:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164060; cv=none; b=QOOFDVBBPVqdgjG1stA5xPkMNSPqdIHU5tm2hhFT6ZVbiTchYCdiFWCrpSuSaS7qtG1wKPuWBJofZXZ+ozfn9MUAWIdgkM3Kc1xVlZl704Uj4T/fp+kFpaRrefirlZUx/8p4VlclbXjgaBeVeMCdHHcGZMY9aldj6/pvNqpX4pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164060; c=relaxed/simple;
	bh=pGFuRwKxKRPwBxA5Q5H4jSX8mUXHiDdySHTQV1QAPKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+x+zLUdALBbQ8uHseZ8s3ECZA5mQnMBbPyMkofv21BzbAXVXwhcSJFKegHv37GP40/zkLrKNEi7ifiOr2c2beEi/SAjyfMWact9xWxvH4qGPzp4EHGo1Q5oq3fMY5RNvOgCTaal0gIrj8itxUed5B1M6ATTj8d0dUugCRwjtyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QntHiO/y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QntHiO/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB8A1F00893;
	Sat, 30 May 2026 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164059;
	bh=SWUQ/DeQMN0ZHckVF+uw9JXR0hlnMl/TRjvP99PlKVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QntHiO/yXYwhL9GtbLg39oLHMMsXPeNII7XvKU1o18CNcEyKjs1Lu3VuGBs12eEWV
	 duT/o7ragrZ10jgsXLLCiV/QtNKg2z7rZbdKLOGhrXI+69+MJZn0w8kx1aCGO/zjnO
	 nal9Md+rbZQfFG8jREBkzYOhnS/Ql/9QPyrO8BjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/776] dm init: ensure device probing has finished in dm-mod.waitfor=
Date: Sat, 30 May 2026 18:02:37 +0200
Message-ID: <20260530160251.859931935@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6e9e73a558740..882dc385cf068 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -302,8 +302,10 @@ static int __init dm_init_init(void)
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



