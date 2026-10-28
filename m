Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211272;
	b=u2A8uQHjEGrvDssaOVImg0Z0ToE0YPrjaOOfnOXpp6SAkbkmMHOIrm/AaBpe2Y5lip3G
	 CKJykyfpJ+yKtQgRGT9GXI6hjJjJmw5DL1JcdWmpYN5mA/0u4k62UVaXMZJcTrpJJHMQJ
	 2CBsqdne8MNJdtQ+eWsrIFizRSSAl5NvpXfszs1QRpi48tYmAm7wYh1JyQMeEZAtuOPqQ
	 JB8uTwoyNls51YyoLUH4RmNYHPB+OdJua1dYzZeSJoXZ8BVPEhirhkpAo3VlAmdnoyi+T
	 UHuPjmkFvsR3FL0cw/S4ikl8h3c0vCq92JyXBtFmqZJWzCJTWfVOqBm0FHSpxsUp8lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WVXwUMOF7eg/Kwt2waWxBEdTQYi3C69BWAcC4OR5Z/g=;
	b=HSC2yVL66LJIFrbDLlyvYxvqX7Hwm4I5fMRnUfg/Td3iOC4/5lIpMNQ+3dDpWLdOWwQO
	 ktcKnS0ojj97jpHkDFTPZXWIpDVLw2Y1jyLaY0UnobcDZ8YWEsU/4CIq006dX/t7E/68v
	 HGoxHDHlC49fTcHLB9GKv/AuU8A+JsCtMtDiOzpuRxKX1ECd+SduiPuB3S0mJMIEFGLYF
	 1OC2/sku5w6rqyhaBvM+XXieWVjFG9yH3CyzH5Ig5VXKdOu2ZW+b/TVih5Y/wtB458yJV
	 mJRweDU+uh9XAKmCmkk23VJe0Ap5Ocpy2LB6SHVR6oe5N+GxcpTdJ7E05lkiHdLfEjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jL8w22iS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C8D606BF6F;
	Wed, 28 Oct 2026 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jL8w22iS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1271A1F01828;
	Wed, 28 Oct 2026 18:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211271;
	bh=WVXwUMOF7eg/Kwt2waWxBEdTQYi3C69BWAcC4OR5Z/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jL8w22iSvoYwXaYMDQsNgJTlVc6uPQmUVOXRN+dkwD7kQFX3cwQVu19E0f7HVpLqS
	 gcC4wiiXBxul0mMF+TrCGjDbU6jOycEUbOXi4grpJZWCN57bFw7ny1tzA8WFozAppF
	 QzVUYaK4Mk5SM3irq+wH5vRhucH92/Suq5AaL4Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/571] wifi: wlcore: Fix runtime PM leak in wlcore_remove()
Date: Wed, 28 Oct 2026 17:57:02 +0100
Message-ID: <20261028170014.528212670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 28022749f5d6b..e4ac9c0a7bbb7 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6817,8 +6817,10 @@ void wlcore_remove(struct platform_device *pdev)
 
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



