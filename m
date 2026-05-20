Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9444533D4E9;
	Wed, 20 May 2026 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297952; cv=none; b=TdS6ZajlQpF/3XioZ7jU/5Cn+lDPHN2X+TY53GSjwh0Z2yQ1qpDbvefVYifHJUAlxZxhuDAiDZp1IL/vQKXTTvBvLwpB4tE2cUrPzqMWbAqxvzFk/0LQN4Ce4Mh3vKWSG3VZK29h2M6gh+0hoGzUJKAl1I8EzlDZD+ngewiZt5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297952; c=relaxed/simple;
	bh=SXQIrYE2rogGsHb1O0DdKEivtxc3P3iLQvn3MqflMqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQcIA9DfCLQAs/uG5KIIFwu7kh8zVu1siNiqPTbRQfFH/Iivkm8nb0BxL3AR5Cdi424cr+nBLSV7X9gZuA35n8ItZyjeDLGICkwqxKrE44n1cxnwJTcFJfFLQ68k9cn5cz7Yzmi8ZviDA3KRupSj8jmTRZA1aLwY7BiT9ACTyUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0+O8qaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0+O8qaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CD31F00893;
	Wed, 20 May 2026 17:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297951;
	bh=sACauvA1TLlOm5+o1TppPcOLxRC/7IrbaWl9gBzVXD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0+O8qaZmyKICHtYs1gTrBytW/QUDzxq3Mf5qz/btsAP6OVihlO4pz3nqNufBOS3u
	 J5mf8zZCjUQVavJqLD+cNj43rpXoYLeyGoWfRrllNpcRyxCNfVV8zezBPCBLJ5Q4vD
	 UMUcRmYr3YiWUjx4/iBPx2X+SWE/vnnMLc02vObU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 227/957] dm init: ensure device probing has finished in dm-mod.waitfor=
Date: Wed, 20 May 2026 18:11:50 +0200
Message-ID: <20260520162139.462705197@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



