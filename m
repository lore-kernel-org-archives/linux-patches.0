Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039764;
	b=zcm8wOjATK9C38z63JG/shWs1cq0mdQniVyNceavrLdDGAMtlqbPN7ke1yGmT9izhd08
	 m7Lq3aKn5e3GIeb3yb/K7jVLLJ1I8eH6G83Lgjge17xLtlp3F7MWHr7TZfG2Cee3hPSqa
	 gMQ1j5ssaTMr+NeCp0YsqGokqbV1CgzKl8sO4o+V4WJZGSi0O4utf0nV6cljpUNyH9u9A
	 fqaS4pPhH3rVJwextB1UThIYbl3JmYuTVIDfYr9vNWZ1BegnBdf/rQIPDJrVACh9QmmgH
	 YCXlluvKM5qDNFPPdYvLBU2JPqihMYds9r8UNEOCpcBum+k6eeRTdgYcq5pC+XKsJ6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QluxIy3waJYXUrmpGdgNkhZLwVmYjKsYgvJ+HiOOet0=;
	b=yI9JKvr2kEfgR+Q+anFWfnxHUsWjZYs49Wegl6Lhk6Ni2J1VAZshDLa4hfI0S4N7awuZ
	 AnjXg8faXNI0mGcUlIb05h3LC2QWZxA1VyAbH+nSyrEtRxyqtEp9ayV7BDqT3egforoHt
	 39TTWB2InnVHBuj5MzqHkbMxrSW1aROlRD+US3zaXjL9d1KqiynnSqCLF+7D8vw4Kcrrl
	 TOoTK43OoO59rXQk1hjLtyhZec3PBgN4Rq55mcRGJEE8vrSdD04ig/d8ObvaaGb+uwuFQ
	 Mdrf5sTjz4IFBt3bvEYTRC/yrcXAsUohbdwX3kCjFXYCLq8EIZvzDuFC9nVimRuZz/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEpERWgb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAABC606A325;
	Wed, 18 Nov 2026 22:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEpERWgb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279591F000C4;
	Wed, 18 Nov 2026 22:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039764;
	bh=QluxIy3waJYXUrmpGdgNkhZLwVmYjKsYgvJ+HiOOet0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEpERWgbCkCaPeV/FtDTro4eGVTbmaLcmBum4gaBtCsr0htFj86eqtO4ODj8xIZka
	 Ov/isBhzkGANQBfxLubVaRjEMx1TtC5U4Y4WbLqwLme0spOD7hBwA6jB7yHCAw1ZgC
	 vU9x8YJivdeTaiFZEwFwwiJm+CYUTCuoHXBMWuKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2216/3318] wifi: wfx: fix use-after-free of the cooling work on device removal
Date: Wed, 18 Nov 2026 15:47:18 +0100
Message-ID: <20261118150428.380116321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e8b8b71c1d3ad..e005de8e80428 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -468,6 +468,7 @@ int wfx_probe(struct wfx_dev *wdev)
 		wdev->hwbus_ops->irq_unsubscribe(wdev->hwbus_priv);
 bh_unregister:
 	wfx_bh_unregister(wdev);
+	cancel_delayed_work_sync(&wdev->cooling_timeout_work);
 	destroy_workqueue(wdev->bh_wq);
 	return err;
 }
@@ -478,6 +479,7 @@ void wfx_release(struct wfx_dev *wdev)
 	wfx_hif_shutdown(wdev);
 	wdev->hwbus_ops->irq_unsubscribe(wdev->hwbus_priv);
 	wfx_bh_unregister(wdev);
+	cancel_delayed_work_sync(&wdev->cooling_timeout_work);
 	destroy_workqueue(wdev->bh_wq);
 }
 
-- 
2.53.0



