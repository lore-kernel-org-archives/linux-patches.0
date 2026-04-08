Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09155328B75;
	Wed,  8 Apr 2026 18:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673145; cv=none; b=NY+sHclJcle/H6fklN/txtivQXGTtT+xg7W+Zs7QGVNRlcQsVp3Jr40oTDN1EBFzk2bqZZUqXyWtNPVdz1vUNPJWRgsJzdXTiyHGaevhjVgo279ORp/Yffsn40AS78lBNmeaBlCIwY5N2B8CA6BqWlGmVB/UaazIUdJVkM58OCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673145; c=relaxed/simple;
	bh=H3fz15re65lRoeY80VfDj+dxCbxmAP/ATyAwQz/hHh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYpXlLJRGWi4J41r8inQEoD0c0YbAu8Wu94/Z9JuaCNDu8GvvEXcoXJ2kOwzqXIzvUCwJSSk6wEaKxIlwHy/dJXfn6DTuHMzP5Zw3TG9kXjEymaqFzpEFt5CJdbp55xYFlr0UYsMuU7bqG7wjyiQqEaMkark7xXEEEKgxJgUsPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEpWzMHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEpWzMHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920CCC19425;
	Wed,  8 Apr 2026 18:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673144;
	bh=H3fz15re65lRoeY80VfDj+dxCbxmAP/ATyAwQz/hHh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEpWzMHq1V09J8lptB//efYw0LzUpxi6es0PFcg7KgVy1ekrqFuT34chpLkYhAHA4
	 Qcpx5+mlH25dswUokQ1baOqrROLUncoSQ9cu/j6/TnDPNPQNVnEOIuM1VrOWQ80dUr
	 2NUkdEl7Ci6MShgLgNvzUY8xJMaewGxqDoVOvp0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/277] spi: amlogic: spifc-a4: unregister ECC engine on probe failure and remove() callback
Date: Wed,  8 Apr 2026 20:01:44 +0200
Message-ID: <20260408175938.315130536@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit b0dc7e7c56573e7a52080f25f3179a45f3dd7e6f ]

aml_sfc_probe() registers the on-host NAND ECC engine, but teardown was
missing from both probe unwind and remove-time cleanup. Add a devm cleanup
action after successful registration so
nand_ecc_unregister_on_host_hw_engine() runs automatically on probe
failures and during device removal.

Fixes: 4670db6f32e9 ("spi: amlogic: add driver for Amlogic SPI Flash Controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260322-spifc-a4-v1-1-2dc5ebcbe0a9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spifc-a4.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/spi/spi-amlogic-spifc-a4.c b/drivers/spi/spi-amlogic-spifc-a4.c
index b2589fe2425cc..3393e1f305709 100644
--- a/drivers/spi/spi-amlogic-spifc-a4.c
+++ b/drivers/spi/spi-amlogic-spifc-a4.c
@@ -1066,6 +1066,13 @@ static const struct nand_ecc_engine_ops aml_sfc_ecc_engine_ops = {
 	.finish_io_req = aml_sfc_ecc_finish_io_req,
 };
 
+static void aml_sfc_unregister_ecc_engine(void *data)
+{
+	struct nand_ecc_engine *eng = data;
+
+	nand_ecc_unregister_on_host_hw_engine(eng);
+}
+
 static int aml_sfc_clk_init(struct aml_sfc *sfc)
 {
 	sfc->gate_clk = devm_clk_get_enabled(sfc->dev, "gate");
@@ -1149,6 +1156,11 @@ static int aml_sfc_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "failed to register Aml host ecc engine.\n");
 
+	ret = devm_add_action_or_reset(dev, aml_sfc_unregister_ecc_engine,
+				       &sfc->ecc_eng);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to add ECC unregister action\n");
+
 	ret = of_property_read_u32(np, "amlogic,rx-adj", &val);
 	if (!ret)
 		sfc->rx_adj = val;
-- 
2.53.0



