Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EFA3C1D66;
	Wed, 30 Sep 2026 19:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796889; cv=none; b=t/tMfcz6hqa7mr1FXOYMX23n00o3snRjJS1vZ3gE02/qu3VIROnMsidwlybc6BdaJw1v/NvaZVB/WPSW2d5qny2r2bM2iW1CgR/CRIg3MxnF+W8d+79YocCFaxbNHkWjYUwzsD4ANSmyEPbYSjGp1Vecff90763pbXf89219Iao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796889; c=relaxed/simple;
	bh=Th5EaEz3rfSdBqq6eSWQMTrBXdibJcO2pfscjnVxV+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPAgZbgILA1w1V+L1NHgt/8gjCNI0k0F8J1gf6fb3ri7/kMJvReNf+bVVTJEkDhEcgcwA8/vv7KmjRRWz7L/WIiSB2lWm5bvfLHRgYg3rljgRElYJ6IMMGH32wLjWQiw5a7QTIFULb1ukUJd613PPm7M7eKnhBR5L82H4ZjvujM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3Zv8zfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3Zv8zfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235C41F000FF;
	Wed, 30 Sep 2026 19:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796887;
	bh=XW8htU9XjBg6kmZxyDJVwqmihRsrOBf+3UVHDRKKByw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3Zv8zfFpNgea0KSkIbSkILd6C6loBJsRmvtX11l5vUxat1kJ3o2vOHzpSUjrmFW9
	 bf2O595EaTKLTEG1oqczBvkcmFM4XH9WKDTzpfMdjkuhW3xZRgiymsXRDrEcq73KSH
	 MLhF2IET6BsntH00Z0EDHzufhTkZUNw5LkKIFfWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1072/1193] net: dsa: mt7530: fix NULL dereference on unbind of MT7531 and MT7621
Date: Wed, 30 Sep 2026 17:29:16 +0200
Message-ID: <20260930152458.043290818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Sviridkin <f@lex.la>

[ Upstream commit c2cdef41e0b4d8ed23a5b41e6ad4e64594e055e4 ]

The core and io supplies are only requested for ID_MT7530: both the
devm_regulator_get() in probe and the regulator_enable() in
mt7530_setup() are guarded by the switch id, but mt7530_remove()
disables them unconditionally. On an MT7621 or an MT7531 both pointers
are still NULL from devm_kzalloc(), so rmmod or a sysfs unbind calls
regulator_disable() on NULL.

Fixes: ddda1ac116c8 ("net: dsa: mt7530: support the 7530 switch on the Mediatek MT7621 SoC")
Signed-off-by: Aleksei Sviridkin <f@lex.la>
Link: https://patch.msgid.link/20260918015020.2518315-2-f@lex.la
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530-mdio.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
index 088533663b83b..65507d061ae21 100644
--- a/drivers/net/dsa/mt7530-mdio.c
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -226,15 +226,17 @@ mt7530_remove(struct mdio_device *mdiodev)
 	if (!priv)
 		return;
 
-	ret = regulator_disable(priv->core_pwr);
-	if (ret < 0)
-		dev_err(priv->dev,
-			"Failed to disable core power: %d\n", ret);
-
-	ret = regulator_disable(priv->io_pwr);
-	if (ret < 0)
-		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
-			ret);
+	if (priv->id == ID_MT7530) {
+		ret = regulator_disable(priv->core_pwr);
+		if (ret < 0)
+			dev_err(priv->dev,
+				"Failed to disable core power: %d\n", ret);
+
+		ret = regulator_disable(priv->io_pwr);
+		if (ret < 0)
+			dev_err(priv->dev, "Failed to disable io pwr: %d\n",
+				ret);
+	}
 
 	mt7530_remove_common(priv);
 
-- 
2.53.0



