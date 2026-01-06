Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611AE355042;
	Tue,  6 Jan 2026 17:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720269; cv=none; b=UFq5hJbZDntXmgFe2sOMiKxFXQc+/DIghWGj57rMwL8LLLPDl320fv0DUQHdqxPuOa4UDJVu9tHfuk5eRYcuxIl2HjPzrpyhspjkF3GWm/MVmeOntIh935k9TecTAlAytHR90ZXVebFzzaP0jHMm7iOcDirKVREiyOpgbp1KYH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720269; c=relaxed/simple;
	bh=0wTd1CDYRw2ZT1Bpcj5qCIK9/96/Skp6g39Jw5GqsdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LO1+861xo9LO5lSJwj6nlFeo36+GAoxcydUJm0k9+RDOPZuTwbpQOePjnWlTHSItgX3lw91dMd+mstSdEP7unbqmdGRHWhXOXUqBu0ehs7yMr5yYMJpgQ4t1V/PtZ8q6cblylm3RrY9WcgXb/V9c20biwpNTSvU6XMyt2qq2J/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnq8pdgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnq8pdgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0BDC116C6;
	Tue,  6 Jan 2026 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720269;
	bh=0wTd1CDYRw2ZT1Bpcj5qCIK9/96/Skp6g39Jw5GqsdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnq8pdgVIB7KHZKnSXf/8iN6kcQiUg+Fqx7epuzojxms1cOd4xQs9VhLTmilhNJ9J
	 xY1miZ88TqLwNSq9u8b0NZOLX5znlHKOqycMme9S9kIT2lgZ3+WXZtYyL0l9omMKbo
	 TtAYV5l8XyN2WoPg4mM8U2Zb8NYhp3YqObR0JojI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH 6.12 186/567] usb: phy: isp1301: fix non-OF device reference imbalance
Date: Tue,  6 Jan 2026 17:59:28 +0100
Message-ID: <20260106170458.209071205@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -149,7 +149,12 @@ struct i2c_client *isp1301_get_client(st
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
 


