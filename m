Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3C346AA71;
	Tue, 21 Jul 2026 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648387; cv=none; b=XCuQ1L8JsR8ntaRmV3TPx968HQehHyao/dZkqZOBeJdh/86sIVacqeRcV1rTuEOyje5qLeUjAWed3JRuKCXYqZCkx8NUONMeV/aZConkJMNk4d615YijeEeS73DhYaKAth/veixoVs8BTqmlzvpDawW+WUzp2wSgtTIeKENJ4KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648387; c=relaxed/simple;
	bh=3/uR/QOrhdeDmVroalDKlmeA2QkqPHyBItpz3KpoOeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W21ntH53r5lpgru7Pw2LtaPD4qJO80BJmzM6IG7FrEG47JMZ9zbXn8Ds1fWjTjYRnCOSMrVcyxxL4HBf2ggky1JOCcLnBS4WIY+2UhQZGittiIIXaVMT4Usw4QIhTmj/rBfHi/FwRj7ofGecEKp1jRmOUp+BPLs6T3B07ym9jyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDB2Qbnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDB2Qbnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BF11F000E9;
	Tue, 21 Jul 2026 15:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648386;
	bh=CFpq3qFjVRliF1s361GSMm7JcTifO5WrvM8YYy8Anc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDB2Qbnqe+bOPrqbqfTY7NuglbF+PXiRf5O18pHiyIQMnzEajUj8MH8CAbOlm4Jxz
	 BOlmsB9LS7lpcY0+gJaVCV7zMa+opfdDpJFET+ZYol2y5Ew854DaTT2ps+cU2l0xWY
	 n0eOXDqBEKnjBnXwmtOWSWkFj0aMCAgzwbOPAOjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0136/2077] pinctrl: sunxi: fix regulator leak in sunxi_pmx_request() error path
Date: Tue, 21 Jul 2026 16:56:49 +0200
Message-ID: <20260721152555.898014335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 334f7bcbdc79dc8e5b938ac3372453a5368221cf ]

In the error path of sunxi_pmx_request(), the code calls
regulator_put(s_reg->regulator) to release the regulator. However,
s_reg->regulator is only assigned after a successful regulator_enable().
This causes a memory leak: the regulator obtained via regulator_get()
is never properly released when regulator_enable() fails.

Fixes: dc1445584177 ("pinctrl: sunxi: Fix and simplify pin bank regulator handling")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index d3042e0c9712e8..25489beeb31253 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -925,7 +925,7 @@ static int sunxi_pmx_request(struct pinctrl_dev *pctldev, unsigned offset)
 	return 0;
 
 out:
-	regulator_put(s_reg->regulator);
+	regulator_put(reg);
 
 	return ret;
 }
-- 
2.53.0



