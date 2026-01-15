Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2580F3D3338;
	Thu, 15 Jan 2026 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498050; cv=none; b=DDcqcEq7WYFfiI1kBuMdoyhTlO5tJKlQDDeqQRwNOPgI/nUiVDz4q4DxDpFr6z9oEGEVZgeCCS9XZ5SIgxRG3CyGahSfpQH5/XpMU3ltIjdbWqgk+NIk7tVjR1yoQrhtkOucbMCRmCzsjjkstWMmEtdPJ+jTlUzZbN2UKdLNqnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498050; c=relaxed/simple;
	bh=2T6OWqYsjBbxyx7A/XCfKAOibj47JGiQskGJ8LP0MR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF2WWeJbexiMqMeXSOtK3P11th8arSrnc+jzEUvj1dv0L6bzy1opCh8eWVsRO2ytOukImOcmw+0oKtQ5zWFPU7BYNDfH9J3pUd5Hflz2I6LYPbGzOcBa/4aJ1FtuHkV6FHDJuNtrxY22RxV+5hsannymqnyVE3wNlAsZ++Ztmy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoPv/+3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoPv/+3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED1DC116D0;
	Thu, 15 Jan 2026 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498050;
	bh=2T6OWqYsjBbxyx7A/XCfKAOibj47JGiQskGJ8LP0MR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoPv/+3eE2uLbhhve4yytJh9TDaHiuh0uNDpMIxeGkkxC5SEHLMhjNAiTh99NeDOu
	 1glFGh3z1JAGLAz0bLWe/tfygfvj8CYIe0WSOP+owDRD8p2OMDzfv2eqw5B0oRpiXk
	 G04z+zKwLsOLNZxlA95tkQRVmwaiXUw8PpGkiWEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH 5.15 295/554] usb: phy: isp1301: fix non-OF device reference imbalance
Date: Thu, 15 Jan 2026 17:46:01 +0100
Message-ID: <20260115164256.912078509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit b4b64fda4d30a83a7f00e92a0c8a1d47699609f3 upstream.

A recent change fixing a device reference leak in a UDC driver
introduced a potential use-after-free in the non-OF case as the
isp1301_get_client() helper only increases the reference count for the
returned I2C device in the OF case.

Increment the reference count also for non-OF so that the caller can
decrement it unconditionally.

Note that this is inherently racy just as using the returned I2C device
is since nothing is preventing the PHY driver from being unbound while
in use.

Fixes: c84117912bdd ("USB: lpc32xx_udc: Fix error handling in probe")
Cc: stable@vger.kernel.org
Cc: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251218153519.19453-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-isp1301.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/phy/phy-isp1301.c
+++ b/drivers/usb/phy/phy-isp1301.c
@@ -152,7 +152,12 @@ struct i2c_client *isp1301_get_client(st
 		return client;
 
 	/* non-DT: only one ISP1301 chip supported */
-	return isp1301_i2c_client;
+	if (isp1301_i2c_client) {
+		get_device(&isp1301_i2c_client->dev);
+		return isp1301_i2c_client;
+	}
+
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(isp1301_get_client);
 


