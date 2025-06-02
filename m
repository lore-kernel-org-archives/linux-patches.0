Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BAD1DED64;
	Mon,  2 Jun 2025 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874681; cv=none; b=uP4vfCPSHgU5QZO2NS11lfOu27jw36pPVKUTSSE9eaOaXF0mEYMzBi+RHGxtvlg487zFLvJb9SfiJWEO4XTJFS/CPhRuqcorZtOTFu7XwcfeY0acc20JzcdS19fZbn9gXE5RVTKRio6fNQWRZg2eHrgWyZt7zXL8U3yyBlZ/hx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874681; c=relaxed/simple;
	bh=u2caDG1m9nZM2cW98VCFVhgYLnpOfGFGDm+xPlkY7GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urFBoG7WzCJNkzx9PYMmjUkal5l8bOkFJcpCU2N27Ofw1NCrHbwzofbHNLFYmiuBf7PreiDNXxa91J9oKNhK7sYGU8dkW7G3aKsRQdZ7f+AvhASGLZRw2Wf/XGC27FsoAN1ORZra8yrhp+apqray4QbAVM3dllGuPR1in7KYMlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EONDy9/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EONDy9/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D35C4CEEB;
	Mon,  2 Jun 2025 14:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874680;
	bh=u2caDG1m9nZM2cW98VCFVhgYLnpOfGFGDm+xPlkY7GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EONDy9/oEtgZ06v6eKfqTu6PbI6xYY58e8VcTiYUzxzZJMdeM2pzRCH/NhXp2c4p3
	 YV/IoTZRUypweBWNLXuMaStZ2V5hVpQO4K+zdPcmSpUlSqDyvk7c8l4R/7Kr5ZkhQe
	 pmhNIzK2ICW/FiJGNB6Iiim3a2ois1xugcKE5tW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/204] i2c: pxa: fix call balance of i2c->clk handling routines
Date: Mon,  2 Jun 2025 15:47:13 +0200
Message-ID: <20250602134259.593108769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

From: Vitalii Mordan <mordan@ispras.ru>

[ Upstream commit be7113d2e2a6f20cbee99c98d261a1fd6fd7b549 ]

If the clock i2c->clk was not enabled in i2c_pxa_probe(), it should not be
disabled in any path.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250212172803.1422136-1-mordan@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pxa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index d0c557c8d80f5..c5a6e7527baf7 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1284,7 +1284,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
 				i2c->adap.name);
 	}
 
-	clk_prepare_enable(i2c->clk);
+	ret = clk_prepare_enable(i2c->clk);
+	if (ret)
+		return dev_err_probe(&dev->dev, ret,
+				     "failed to enable clock\n");
 
 	if (i2c->use_pio) {
 		i2c->adap.algo = &i2c_pxa_pio_algorithm;
-- 
2.39.5



