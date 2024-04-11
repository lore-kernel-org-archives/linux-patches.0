Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF0213DDDD;
	Thu, 11 Apr 2024 09:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829505; cv=none; b=QnIcyGGUZExUFzlEud5K7UJhmWlS2GJOMlkXAPkiDcUxOvpxk/J/2y7bTcQmcsa3F0TrjFTjdeU4/BaFGZG3OmRRHblSeHBFIG4rv7ULnSmOk+SwLtN1Sz/YMet9tyxWBeTWrlU+kKQikw7nCzRm1KxEM5Us/oX8GqrNIv8XLVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829505; c=relaxed/simple;
	bh=cnEit3hnvk1oiKmlrEnmZ61BoNQONgEbpX3+GKGfAEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiL/Dq4LU2w2rNpYkbW6IyUR/6L6mHozGoj9A6h8ug2qXWF8Tnprz36gMxR4b3aLEYxQDmwuxsWQKR9msRpRmZ1UsNbrQR/KQTYI2/CeFLhNIDOTojNFXwlVf+qUtPMEemZX5JdfsAEQYKZn/n5qRQ1iIUTal8TkAnASbFBU2Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAX/h301; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAX/h301"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325D5C433F1;
	Thu, 11 Apr 2024 09:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829504;
	bh=cnEit3hnvk1oiKmlrEnmZ61BoNQONgEbpX3+GKGfAEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAX/h3010gNeetmj4bFc5NtojPfqS56AzBwBnrAOxciZl0NHpqo2B2O90o5bLl+UK
	 6LV2mWZeOyiaTweQ5AybCuNWy4UnTGFivVpnkNNNzSKwl8xF+cM7ysmiwhA5RtFdTT
	 gMt2Z7gVQNwjzS/xONNeOTzH2AYqBRZ6QoKiwf8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/175] wifi: brcmfmac: Fix use-after-free bug in brcmf_cfg80211_detach
Date: Thu, 11 Apr 2024 11:53:53 +0200
Message-ID: <20240411095419.852635828@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 0f7352557a35ab7888bc7831411ec8a3cbe20d78 ]

This is the candidate patch of CVE-2023-47233 :
https://nvd.nist.gov/vuln/detail/CVE-2023-47233

In brcm80211 driver,it starts with the following invoking chain
to start init a timeout worker:

->brcmf_usb_probe
  ->brcmf_usb_probe_cb
    ->brcmf_attach
      ->brcmf_bus_started
        ->brcmf_cfg80211_attach
          ->wl_init_priv
            ->brcmf_init_escan
              ->INIT_WORK(&cfg->escan_timeout_work,
		  brcmf_cfg80211_escan_timeout_worker);

If we disconnect the USB by hotplug, it will call
brcmf_usb_disconnect to make cleanup. The invoking chain is :

brcmf_usb_disconnect
  ->brcmf_usb_disconnect_cb
    ->brcmf_detach
      ->brcmf_cfg80211_detach
        ->kfree(cfg);

While the timeout woker may still be running. This will cause
a use-after-free bug on cfg in brcmf_cfg80211_escan_timeout_worker.

Fix it by deleting the timer and canceling the worker in
brcmf_cfg80211_detach.

Fixes: e756af5b30b0 ("brcmfmac: add e-scan support.")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Cc: stable@vger.kernel.org
[arend.vanspriel@broadcom.com: keep timer delete as is and cancel work just before free]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240107072504.392713-1-arend.vanspriel@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 1827be85f115f..fe8f1134a5f3e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -690,8 +690,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 	scan_request = cfg->scan_request;
 	cfg->scan_request = NULL;
 
-	if (timer_pending(&cfg->escan_timeout))
-		del_timer_sync(&cfg->escan_timeout);
+	timer_delete_sync(&cfg->escan_timeout);
 
 	if (fw_abort) {
 		/* Do a scan abort to stop the driver's scan engine */
@@ -7093,6 +7092,7 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	wiphy_unregister(cfg->wiphy);
 	kfree(cfg->ops);
 	wl_deinit_priv(cfg);
+	cancel_work_sync(&cfg->escan_timeout_work);
 	brcmf_free_wiphy(cfg->wiphy);
 	kfree(cfg);
 }
-- 
2.43.0



