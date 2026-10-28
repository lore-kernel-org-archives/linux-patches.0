Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208827;
	b=uXSoNcPB+Uzb8dcBsguB2TOUcg5engo4zr6DHIvBncpSKykjuf3JCP6+6Nuwn4aLjaG3
	 V48z7DlkOMqNc6mpRRqVTT8loOavckM76tGZ1USs2rs3NfaFj/VP2Z0p/1U4MEk5uJx/y
	 l71DlOwaU4i2DRBJp3O1kdCBtMevxSNHH7xSeoJqySJUFurRW5TOG1BJ81jU21hpcg/co
	 DE4IGZsWSQOtQjzEVVq+rR6Ph4Vgsyjfq0O76RyGjkrfQhj0i401aLYF1OKdbJqOD59HM
	 Hj3ivzy5z3xiyKsSmCkuqb8Dzw02cvhqyXClXNKkVwH0QahqYyVjXJ8LV6tbSWG8zKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mf7Mx1FbuGSKGhNSqrNIsZRyxjZJgKM24I6SrDIQR8I=;
	b=15m8h5eUa5zUdM0EpiM3LvTFsI5WA5zn0g7ZqyXZfDGWr6dcaJrp1DK+K9E7qYdl5lez
	 XgzDm+kxNGZOCVwe8YoGutxtm7nGiDipUKkfzy5fTOmSO0vH9mu1XBvDofLtVTxNItvHZ
	 oyHwoFOnqtt0Es2ySEQu9erdO7ALOsOMUvvlp3TdjTU3414eJ5fT8yLtB2RyKcydhHfFg
	 w/9htPYmGmEiTEI7Ds7LJ9N+UWOF9FnKGiCyLNmIbOIMmBcux+Ff37sokc5kJWYXlihB8
	 wv003cH5Kwd3TuQJNxAp3E277Ny9fo872I8BTQ2AbkxmyhXX3am4kARD6nujbJ7xvTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llGXhOes;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE1A606A31C;
	Wed, 28 Oct 2026 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llGXhOes
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE061F01825;
	Wed, 28 Oct 2026 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208827;
	bh=Mf7Mx1FbuGSKGhNSqrNIsZRyxjZJgKM24I6SrDIQR8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llGXhOeshyQOhNWEOCShKJYL8dKazGqdezhfOMhG76sjFBKAG3VNC+OG/im+bBVfu
	 wX+yXYTED7SX1UiufQ2Qeb/Wr1msEkom92Yp5Jc7PxoTchHn6n4z6KqAiYDt7DgoA5
	 vgTY74OVbvWDnbnbLbXewQqq8eMq4Ofl8bDnjXEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/516] wifi: wlcore: Fix runtime PM leak in wlcore_remove()
Date: Wed, 28 Oct 2026 17:56:48 +0100
Message-ID: <20261028170009.558575010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index eb8b75252c36f..73a694ecc7db8 100644
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



