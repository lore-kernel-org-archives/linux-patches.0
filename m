Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC7B259CAD;
	Tue, 25 Mar 2025 12:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905753; cv=none; b=HKi2XkerogxzS2qVAyXUbjMpXVioRR4U223AUbzQk/GgfEDYreXR7fgr53XmwjaEnXFFVIduMmNrnEMMh3uQpD69cpR2hTD0YgRXCmnNMooRPJ0A5ErPETyXEn0U2k0j89RYAkJb/In+5Pm+hvTA0f9XPMeaDYYvgzVXS2uXPOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905753; c=relaxed/simple;
	bh=+AObWkI/t9gOBI+NKTBpCKCRDOs3ccIJiWAH/yAcWek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdXkj3Xks6ttT7RrpxIIhllNpAXSocCnZJrPRYxAZPMuLTyiA0fqQ6q3krtYdzDTrhVNm7MMrb3it0sU5vHxub1dBhZMfZJA6LTJX/E0oa8LAtOaETWiW082K9t5TuvSv1cs64umP3RfN7SID1rtvx+ryH18D/u5QN3mxu50ojA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZyDVpkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZyDVpkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2FEC4CEE4;
	Tue, 25 Mar 2025 12:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905753;
	bh=+AObWkI/t9gOBI+NKTBpCKCRDOs3ccIJiWAH/yAcWek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZyDVpkMT0UCbh/1ql625hfpB2RirN3lEPTUQ44QJEEBXy4sfGnNI1GH8VAWrNsP6
	 DHPRUUBvVNZV7BBOF/KDsnkGyzemvxziWEc2nv2H4BV7ugETCdYTJkqXb2huwpOgAp
	 tN203fuXj3ZB0eLFEEb8PgfX9bSaKCgUsuweOP2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/198] i2c: ali1535: Fix an error handling path in ali1535_probe()
Date: Tue, 25 Mar 2025 08:21:39 -0400
Message-ID: <20250325122200.246332124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9b5463f349d019a261f1e80803447efca3126151 ]

If i2c_add_adapter() fails, the request_region() call in ali1535_setup()
must be undone by a corresponding release_region() call, as done in the
remove function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/0daf63d7a2ce74c02e2664ba805bbfadab7d25e5.1741031571.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ali1535.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-ali1535.c b/drivers/i2c/busses/i2c-ali1535.c
index ee83c4581bce0..cd2c8afebe798 100644
--- a/drivers/i2c/busses/i2c-ali1535.c
+++ b/drivers/i2c/busses/i2c-ali1535.c
@@ -490,6 +490,8 @@ MODULE_DEVICE_TABLE(pci, ali1535_ids);
 
 static int ali1535_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	int ret;
+
 	if (ali1535_setup(dev)) {
 		dev_warn(&dev->dev,
 			"ALI1535 not detected, module not inserted.\n");
@@ -501,7 +503,15 @@ static int ali1535_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	snprintf(ali1535_adapter.name, sizeof(ali1535_adapter.name),
 		"SMBus ALI1535 adapter at %04x", ali1535_offset);
-	return i2c_add_adapter(&ali1535_adapter);
+	ret = i2c_add_adapter(&ali1535_adapter);
+	if (ret)
+		goto release_region;
+
+	return 0;
+
+release_region:
+	release_region(ali1535_smba, ALI1535_SMB_IOSIZE);
+	return ret;
 }
 
 static void ali1535_remove(struct pci_dev *dev)
-- 
2.39.5



