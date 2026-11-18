Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023642;
	b=ZYviVaJrDd8eBDk3AypCwREXb8OD0x6kTrYYbO74hXdTycc1h5hz3AxoS85qN/X8OjDt
	 DwqBi3sEJHle3O2AjmE5S1t+QrDDAZXXTHPln5ZHRevl81C0fZcwFtGnqHV7vvQYggEVg
	 x8igZclImqLCEAdYm3CqB8j9E8EXdXFRgUvuwOoJeJDJ+bC6yxy6I78AVxGLKda9zN7BZ
	 hy1rV0ulY8GEQaLHgCTJXOKQyTmltiHYnvNm8vS5zdAntcJp4mHxkAg3+M31VhxunxvSn
	 GqNu2GB4zp8IciqXi8vtPRnriLcNrKepmBhuwA95P4ioL35CcTjV4/33j8VxARViXoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Z2UC5q7rbjJsQPEVhw05na90ndYGMOmNAxYh9C2rhwM=;
	b=zs3HgSJ8r3NK2+EJHyidE7mvBfcIDu0aQj5EYzL1DlkErP3PpHSMyO4oCTlsc/cfx0/i
	 fuyGEoGBijPtPTfgm9pPZ7b91E9grMcFiSZJcIqI7/I/dYGdrFL/oz+9pzrQT7qXsgGXJ
	 ELRy6JyRrdynPZaAKOdQ+/ffbfRN5aflepsgC6PHSEcWFo3xq8GDha1HquXCi9I5JjMYF
	 x+VPC0MZVsmw6Icn8yBcyvQr2nipqsgWhse3auKUUXzcNVX9H+3g50epR85vMjYwcKdU8
	 OcqVIbz9T5YcfqpnBwqCnQKquUPbdXQrFwpKrQWaQwUSbdiwZReTz+zREOPrykZEfrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDkI5myD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B13606A325;
	Wed, 18 Nov 2026 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDkI5myD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED641F000C4;
	Wed, 18 Nov 2026 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023642;
	bh=Z2UC5q7rbjJsQPEVhw05na90ndYGMOmNAxYh9C2rhwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDkI5myDctqddRv7eCFleEKw3YHdfPX4ecWr1bsFNNqyDIPtPN1EFoMzBscPvRGUJ
	 EohJeubQYoVxLvELD50TBAtKFA4UQeFB3G6n2+DCc3zxQDG3vKZ4kgdZnyxgMJJgUR
	 WcpanTEcJVgmq4h+4S0JcZODxjZhLjEWBv4ljpJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0443/2151] wifi: wfx: fix use-after-free of the cooling work on device removal
Date: Wed, 18 Nov 2026 15:36:18 +0100
Message-ID: <20261118150138.175396400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 17402a869778f6c17b88fd360d7a96378779f97c ]

When the device reports that it is too hot, wfx_suspend_hot_dev() blocks
the Tx queues and arms cooling_timeout_work with a 10s delay. If the
device recovers a normal temperature before the delay expires, the work
is canceled. Else, the work declares the chip frozen and unblocks the Tx
queues.

However, this work is never canceled when the device is removed.
cooling_timeout_work is queued on the system workqueue, while struct
wfx_dev is released by wfx_free_common() (through ieee80211_free_hw()).
So, if the device is unbound during this 10s window, the work fires
after struct wfx_dev has been freed and dereferences it.

Cancel the work during the teardown. It has to be done after
wfx_bh_unregister(): the "device too hot" indication is processed by the
bh, so canceling the work earlier would allow the bh to rearm it. On the
other hand, the work calls wfx_tx_unlock(), which may in turn call
wfx_bh_request_tx(). So it has to be canceled before bh_wq is destroyed.

Note that the Tx queues are intentionally left blocked: the device is
going away, so there is nothing to unblock.

The issue was reported by the Sashiko review bot and the fix has been
written by Copilot (including the commit log). The use-case is difficult
to reproduce, so this code has not been tested. However, I don't believe
this patch could cause any regression.

Fixes: 1d52d29983e5d ("staging: wfx: add support for 'device too hot' indication")
Assisted-by: Sashiko:gemini-3.1-pro-preview
Assisted-by: Copilot:claude-opus-5
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Tested-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/20260906204831.949692-2-jerome.pouiller@silabs.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
index 4ca874ad26433..1f4695fe4fb94 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -487,6 +487,7 @@ int wfx_probe(struct wfx_dev *wdev)
 		wdev->hwbus_ops->irq_unsubscribe(wdev->hwbus_priv);
 bh_unregister:
 	wfx_bh_unregister(wdev);
+	cancel_delayed_work_sync(&wdev->cooling_timeout_work);
 	destroy_workqueue(wdev->bh_wq);
 	return err;
 }
@@ -497,6 +498,7 @@ void wfx_release(struct wfx_dev *wdev)
 	wfx_hif_shutdown(wdev);
 	wdev->hwbus_ops->irq_unsubscribe(wdev->hwbus_priv);
 	wfx_bh_unregister(wdev);
+	cancel_delayed_work_sync(&wdev->cooling_timeout_work);
 	destroy_workqueue(wdev->bh_wq);
 }
 
-- 
2.53.0



