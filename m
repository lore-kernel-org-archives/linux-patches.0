Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB1C438FEE;
	Tue, 21 Jul 2026 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668320; cv=none; b=e1ls6DgaJjw0IvI0QChy99FRxAW1n8GKzJlLfP6Gugyf+hz9feoa+W+ozg1ggVvCVVV95OvgDFn8PPEkKK9sCCSDymyX2oWuWnPKcezW6Jp0P4A2QzV2619RJlYKYUl+XvYkGT7qWzdFZPIDfyPi0vxK1XXWuobfItsZmg/0pQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668320; c=relaxed/simple;
	bh=uk48HsZFFhFoy725f9E4jJokvXXjwlyVe5zMzMxzBMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orwBnf7aJ9wN1YKWHKNz69IKq0Ls3uuXTmIyLmpRZBn2Hn8n+4YEWF6m4bld/g69S59FH0Dt1/mP9J9vp/1Hf3n1Sobj/kZGFycnJQo6MQuwaGEEF/mAUkpdyQPEqhgPF36suTXm3Y37gSLDxHKQNnHhJk8fUqakdgspOghf9Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzWXvKIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzWXvKIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF56F1F000E9;
	Tue, 21 Jul 2026 21:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668319;
	bh=yoZkkeb/1yWhRfy7KCqOKFRz72EVskmulm4mSzsZCWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzWXvKIqi9qJIG25sz2314xeaR7Gk0JKYXW8ofCT3y+3jx7lJi+of+jRzI15smyYH
	 m8MQoN8mzVj5zD0yEfowU8wXSpkFTZd77nmIJUISmCeLQChJikP6k/pYBg9FzgsQqv
	 ov97J1NN573WF2SshpH2VTWI0lSGckaMlJH6ktmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0130/1067] Bluetooth: btmtksdio: fix infinite loop in btmtksdio_txrx_work()
Date: Tue, 21 Jul 2026 17:12:11 +0200
Message-ID: <20260721152427.500222813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -605,7 +605,7 @@ static void btmtksdio_txrx_work(struct w
 			if (btmtksdio_rx_packet(bdev, rx_size) < 0)
 				bdev->hdev->stat.err_rx++;
 		}
-	} while (int_status || time_is_before_jiffies(txrx_timeout));
+	} while (int_status && time_is_after_jiffies(txrx_timeout));
 
 	/* Enable interrupt */
 	sdio_writel(bdev->func, C_INT_EN_SET, MTK_REG_CHLPCR, 0);


