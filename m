Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F2025A342;
	Tue, 25 Mar 2025 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905773; cv=none; b=jZWcA2J//0dGvKE+6ZwrZLeAjP7c5wMJm/JuQNZv0wEQ3uNkRbVzDtmpaTJbNBKW09Vbx72oSgC6Gvs/UZ4vf93lJ4iqgNlWOG2U+DZrnrSXGDbJmLaYY1zleXMmjjD1QWUAyX15BWzfkZqO2ph6K9YcERbtLGPtXXvRewqjeVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905773; c=relaxed/simple;
	bh=SlEBQjR+xyeS0t0eU8mmG7OJPdoNhb0FTaWyv2B3Q6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCooedeaidYYS7RDWFRXjlMncQDSzolR7/5cn3uuVanp5cF5LoKp8E6ZQH3ZcAH4lTbKJFvZCmX44/GnQ20O02c9eiap+59y4WS4OaAtTpegIiOTp0ClL2sOLbJ+aXfa7xDURUKaGIHJ1opemg/Lop86bHG60A9TZrK3IK9e3dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gP7B2XxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gP7B2XxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76EDC4CEE4;
	Tue, 25 Mar 2025 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905772;
	bh=SlEBQjR+xyeS0t0eU8mmG7OJPdoNhb0FTaWyv2B3Q6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gP7B2XxVeuZubby5AFgTlflZXfigIw63Ma7Ic7Ep+TPucXjudayc89DUGZTF27+cp
	 Y2jUgSIAXjVP2HZe1nxzEL27nFr05HZGBCnlt3QsXbsVpMLRMMRxWuMv907TBFzob5
	 eecsJYxQVOZshm/44tD/AXWHEIGKayL1gEQe4GnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/198] i2c: ali15x3: Fix an error handling path in ali15x3_probe()
Date: Tue, 25 Mar 2025 08:21:40 -0400
Message-ID: <20250325122200.272978605@linuxfoundation.org>
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

[ Upstream commit 6e55caaf30c88209d097e575a169b1dface1ab69 ]

If i2c_add_adapter() fails, the request_region() call in ali15x3_setup()
must be undone by a corresponding release_region() call, as done in the
remove function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/9b2090cbcc02659f425188ea05f2e02745c4e67b.1741031878.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ali15x3.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-ali15x3.c b/drivers/i2c/busses/i2c-ali15x3.c
index cc58feacd0821..28a57cb6efb99 100644
--- a/drivers/i2c/busses/i2c-ali15x3.c
+++ b/drivers/i2c/busses/i2c-ali15x3.c
@@ -473,6 +473,8 @@ MODULE_DEVICE_TABLE (pci, ali15x3_ids);
 
 static int ali15x3_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	int ret;
+
 	if (ali15x3_setup(dev)) {
 		dev_err(&dev->dev,
 			"ALI15X3 not detected, module not inserted.\n");
@@ -484,7 +486,15 @@ static int ali15x3_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	snprintf(ali15x3_adapter.name, sizeof(ali15x3_adapter.name),
 		"SMBus ALI15X3 adapter at %04x", ali15x3_smba);
-	return i2c_add_adapter(&ali15x3_adapter);
+	ret = i2c_add_adapter(&ali15x3_adapter);
+	if (ret)
+		goto release_region;
+
+	return 0;
+
+release_region:
+	release_region(ali15x3_smba, ALI15X3_SMB_IOSIZE);
+	return ret;
 }
 
 static void ali15x3_remove(struct pci_dev *dev)
-- 
2.39.5



