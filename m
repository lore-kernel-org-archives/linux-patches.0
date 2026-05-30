Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFC8EEA8;
	Sat, 30 May 2026 17:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161121; cv=none; b=l1D6XUYJ8MXH2CKRMZ8Bk2q90qg9dnbcO1HtQqxRpomY3wtPjUqvooXb1bt0tZkHWPv00ISqi3qKRCGbvt+VC3lxUzilmu7OOv5U84++Uc1McnL6ZX0HEVWRPIa2+OQ+Y15XslaL9JdQxPOV8bOAUafVthM9NkiVHB4pEwxg9wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161121; c=relaxed/simple;
	bh=0LqS3oOu8TWZpf1vagLCc9xHwYFcVdr3o+4qlvRRnog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkurdSyW5LwePuGJuKzv2eOc7FxNGciB1m16A/k9xmYfq5Zq7xK/RNRfXMgic2Ql27tLC9n94R74dKE9VQQeXB8HY7NVNWACnn249bhnX7cT6RQHoUZ4D4z2QgLADPsoztWV6n5WW2elQItzgEjOy6FSDE//gXpQ+q09iXd+wrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8dLeGOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8dLeGOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF0F1F00893;
	Sat, 30 May 2026 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161120;
	bh=RHKH8buQPHDFBuBHX0kMvUciwlRW0NxOdu55CBlZ26w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8dLeGOmGPQPgfMOscXWogM9edMVKha2hlO6Dl2MCjBsJNy0h3kB/9ySNi21a3urq
	 gObdC9d4uky8EUz7hOmiklXEto7CwPU9znmgJLSi+QVgKPobMBjdmzcrO2x2RapWKJ
	 lzTVS7stmv9ULIdhiK8oTba0msZAeXUX8GfyTeVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 530/969] pmdomain: imx: scu-pd: Fix device_node reference leak during ->probe()
Date: Sat, 30 May 2026 18:00:54 +0200
Message-ID: <20260530160314.999129591@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/firmware/imx/scu-pd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/scu-pd.c b/drivers/firmware/imx/scu-pd.c
index af3d057e64217..f1977861cd429 100644
--- a/drivers/firmware/imx/scu-pd.c
+++ b/drivers/firmware/imx/scu-pd.c
@@ -235,6 +235,7 @@ static void imx_sc_pd_get_console_rsrc(void)
 		return;
 
 	imx_con_rsrc = specs.args[0];
+	of_node_put(specs.np);
 }
 
 static int imx_sc_pd_power(struct generic_pm_domain *domain, bool power_on)
-- 
2.53.0



