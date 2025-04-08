Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC5E269885;
	Tue,  8 Apr 2025 10:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109800; cv=none; b=mEBBuV+vd4K9T1E0YILZGv7CH4V08Qoq108HD5nou+dAXtL9fQdVFmnJSxnRhDEA2LGmrD+8g2A/bazcGt5WCp2I8DSphjciWgzMcjPoYGOl+Rlcf2k94xCsYV4Xot3zSFKH/itDMhEgT6OIcfJcyZVU+Jr4RLcK8400+YYt35Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109800; c=relaxed/simple;
	bh=TaSUeY9obYRmwc1ZCZwbFWeZmZsUBzVD7R6OGsMgRp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pe2JZWinTJe9dkDkB+QWgi3vePlJoRG3DJNrIsBAwu0C1Tall34+xmG/M3zTpFH46msr/KpSbsk29SU3znWj4+XJoQ/6zLC8N1/pOy/n2O6q2ogLDJNcPBWmW4ZSNisA9v3/7XnqWdE00WpxHd5SoQGx2r2HuTa0qADh1okaDlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pxr/ME9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pxr/ME9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDD8C4CEE5;
	Tue,  8 Apr 2025 10:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109799;
	bh=TaSUeY9obYRmwc1ZCZwbFWeZmZsUBzVD7R6OGsMgRp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pxr/ME9AHG2AVJ6pLJ9YWLKvkYqIcSvT3+7kRSB/iajKvskNvj7p+Lri+FEd4x/5L
	 e/oYIEwDLHS6WcPr4ludiAGO50OFGZAhVP07sMrxx3SfzYi7donYkTJfy2N878Wz2R
	 pt1VUZZnfguO8kHc2oMddzeYL6mDrO2YgwtsagQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/227] i2c: ali1535: Fix an error handling path in ali1535_probe()
Date: Tue,  8 Apr 2025 12:47:16 +0200
Message-ID: <20250408104822.143905657@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb93152845f43..b36b75fc5b089 100644
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



