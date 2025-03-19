Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7719420C000;
	Wed, 19 Mar 2025 14:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395266; cv=none; b=ScJhGDcbB9GbTtM5xfDmjyytsnMjLdLzo1AmueFvC6Wud+NjSIZ0GB7cF5ZiPiNWs2JvzvkKONa3TAaPWDde6WCieRbwEL7J/HmS18IPAK3g257fi+DoKTXBKr0zHkDurtxobyRTIhXkiSEKR3qmLM1Ye5U1I61lM62ZwKLCn0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395266; c=relaxed/simple;
	bh=ctWKHbG5CUpW4JroOIUBXrYjSzEYAyrO/hnTtdCezDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBZi2IK/RbQFZrsvqr/idppC8DQIJkn4v1ikGSyL1zQO2pwEDQuaB2GxuXUL8ZZ41RCaQZk3jPgYbpVi5hnOsGYQpMRm2pA1d/HDjNey4/ruEU1hMMkdA7qp6KPnbSLm2ON8E5r9ejUAKZT2hiJjXxuzDQyxlzuGqAEy8o6Nazc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLxecmpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLxecmpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF18C4CEE4;
	Wed, 19 Mar 2025 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395266;
	bh=ctWKHbG5CUpW4JroOIUBXrYjSzEYAyrO/hnTtdCezDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLxecmpe12yLmn/CUwrKMYf+QqyhGV/EJrrPmCGIZ00tYDnvYOgHrXMzcRAdKFYCj
	 OEKPmcmSnuOz1tin2n0797ZuUg/gtW7Jm75HQv7AvrbybC6ENNR5RxSn+cnFd9psgH
	 mAYfe5c8tEIf4qcYcVC4i9SNx0UzIaBkdqZiQuBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/166] i2c: ali1535: Fix an error handling path in ali1535_probe()
Date: Wed, 19 Mar 2025 07:32:04 -0700
Message-ID: <20250319143024.172268325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



