Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E837BB11;
	Mon,  8 Apr 2024 13:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581305; cv=none; b=JUkOvJAwxgj6I/7DldCqW8E20LKnmHan+Qmq5XoTKcuiHkhWqgmhLRCH8cq7yF7oZsOUqQdD98Phs/Ktf4mP8ljDF+oPECs3ILgHChtb4+1H6l73BAWMNRHI4JW0nsoZ+4HmRvDB9HNBS9O5MUXk3QQGPGVHEd0fvwRuYGbH0R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581305; c=relaxed/simple;
	bh=Dn97k/Vc+sl6ERdd96PR/6ioiT27hY0/fx25NuxFLzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJufLMvvTw9KBDD5/5BaH3oPxr/+WZWrYuE+hrL6AaDvIUHYS2LahLxS6l6ULNC+dBSQLGzt8DWJ/LgfkfTlM3/JOWsw0OH4bFIkLYueFVfFlpZ78d2nRZLMKdQArG7xRTOO58QZ7q+Qsu7FQz5/6I+CpHmYD9Pq6ao3PUmZKsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/J6lpyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/J6lpyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4936CC433F1;
	Mon,  8 Apr 2024 13:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581305;
	bh=Dn97k/Vc+sl6ERdd96PR/6ioiT27hY0/fx25NuxFLzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/J6lpyOiqMgYEUJ/Xw8tcHWw+iEmayXqkNnA/3WGAXcLIxpxXNITqqLFMsFaOG7b
	 PVnxKeaCWbAOrZlkwLmzagA4MoDwh5KLlCG3aLz8tTg/OtwkqRXyrw0BqQ8niISB+S
	 u6OAS3w6NIwpV8mB/juYlVVlPTCulTJGRdiz7T2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/690] wifi: brcmfmac: Fix use-after-free bug in brcmf_cfg80211_detach
Date: Mon,  8 Apr 2024 14:47:56 +0200
Message-ID: <20240408125359.925353620@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b14c54da56ed9..1c95e8f75916f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -790,8 +790,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 	scan_request = cfg->scan_request;
 	cfg->scan_request = NULL;
 
-	if (timer_pending(&cfg->escan_timeout))
-		del_timer_sync(&cfg->escan_timeout);
+	timer_delete_sync(&cfg->escan_timeout);
 
 	if (fw_abort) {
 		/* Do a scan abort to stop the driver's scan engine */
@@ -7781,6 +7780,7 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	brcmf_btcoex_detach(cfg);
 	wiphy_unregister(cfg->wiphy);
 	wl_deinit_priv(cfg);
+	cancel_work_sync(&cfg->escan_timeout_work);
 	brcmf_free_wiphy(cfg->wiphy);
 	kfree(cfg);
 }
-- 
2.43.0



