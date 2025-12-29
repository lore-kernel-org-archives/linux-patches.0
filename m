Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D3252917;
	Mon, 29 Dec 2025 16:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025481; cv=none; b=ZGiWRJVT3m9caud7nvw1WqLfQuxn8aYM6eDYx4l9y+K/7K7WmE907LPcpfqNRPygKHisV5UpekKzzetAkpeSuBlwr8bmDwrqMRGj2rKFLmzpw71T0/8CkFQVQnQJEl8mx575F76JEP1oiv1HysBRNit9s7f2KE6B8eNLvEkyKWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025481; c=relaxed/simple;
	bh=VfmN/saAm3t4V70gcs46dk1Du6n5od/m+b49JlR85Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjPxL10PZpDWw16/g4eGHCxk4ADDblf5HxE9XFPVaNURFiPnr3Gh2GyhOKjSaH2UUZKT7M92nwNkpOTJjaQv0s+xCwsQyl2vq4naPlBKXZORM9ewA+PenO2+KZ0MmMQfUFXP6x5dcoeHvlnTWOG1t1B5PO+yRg3zdztNcsOmtwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1yP4egS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1yP4egS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186A5C4CEF7;
	Mon, 29 Dec 2025 16:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025480;
	bh=VfmN/saAm3t4V70gcs46dk1Du6n5od/m+b49JlR85Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1yP4egS3sgLmJQiZ2cfoil9n3gqXeWTeAJtRwm4qANm8dppljIC1Zlwj27zrhJo1
	 K8F7xZt0UzlsqRK7csr0NAYLZR+5gLHXdkympCBz/NOacU/M5O4dll0helGd+i3Pae
	 oxjxBpKQJnVLF0UJkBQWyjb+O41EQCmgOysAnOVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.18 228/430] clk: keystone: syscon-clk: fix regmap leak on probe failure
Date: Mon, 29 Dec 2025 17:10:30 +0100
Message-ID: <20251229160732.745176870@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 9c75986a298f121ed2c6599b05e51d9a34e77068 upstream.

The mmio regmap allocated during probe is never freed.

Switch to using the device managed allocator so that the regmap is
released on probe failures (e.g. probe deferral) and on driver unbind.

Fixes: a250cd4c1901 ("clk: keystone: syscon-clk: Do not use syscon helper to build regmap")
Cc: stable@vger.kernel.org	# 6.15
Cc: Andrew Davis <afd@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/keystone/syscon-clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/keystone/syscon-clk.c b/drivers/clk/keystone/syscon-clk.c
index c509929da854..ecf180a7949c 100644
--- a/drivers/clk/keystone/syscon-clk.c
+++ b/drivers/clk/keystone/syscon-clk.c
@@ -129,7 +129,7 @@ static int ti_syscon_gate_clk_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	regmap = regmap_init_mmio(dev, base, &ti_syscon_regmap_cfg);
+	regmap = devm_regmap_init_mmio(dev, base, &ti_syscon_regmap_cfg);
 	if (IS_ERR(regmap))
 		return dev_err_probe(dev, PTR_ERR(regmap),
 				     "failed to get regmap\n");
-- 
2.52.0



