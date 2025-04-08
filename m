Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D4C1AAA0F;
	Tue,  8 Apr 2025 12:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113866; cv=none; b=KR+QUtEvbeOlWBr6p/nftC2n7HFuMY/tTcgJnsf3XUYyDR/7h1rTUWsUr1av4Iaxhp/wZaaZdQnfOehahd8nAR6GqYxjyYEoa/d6DXL9DrPBQ6NwjoAhgSmccc7IkMadSnESnqlsd/LhXQkxxjzB7RoZVzQRkmJGwkQMyM0C024=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113866; c=relaxed/simple;
	bh=DersNETUqWWFN4AlNDYhuoQhcWFqR7nsFkPJeCgvR6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYSxX5r5jQcJX5fxszz4usEUFv8xks45IjpRuj1aMS1RQF4s3TUCFJqGvtRkg3MJp3jY7c2hpbvKcHQLNNRpG2sxOVSQYVUbDizTgU5sI7j3Y6V+maYYkrKYJP+f0YPN2wOF2fDiGxy35dXMztUAbAKGkRF5VrNGN839s9h+VC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+jmw+lC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+jmw+lC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B22C4CEE5;
	Tue,  8 Apr 2025 12:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113866;
	bh=DersNETUqWWFN4AlNDYhuoQhcWFqR7nsFkPJeCgvR6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+jmw+lCo5Bd1kyshxXNEC/N63mFRisKc0Xtr+8QmAJMS+RVsI+BwkkdsuXtg6W00
	 qX2+yN2viQ2hg3+E5jgf71EGbT+nGUciVrIK3fHcuz17xJ++0D2b+ZsGIZU5mGP7lM
	 3yTzxCdXFO5/X4aHqLiZ51qCw8LRP02gfwXgeqyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/154] i2c: ali15x3: Fix an error handling path in ali15x3_probe()
Date: Tue,  8 Apr 2025 12:49:50 +0200
Message-ID: <20250408104816.845877737@linuxfoundation.org>
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
index 02185a1cfa775..0cb78c47d800e 100644
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



