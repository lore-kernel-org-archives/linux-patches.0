Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B2B259CAD;
	Tue, 25 Mar 2025 12:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905793; cv=none; b=sEym8oI0ssPCCqcs4WxgF03JQJdYpZxwW5HDd06WXmqWnRql/4o76hMQfh5mV+/pwYxaNdF6CtnIeC6D1Y04e+7ssdhmA+dvsTGh7NnpUssVGpsY5Mkd/U5SE/mTBZy7JA35kkmIYn3MeuBnd5vizM9f24bzpQgYJkVE6EzSUuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905793; c=relaxed/simple;
	bh=QZNq/jdj2a3u2hjgQ1uUcMuFwlfQ439lTSSmbmgPERk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxWBsC3bWZqk08OoGDWVsM8EpwgJmvxnpCHGhgZAcQ6NSadVUh1tT2jtCGcjaGsd6BFnao0JAgkGBlGBaIZ6AB6H8lcZzDJ+2E0MVk1jEa0OK4Po0rMdwCW9ABU3JV6lKm/Ay849VDRBL9koKLX1+csuhyGD1j15qGwgEWisK/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmzGytoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmzGytoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078DDC4CEE4;
	Tue, 25 Mar 2025 12:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905793;
	bh=QZNq/jdj2a3u2hjgQ1uUcMuFwlfQ439lTSSmbmgPERk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmzGytoyVWxLPbPH0Ahswcoib+UhWUAJc41w3YfAuBU+WDWs2jaAl9GFh9d5asmf4
	 oG4URsZmRTNYEzug45i61I4O865QAwQIVyeNFMCdhTYAKDbnFJtOKR74VWHB24DAQz
	 pGu28foOiK7RYMzUCuETcBeRDIKo1ntWhn3hACmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/198] i2c: sis630: Fix an error handling path in sis630_probe()
Date: Tue, 25 Mar 2025 08:21:41 -0400
Message-ID: <20250325122200.300980359@linuxfoundation.org>
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

[ Upstream commit 2b22459792fcb4def9f0936d64575ac11a95a58d ]

If i2c_add_adapter() fails, the request_region() call in sis630_setup()
must be undone by a corresponding release_region() call, as done in the
remove function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/3d607601f2c38e896b10207963c6ab499ca5c307.1741033587.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-sis630.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
index 87d56250d78a3..c42ecadac4f22 100644
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -509,6 +509,8 @@ MODULE_DEVICE_TABLE(pci, sis630_ids);
 
 static int sis630_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	int ret;
+
 	if (sis630_setup(dev)) {
 		dev_err(&dev->dev,
 			"SIS630 compatible bus not detected, "
@@ -522,7 +524,15 @@ static int sis630_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	snprintf(sis630_adapter.name, sizeof(sis630_adapter.name),
 		 "SMBus SIS630 adapter at %04x", smbus_base + SMB_STS);
 
-	return i2c_add_adapter(&sis630_adapter);
+	ret = i2c_add_adapter(&sis630_adapter);
+	if (ret)
+		goto release_region;
+
+	return 0;
+
+release_region:
+	release_region(smbus_base + SMB_STS, SIS630_SMB_IOREGION);
+	return ret;
 }
 
 static void sis630_remove(struct pci_dev *dev)
-- 
2.39.5



