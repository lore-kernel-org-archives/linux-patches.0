Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213019;
	b=KekCSwBUp1aYmnQwY7Fj74rRSh1RrF9yKscaj4ZW2PVYZpJr8Y9Uyi/chu3A/0lfurgJ
	 sE7yaZmV62TxJnlfriB9sfU/AGpZehiDNHIhhRYEvCfw59fj+b1cXEqlwOKYup9SnmH5u
	 qFhJnZX8ARduOtm4UCkCCFW3vME00sB6VAqPJJsVWQcmtM8aQSOlThjHMuQHPD/NqcEBG
	 W7z1sJ5tMTeckLGwN1DeFssGBugtpWCyVlYSUPMECIOBn9Yu3iH4lcujYmcSaCRAR663X
	 t31hXOHDEwMDiRPpkIs4MDVT/esRFAeKLX4O144WQu5EJ1UozlqeHYK5AFFEtT4qyDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGHHICOKUrkIVxRFqsvc3Q0RDPW2jDnIKX72ycTsIeE=;
	b=1NtezMOZ2X/iub5yhGYhEcwaId/dU9zuhI+TXlysxijsb5bPn0nnQkUn3JQaD4RBhc9s
	 xo62yPpTEHxqt+S6nTBMERy4mwdOHjD4HxDFz2+pLbHYa2WKCMSGlP/9YawFAq1t6h9D5
	 8bPxZhWKDQLtBvidlneJuQsPE2WEz7lK6xzx8OASIyi/RxtYi5X1Rv5qY3RvPtrQbGEmS
	 ent8qCg2y1kBxXyScdmSaoBea+XPdh3hseEorzcBauEgVLHBAw+/cPWtpJBzvk3w6I2PZ
	 KAjLewTp/Kwqs/5mFaRbLALLxD3RR9hGz5/2NsljWpPIpjEIQwufb+H1vUS52Iq1K8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q19LPEUT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D71606A31E;
	Wed, 28 Oct 2026 18:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q19LPEUT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271381F01825;
	Wed, 28 Oct 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213018;
	bh=gGHHICOKUrkIVxRFqsvc3Q0RDPW2jDnIKX72ycTsIeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q19LPEUTiieIAv7n8/ijY/HYrU64VALEp+iqdNC0HXFTayjRt/u76gSCcOgp12X2Y
	 15kYEl79EYiRsVZN1q/oX+gVKaB1AGX91ANLGK23EpKP+DIz/Vutj4kNTG0hk7vPft
	 wiMVnj6SpzwNklDMnAgWOweqLjXC1xGCEzQWq2os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0359/1887] wifi: wlcore: Fix runtime PM leak in wlcore_remove()
Date: Wed, 28 Oct 2026 17:40:55 +0100
Message-ID: <20261028170507.402298797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a8b8881d0c1aff544fae190469d86db7b07f43a9 ]

pm_runtime_get_sync() keeps the runtime PM usage counter elevated even
when it returns an error, so the reference taken at the beginning of
wlcore_remove() has to be dropped on every exit path. When the device
was not initialized the function returned early without doing so,
leaking the reference.

Release it with pm_runtime_put_noidle() as done on the other early error
paths of this driver.

Fixes: fa2648a34e73f ("wlcore: Add support for runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917122325.2150910-1-vulab@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b5ae25e7ed897..ec3eaf788abf5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6748,8 +6748,10 @@ void wlcore_remove(struct platform_device *pdev)
 
 	if (pdev_data->family && pdev_data->family->nvs_name)
 		wait_for_completion(&wl->nvs_loading_complete);
-	if (!wl->initialized)
+	if (!wl->initialized) {
+		pm_runtime_put_noidle(wl->dev);
 		return;
+	}
 
 	if (wl->wakeirq >= 0) {
 		dev_pm_clear_wake_irq(wl->dev);
-- 
2.53.0



