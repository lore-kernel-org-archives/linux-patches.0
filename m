Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8616119AA78;
	Thu,  6 Jun 2024 14:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683320; cv=none; b=F1nozT7q2zuFf96wPRgYMZI6kqD6BHrptJQOl3ebu4y8RoM+B/IGTF0ePZKjdaeNNnl4GQUGUBZboxofidy99en5CMUf+AjH0DwAGBguVbFLkrAXJnZH17qKv7mGTdndxw+n2JRa+TW266jr4jRN4Z+S91/8ixQo9RjZ5jgwDO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683320; c=relaxed/simple;
	bh=s98C1BIOCyNXNIVBvWBxpXfEPZHaZlGIL0jtPM2O54c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhpwFivUL3xm9t7R6B+aNsPqe0Ccd32WoAC04BBVuX8Gd3SmdrNhBwRUxaGjy2H6WcRk7I1LWhBa41uwwcv4HGDcz4Uc2D1EvUWL4vTuBFV7hlfRcULNEvTGOzXfJPdAV6HRTA2tokz6OsNfV8iufQaiudKzcdtLRdtloNU/Qzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU8EjUcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU8EjUcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D65C2BD10;
	Thu,  6 Jun 2024 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683320;
	bh=s98C1BIOCyNXNIVBvWBxpXfEPZHaZlGIL0jtPM2O54c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU8EjUcKEyPrte3SSRhGJ2ZPNP7tJtmhi6KVvGwVMQ1I4pCt2C2VK13EXuCEN04JG
	 /gTTJoRPiZnlIjdbjrhxwDssieaAmHgArmTkORCZPJiQxrBGRNRkTLEbE1jCLZKnkD
	 0UxJDs5LNeOghKv3AK/VxH9vvgc87VSerdKW6x0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/744] net: micrel: Fix receiving the timestamp in the frame for lan8841
Date: Thu,  6 Jun 2024 15:58:52 +0200
Message-ID: <20240606131740.743319111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit aea27a92a41dae14843f92c79e9e42d8f570105c ]

The blamed commit started to use the ptp workqueue to get the second
part of the timestamp. And when the port was set down, then this
workqueue is stopped. But if the config option NETWORK_PHY_TIMESTAMPING
is not enabled, then the ptp_clock is not initialized so then it would
crash when it would try to access the delayed work.
So then basically by setting up and then down the port, it would crash.
The fix consists in checking if the ptp_clock is initialized and only
then cancel the delayed work.

Fixes: cc7554954848 ("net: micrel: Change to receive timestamp in the frame for lan8841")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index cbd98ea4a84af..538a5f59d7a73 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4612,7 +4612,8 @@ static int lan8841_suspend(struct phy_device *phydev)
 	struct kszphy_priv *priv = phydev->priv;
 	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
 
-	ptp_cancel_worker_sync(ptp_priv->ptp_clock);
+	if (ptp_priv->ptp_clock)
+		ptp_cancel_worker_sync(ptp_priv->ptp_clock);
 
 	return genphy_suspend(phydev);
 }
-- 
2.43.0



