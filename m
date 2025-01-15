Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FC6248BAF;
	Wed, 15 Jan 2025 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938863; cv=none; b=JTPW4GBK8Qy7eQgGgy/EhZ+TXqYylt9BTl/DzixMe/IJDKprlpnax4kTmSJf/vZ40douN0pnx43Nv1K5s3zFsuJHgCFHP8R4hIIqdz8HKgCRgHdh7PxgiehxLy40HutysxcQWZm2V1J3/xMllE9YM7avtssx3OWrFve1QKHVE8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938863; c=relaxed/simple;
	bh=GOKRZ1d5pQ4cnmApQ+0eeWODPPd+VoWA2VzAj+RtMEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cY03xbn5qDIAcC5Ndx+RBFZ8cIAaEoSqGOyqsAzi88V37x1yr9YSCO5ONqBCMpX3k2bnl9YgXYTT0J891ZBlQbActA5ySN5jgveIxLi/V2fp0X70RXPgIsy+kBdoMM94Z74yvbcK+/jnaSAQgajnaPl6qiNsqjWFdMSpw3ajdVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUyWCEBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUyWCEBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122CAC4CEDF;
	Wed, 15 Jan 2025 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938862;
	bh=GOKRZ1d5pQ4cnmApQ+0eeWODPPd+VoWA2VzAj+RtMEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUyWCEBONlsl9mbP+Y56lmW96N8wZ/jFyFUydcirprO4m5U2rTWuvbm552D2wnPoA
	 WTU5e0kmGJaZjt1DdAatlxLTUGK0gZUqqTxxOG1GbeXcKTYKBVJmIWeyVWjLDtKRnc
	 5rjko8GlmVLaQFtfc3WlLpuvQ5h3NBF53e7eUsOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/129] pmdomain: imx: gpcv2: fix an OF node reference leak in imx_gpcv2_probe()
Date: Wed, 15 Jan 2025 11:38:15 +0100
Message-ID: <20250115103559.140762912@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 469c0682e03d67d8dc970ecaa70c2d753057c7c0 ]

imx_gpcv2_probe() leaks an OF node reference obtained by
of_get_child_by_name(). Fix it by declaring the device node with the
__free(device_node) cleanup construct.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 03aa12629fc4 ("soc: imx: Add GPCv2 power gating driver")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Cc: stable@vger.kernel.org
Message-ID: <20241215030159.1526624-1-joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/imx/gpcv2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pmdomain/imx/gpcv2.c b/drivers/pmdomain/imx/gpcv2.c
index ec789bf92274..13fce2b134f6 100644
--- a/drivers/pmdomain/imx/gpcv2.c
+++ b/drivers/pmdomain/imx/gpcv2.c
@@ -1449,12 +1449,12 @@ static int imx_gpcv2_probe(struct platform_device *pdev)
 		.max_register   = SZ_4K,
 	};
 	struct device *dev = &pdev->dev;
-	struct device_node *pgc_np;
+	struct device_node *pgc_np __free(device_node) =
+		of_get_child_by_name(dev->of_node, "pgc");
 	struct regmap *regmap;
 	void __iomem *base;
 	int ret;
 
-	pgc_np = of_get_child_by_name(dev->of_node, "pgc");
 	if (!pgc_np) {
 		dev_err(dev, "No power domains specified in DT\n");
 		return -EINVAL;
-- 
2.39.5



