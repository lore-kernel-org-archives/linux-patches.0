Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113E8305E13;
	Tue, 12 Aug 2025 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024860; cv=none; b=YsCp/xROf0VMeCUwH7Xwitl7GnuPk1T9C4X5hvLJmhf3Ntrm9djOaek0Ujuyf68k1ERD9bM4VgaIa5b7w0c3QsBOtlv1Mj4AnSMkcXYEUK1uh70Cf3pkgtTEJjQe7Vsua0LztRaLtRD5ZL6R3sCKUYhBcaluq29BZ8Uk7ZBFUuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024860; c=relaxed/simple;
	bh=vQGa8CnvKRhxz+kVPeRpGBgH2Wr7rEBoBZ9RCPPConk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EX0C3az09S6q94uB0EDnrPJjKz3ceBQs+o3piyKPht9tLKhUWx5q/VQi5lliqfbe6lh31tA0tVbwOQQCcgyhQM0pU7hFppym888Ml/iPqNDZKkJQ8YfqAGRFNU9YB7yAAa7GFghRvLqXBMsQ8B3KEulANL1w8No2FB01CPmq5EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUlg9+7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUlg9+7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD1FC4CEF0;
	Tue, 12 Aug 2025 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024853;
	bh=vQGa8CnvKRhxz+kVPeRpGBgH2Wr7rEBoBZ9RCPPConk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUlg9+7W1994cD6wk83olhpVVu8gkXNdUqCu9mH8ovxrzY8/WteCcJVp6eunADR/H
	 ZxwmS3bWBg+srmIY3wx3kSo13XffAG72+AutcJa/qldbIkA6kvupENay72A/rlFYQB
	 CfpnzWVISY+65XVkQ2N+RBJdcGVtXXSljT+Uy5QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 489/627] i2c: muxes: mule: Fix an error handling path in mule_i2c_mux_probe()
Date: Tue, 12 Aug 2025 19:33:04 +0200
Message-ID: <20250812173444.864916556@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 33ac5155891cab165c93b51b0e22e153eacc2ee7 ]

If an error occurs in the loop that creates the device adapters, then a
reference to 'dev' still needs to be released.

Use for_each_child_of_node_scoped() to both fix the issue and save one line
of code.

Fixes: d0f8e97866bf ("i2c: muxes: add support for tsd,mule-i2c multiplexer")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-mux-mule.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-mule.c b/drivers/i2c/muxes/i2c-mux-mule.c
index 284ff4afeeac..d3b32b794172 100644
--- a/drivers/i2c/muxes/i2c-mux-mule.c
+++ b/drivers/i2c/muxes/i2c-mux-mule.c
@@ -47,7 +47,6 @@ static int mule_i2c_mux_probe(struct platform_device *pdev)
 	struct mule_i2c_reg_mux *priv;
 	struct i2c_client *client;
 	struct i2c_mux_core *muxc;
-	struct device_node *dev;
 	unsigned int readback;
 	int ndev, ret;
 	bool old_fw;
@@ -95,7 +94,7 @@ static int mule_i2c_mux_probe(struct platform_device *pdev)
 				     "Failed to register mux remove\n");
 
 	/* Create device adapters */
-	for_each_child_of_node(mux_dev->of_node, dev) {
+	for_each_child_of_node_scoped(mux_dev->of_node, dev) {
 		u32 reg;
 
 		ret = of_property_read_u32(dev, "reg", &reg);
-- 
2.39.5



