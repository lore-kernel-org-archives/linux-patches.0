Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099EC369D7A;
	Wed, 20 May 2026 18:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302022; cv=none; b=L1RRpgLQdpSByCO8v00PrOSh2lcUIs+F62/syQty8REJlleSbCu5qoSa7isCpM3xdNuw1VKtn6MYdFa/cAZQwjnHRo6/16EBtNA8XNvYHdD+LKFeEpGhAqEb2JpAjh9FVyjUoPGC0E9tB7AczFNtE7ogtv2gPWgBfBijaIDGAHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302022; c=relaxed/simple;
	bh=eLwCcuhVx/K3C5hUFjRYDDYP1GI8B6qaxEaE3BFRa7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfEuOPRiLatT/edZh6LfOB/wUBeQcaZ5s/WQNHI8QTdV0S54OjLJw7+ajNr9IfB5o4ev6VHrupe0au7rGPEJOaXMwpuL/buZ1ikx2kvr4iJvccw/z2moFcyq7ccRAJKX7agfMqq1p96jMOGyTqtTVG2r9l9elaovyUA7qj+q3OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysgQuzAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysgQuzAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FF31F000E9;
	Wed, 20 May 2026 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302019;
	bh=qMVAmlOibqfRsvM51s13j5XvEred1xHLM+s1ixZfgVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysgQuzAeSXHNGOWyUV+Zz20c3E1s9kCdVai/DAEwd5q6kd1YfZqcIgR8FimkjE6ZR
	 m+p1ROB716U7XO7Lom+ZwR+JBYIvO6m4cj7MrJJG7289+lYnqL27XSdJIzh4/2ra0Y
	 hYIuClKjMFfs8ziN4gSDJKypYuiZ0s6WkH+9R+T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/508] dm init: ensure device probing has finished in dm-mod.waitfor=
Date: Wed, 20 May 2026 18:18:50 +0200
Message-ID: <20260520162100.940667378@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



