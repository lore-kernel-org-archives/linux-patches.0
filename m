Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC2D263C90;
	Tue,  8 Apr 2025 11:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112455; cv=none; b=gcXHP5vYqGr+YOmcx9oJxuA8w14pUBDTxDWPHRI6McZ0Ck5qtDe9bQKr55WHrBH2UMc+W3ZbOJ4Rz/Oo2pxX76IeWsXfM3YzDCesWPMiKtoD+vrXVziTYwTwB1hiH/5uko2SI5/1qutq7siHl/Iy//OtFMw7cFFGhrpBSjXX4h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112455; c=relaxed/simple;
	bh=8TwPyF2ykCsRAHiVEiZApPWD5va1YMC/wUZnyZzThtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHRsQSz0Tn5BA4iLl0yH0nDQZus2Kxc3LIyvWfEVY8OjfoBp7rY0QKlEnoxqTPLHpPkuVsC/lYcrCv0yHDJ9yLKUBhh/RQUn9TWvkRa93KiksHvRl5j/G2sq0VvvAP46k0RD9y+FuCiObR39hJ+mATIwTy0Dz5CJK+mV/Kz7FBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBsnrS/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBsnrS/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ADAC4CEE5;
	Tue,  8 Apr 2025 11:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112455;
	bh=8TwPyF2ykCsRAHiVEiZApPWD5va1YMC/wUZnyZzThtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBsnrS/baYt6DqooZUXeDXV9lekExTWwjQyM0AfEs+EIXiLjXUIO7vvf1d55bSJEi
	 BOuVwQ6CMDUXkxlqS4iRnClCxJ3K4w5EFuzLUZXlAny9rmTPhFzm+cDxmqat/3hkD5
	 AgET7ff++jdALK5u8FHTSSbwQrH3ay/P2NqFxuVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/279] i2c: sis630: Fix an error handling path in sis630_probe()
Date: Tue,  8 Apr 2025 12:47:37 +0200
Message-ID: <20250408104828.342312417@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cfb8e04a2a831..6befa6ff83f26 100644
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



