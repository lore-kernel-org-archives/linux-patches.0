Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AFE38F945;
	Wed, 20 May 2026 16:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295299; cv=none; b=VCVHyzGpySFCNuFcos/g5QrwEOtWCNM/+1fwKvNfNXkTnrscaMYIkpOf/HhYuS7HqTLPyTei6ZPIIsIHCQL3escctqeZCadaTPSUW6LYLj2ANdBiduKUYwEgKhBmmAUDxCF02MGqSucLmp8hg4R2tEHD3rwQbxhJvNSaJBxQNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295299; c=relaxed/simple;
	bh=KlM0Jh5L7K0ijra5P9IedM2hZcOfVRYU0HVMfDXBsg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnK5nSyL+JFn52O+E1Izx3HTZ5REf9mud0DjiXzN4E+D3T8WUa7deocYhjRvMcuP2C4SMKeDSEWsvI4TdjL9X3Afqba9wCD0NcrYSuOvWM6FyZUw6NnGk0yYzc8TzfJbNiBxogjXY3To0d3rkDfcqnrsqYG9AXBYP8KBUddCACE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xI10r99D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xI10r99D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD86B1F000E9;
	Wed, 20 May 2026 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295298;
	bh=77x4mLKG+AlFyPqk9LwppzlMLHooT2qOf+Nw9Ob0PFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xI10r99DlasCvJD5v5EQas/etHIskBlkW9PRw8rj0GkLB+R/DyJL3GBehrhFvezD6
	 fPtHd/RY5bB0fj2sGqqWXN1P7R183sEE6yT+hRD/0fOE26qNCJkwX+1I+irzqQPB62
	 OMm1CXA4C9L/pGqqEHPbJ+P6SwQn32XSKL1Ydg/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0366/1146] pmdomain: imx: scu-pd: Fix device_node reference leak during ->probe()
Date: Wed, 20 May 2026 18:10:16 +0200
Message-ID: <20260520162156.483082153@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit c8e9b6a55702be6c6d034e973d519c52c3848415 ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In imx_sc_pd_get_console_rsrc(), it does not release the reference.

Fixes: 893cfb99734f ("firmware: imx: scu-pd: do not power off console domain")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/imx/scu-pd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pmdomain/imx/scu-pd.c b/drivers/pmdomain/imx/scu-pd.c
index 01d465d88f60d..3ec33667a308c 100644
--- a/drivers/pmdomain/imx/scu-pd.c
+++ b/drivers/pmdomain/imx/scu-pd.c
@@ -326,6 +326,7 @@ static void imx_sc_pd_get_console_rsrc(void)
 		return;
 
 	imx_con_rsrc = specs.args[0];
+	of_node_put(specs.np);
 }
 
 static int imx_sc_get_pd_power(struct device *dev, u32 rsrc)
-- 
2.53.0



