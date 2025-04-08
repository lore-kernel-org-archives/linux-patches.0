Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AC61AAA0F;
	Tue,  8 Apr 2025 12:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113863; cv=none; b=YxhZ3FpK68KFYqrtVwYC3jrf9aseNYR8eoVcudP8NEQMGzA4mEu1YCzCEkuLc4BAr28ytz2u+YYK3+i5RWaCT0QRN3S/6ZiQU3q1L8Fcum4c8WHxQ4loUpnOxT29XCGPz5RFG+/n3dYPeVSvlhQYZvdAgTo4UPj9btZ8cmEIuzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113863; c=relaxed/simple;
	bh=AYf24PJFEzFhS8G44DNc7drwaaajn9TR+CkDEaFvxVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULWLBWOhJ7muS/mu3VXX10ama97cmsWfM1vO3cOO7Lu0M9S7o7yao3RlfRNZ89i+kTI5eXcLavueG6AdQGb/UI2105LzGDVIvxPWPP/M5FGqvyJwQ9QMBC8mnvVizWrddrnB6veksxvVFrNr3nsoFt0LjRIpWHw5a3ZaHfh4Nws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdtddAIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdtddAIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3267EC4CEE5;
	Tue,  8 Apr 2025 12:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113863;
	bh=AYf24PJFEzFhS8G44DNc7drwaaajn9TR+CkDEaFvxVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdtddAIaENFtjuKrh2HjD6ki+0n3SmDi8H/2Z7MfjWaBYxClxLVlJQ/jy2BoTBM9O
	 wvMe6iZ8tyNbpFkdeLhKIMv3EbwCmwMBlI++4lsmDOb1tQaWaBtla5sjmYM0Dmv7hn
	 ns1CBlWpkiOx1uXz+wsV2yfMAf1gQu/80dvt5LKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/154] i2c: ali1535: Fix an error handling path in ali1535_probe()
Date: Tue,  8 Apr 2025 12:49:49 +0200
Message-ID: <20250408104816.813979683@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a43deea390f5a..2e547b03e5c9b 100644
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



