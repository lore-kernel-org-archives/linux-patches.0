Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBA93DC4DA;
	Wed, 20 May 2026 18:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300497; cv=none; b=SkwEYFS2oUmH9VKwm9g4I66vg8AOcTzQ6LY4172BjB45gDYx02MRv8dkD6xWkKght9QVOVChxK+ro3YcW7ydKMaZvfPka+UnMWUNYy8ImMuWQqV2yedMrDwxFZ1KcxOsf7Uz74NXbbkYode954zQZjxCcGVBnY62r16LugQWiwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300497; c=relaxed/simple;
	bh=Sf1DKGa5v8qet8vwO1HLL4PlVuMzFvfDXmqQn/7m0XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqqArVdgFaIXIwaR+mpE+0FLqjh+eJs1hGsYcQ2wp/RZG6HJeDX/FaILV4KdpXVg95viYvq5tw9pVpqh4oC3hEXJeTFDp4n8LZ+oNzQbJrSGogmdkgBJh+6yrBDvDk2rQGWe9RFtgIoD5e+rz6shboeqRkA6jwtj+KKORY0B4H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1LVhmVT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1LVhmVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3E71F000E9;
	Wed, 20 May 2026 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300496;
	bh=7TNB/3EOrd0j0JZBgqfbqnxNxt/eOS4JXB4NnuGiK6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1LVhmVThoSFnvBv0LKVENi/uVPqza6tCBISnQs+rMAGSjTPDW2sc01CRj/BM84n4
	 hUfyP+4XKiC/e8X/o+lFZI1IrmHMdY5Nb7m5/GU6/JObjDrYMG4o5AUqjqfKuW5Kiv
	 GjMehnyOlbjiDGzg4YN7R98AiQLJNbnnNWNmc88A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/666] pmdomain: imx: scu-pd: Fix device_node reference leak during ->probe()
Date: Wed, 20 May 2026 18:16:47 +0200
Message-ID: <20260520162115.450731197@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



