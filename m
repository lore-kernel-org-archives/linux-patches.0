Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A94E47141B;
	Tue, 21 Jul 2026 20:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665088; cv=none; b=FPvPtYZGL2dM0Nj1yhrwW2zAubwhEcPeOXM2Ee3MmqDTJO9vTZJNNZaLYxWyTpRv4M6fhcZZ7+m+wMi7Jb+OGGrzpznVJJwePxbI7/TgmzFQ+QWwfkVZ8Fz1Ytk9pE3hKjgZgeZYucK38rC1XpXbN+crnZXrR3710nLSwjSgPmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665088; c=relaxed/simple;
	bh=AVvG+q8SfdPFkbtbksuj9m9OqmuUrdGl6CRnJJISzfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGfEBgZgg+J/vGqBTok2rs99kkVJ/Zdi6STdKcEEqGc2FtxSkJNdjdjaC0gdS1HcKxwLubWhGhpafUBh+MvmqHDg6zA6oulPl+7gwdkoNqrNDrxhOZcDLEAHaGJxKX4dbuX7j7TJdgYr/WSrsZJvTFnJZKBV0y/08EvnjOoYBb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhBmAV+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhBmAV+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8F01F00A3A;
	Tue, 21 Jul 2026 20:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665085;
	bh=qrDES21U2ehrovgZeNd26do/2QGgBkjI44RBkk70dwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhBmAV+Nu5UkiIk/N65jF2IN4c7tsg8epMQc1qBS+zFIdAIzlKocvZeRBSiXvMcVd
	 XupwRebL8Q7w3Ocm1YV8rJU3BPrURc+DgkTKWxS7966t7YC7pZhE3lY1LXGsHAtHTD
	 D0GesJOX9vYpu6SdlfU9PSUuTHSSmydR8wgMX6y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0170/1266] Bluetooth: btmtksdio: fix infinite loop in btmtksdio_txrx_work()
Date: Tue, 21 Jul 2026 17:10:07 +0200
Message-ID: <20260721152445.610812656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit a257407e2bbbb099ed427719a50563f67fa366d8 upstream.

Every once in a while we see a hung btmtksdio_flush() task:

 INFO: task kworker/u17:0:189 blocked for more than 122 seconds.
 __cancel_work_timer+0x3f4/0x460
 cancel_work_sync+0x1c/0x2c
 btmtksdio_flush+0x2c/0x40
 hci_dev_open_sync+0x10c4/0x2190
 [..]

It all boils down to incorrect time_is_before_jiffies() usage in
btmtksdio_txrx_work().  The btmtksdio_txrx_work() loop is expected
to be terminated if running for longer than 5*HZ.  However the
timeout check is twisted:  time_is_before_jiffies(old_jiffies + 5*HZ)
evaluates to true when old_jiffies + 5*HZ is in the past i.e. when a
timeout has occurred.  Using OR with time_is_before_jiffies(txrx_timeout)
means that:
- before the 5-second timeout: the condition is `int_status || false`,
  so it loops as long as there are pending interrupts.
- after the 5-second timeout: the condition becomes `int_status || true`,
  which is always true.

When the loop becomes infinite btmtksdio_txrx_work() loop never
terminates and never releases the SDIO host.

Fix loop termination condition to actually enforce a 5*HZ timeout.

Fixes: 26270bc189ea4 ("Bluetooth: btmtksdio: move interrupt service to work")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtksdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -606,7 +606,7 @@ static void btmtksdio_txrx_work(struct w
 			if (btmtksdio_rx_packet(bdev, rx_size) < 0)
 				bdev->hdev->stat.err_rx++;
 		}
-	} while (int_status || time_is_before_jiffies(txrx_timeout));
+	} while (int_status && time_is_after_jiffies(txrx_timeout));
 
 	/* Enable interrupt */
 	sdio_writel(bdev->func, C_INT_EN_SET, MTK_REG_CHLPCR, 0);


