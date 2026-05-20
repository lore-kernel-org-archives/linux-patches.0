Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8FF221F2F;
	Wed, 20 May 2026 16:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295225; cv=none; b=WZj4y4n3NYwN8TuAGawDd7QyLX06fQE23i28PUrnhjGYWqtWV1bDvso6d5oGjSk9G01lz8MyQhfI7/qsCOIqWIWEvKQsOn8kAdHTw76ykFpGXU874QpVzWFQPirkq7dVUT3v5a0FEatmv6uePpoV3HrqntEIjEm8jj5inVYM/JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295225; c=relaxed/simple;
	bh=iX1IWoK9B0t7Y1zBGvCvviJ6ZarSyoeu+eNg+fpeTNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPIUrkDtelcr+HHC6q/QhGz8AfT63M9raTzCJLYoue0BCogtdHRmFbH8DuSj/Qthqm9G/jfJY4374m1atxBPTUquX+LVa78NPMkSr4/bjR7ruF3uYs2mi1XfRIsV7hYLJ/uQbm+LVQc3lcrEspMyj5IKOGxmFpRUuviNR18i+yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBhWO2QK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBhWO2QK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D9E1F000E9;
	Wed, 20 May 2026 16:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295224;
	bh=JqoCCR/MPuGfdE2Mn1sI9rvJPKZc+kbmM2zR8rtwsM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBhWO2QKrAOyTRYcDyHvpCiVy70uaPk5NW8KmuXe0GRNwNqL/7rzk8Mfy1J6etaj0
	 GiqKXnZk9xnc/ZftWqAXzTymgs7Ve3K3xTdw9bUuXpOwbStxVia6PD4LO92DFMR3Lh
	 3atEz5mtuppLGdgyMAfrwMBBv8K4gCvoc/gu65x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0301/1146] dm init: ensure device probing has finished in dm-mod.waitfor=
Date: Wed, 20 May 2026 18:09:11 +0200
Message-ID: <20260520162155.021151462@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7403823384c57..c1bacba92c65c 100644
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



