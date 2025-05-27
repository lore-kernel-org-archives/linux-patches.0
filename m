Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9833E27FB38;
	Tue, 27 May 2025 17:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366750; cv=none; b=sEGglsa7qLrJCqxNcKZWghHEnHkQ0Mx//6XsjgYL3HEWeyv7w8jtJuLGqADLnmoTAYD2P1waPAfd0AWTx7nk6Ec0VGWYMQaZyOZ4MUZglVz12EBT5DRltfcr/EeGlHdq/Ue6UD+0ujAun2TBHo8twr/PzCGKtxTuKrC1mKvaB6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366750; c=relaxed/simple;
	bh=UVZYUAaP8qSdUxdVUHsw970wfGAOnVJKfT6PwlYWv34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+puhUTxSkd/AQHwdByEE7PL5GjuCiyyNjPKt4vC8StY2rSdmpQ2SivvAvyrkxlJtuz+qrEGUBENyHO3s4WKfBf4WEUJMiIV3/FnPMs0RQPaFydpNKJjZk6L1XwdAXMmsW7I3qclPlBm6ERKDPueTojpqNE16ch7sRPJ9JCfFEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BawX51jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BawX51jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D02AC4CEE9;
	Tue, 27 May 2025 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366750;
	bh=UVZYUAaP8qSdUxdVUHsw970wfGAOnVJKfT6PwlYWv34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BawX51jT7otDIybeEPiCFqAZdYclsOdJBEeuf0MnKfn01jqbwkvkgHtV0ZOnC3Rz/
	 ksuCTsJvd52huab/ufjcUKE3VEUNcbSSr+9WF6RTlZA3ED6dT+veOmXMbLr1/05rvk
	 xV49u0wM8mbz3PmPd3t09o4tYtoTyFMRhEQVLcdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 169/783] thunderbolt: Do not add non-active NVM if NVM upgrade is disabled for retimer
Date: Tue, 27 May 2025 18:19:26 +0200
Message-ID: <20250527162520.051499596@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ad79c278e478ca8c1a3bf8e7a0afba8f862a48a1 ]

This is only used to write a new NVM in order to upgrade the retimer
firmware. It does not make sense to expose it if upgrade is disabled.
This also makes it consistent with the router NVM upgrade.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/retimer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/retimer.c b/drivers/thunderbolt/retimer.c
index 1f25529fe05da..361fece3d8188 100644
--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -93,9 +93,11 @@ static int tb_retimer_nvm_add(struct tb_retimer *rt)
 	if (ret)
 		goto err_nvm;
 
-	ret = tb_nvm_add_non_active(nvm, nvm_write);
-	if (ret)
-		goto err_nvm;
+	if (!rt->no_nvm_upgrade) {
+		ret = tb_nvm_add_non_active(nvm, nvm_write);
+		if (ret)
+			goto err_nvm;
+	}
 
 	rt->nvm = nvm;
 	dev_dbg(&rt->dev, "NVM version %x.%x\n", nvm->major, nvm->minor);
-- 
2.39.5



