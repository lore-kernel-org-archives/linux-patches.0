Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FC439B975;
	Wed, 20 May 2026 17:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298097; cv=none; b=M1eRtCi8Vm3Tcq7eWWAH+0oj9toXzADMYHG3NAPbywgJBGB4IngGzrMWQ0KGMXuvSLRF48ld8nBXin3U4is2Pm1SLaVJr4ESuF1xf/zMgk7LpKOTUhRxFocSq9Obm8v4glE2si/87TPS8n0Lf6Pl1yCxB8L3rKCVaXSZupw/IDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298097; c=relaxed/simple;
	bh=Xgve9LxBsdkOduduivjEYbet2IPR8PWQhEHeSstTuW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkhIt/lE0RIGk3IGle7fEsFT0PQpKwsNxyMDNy7q6qjpMOLLQAZ6jlwHk8tApjrk7g7inwQjW7Tiy0ADlmvsnoOuC9k+/UwOsrMF5igWnbRRcConnF+MYe8sV3pGfidRKzQFaitIkDXEO0sv2GSbZYHVAeknnfG2XHsR+Hlbmpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkGtDr8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkGtDr8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567F21F000E9;
	Wed, 20 May 2026 17:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298096;
	bh=yNcDSDF8p8OxC3WXHnEODfW5D48On4IVBdLweVHK0aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkGtDr8/2cXIh1H5LDHaKDhaK9GU+UE7Z8H4N6+UehLvZZXG1xhd+myrpqF8nmrZw
	 hkU7oOQ0IStEAKfKfKmETU4FEpawzAxCh8wLcPmLRmCZr40WA1GJPWlCjk6pYkrsi6
	 LqqDbPgMOIsfHgM9bt0YjJSndWj5zoYzTkaZkOUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 281/957] pmdomain: imx: scu-pd: Fix device_node reference leak during ->probe()
Date: Wed, 20 May 2026 18:12:44 +0200
Message-ID: <20260520162140.632966814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



