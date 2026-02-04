Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1443841C2FA;
	Wed,  4 Feb 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217412; cv=none; b=O/uIwbt2wD7GviO5USWy8ubAJ5O3hhRQV1ypMm3h0hjttEW4rVpIs0kq4qEDsrJS5IcsTzi7JZKWezh8u5dji7izfRKgpmxAMaAQAlRrlImWYSw8+UVX3i8VtdJnCR1R/HbCaeyOU+wUcpMr6u7KJKUZFsoPGXN6MMqPgZfntpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217412; c=relaxed/simple;
	bh=yXlDyA98C/cNvhucLsyh03puGkvQ+pFlZ85NPN3upWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMmH5bpc8bPDnnFq9E4rj7zFX9Z3Qz6FjAlV3gB12htcS2rny3DQuVnmcWD2I5qDnU0L7/QqyRnPcw35Tfp4uaHwE+s7vr4PAY5tp6C8VnwyRLe+EDrkru4OiBjdK7XnkluLtnC1StarUeBDk0zHlIG95S/1PtPB+9GHBlm8mEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+n0knAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+n0knAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA64C4CEF7;
	Wed,  4 Feb 2026 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217411;
	bh=yXlDyA98C/cNvhucLsyh03puGkvQ+pFlZ85NPN3upWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+n0knAbSvFHKwojJBPFPWnCdGAJXlVAwetA8Q5P4FgaQHsaAPUX17oKgQ9TKvnFP
	 /KCYBNByu5vS86bA3sghtiEml0uO3P2gnzmIuqMWwTOER/j2glVRuSnQUEkGdWyEjf
	 LY0xKYjrxK9cXxm7loVKYcDUbERhVf82bnDsbQnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 6.1 001/280] firmware: imx: scu-irq: Set mu_resource_id before get handle
Date: Wed,  4 Feb 2026 15:36:15 +0100
Message-ID: <20260204143909.672546734@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

commit ff3f9913bc0749364fbfd86ea62ba2d31c6136c8 upstream.

mu_resource_id is referenced in imx_scu_irq_get_status() and
imx_scu_irq_group_enable() which could be used by other modules, so
need to set correct value before using imx_sc_irq_ipc_handle in
SCU API call.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Fixes: 81fb53feb66a ("firmware: imx: scu-irq: Init workqueue before request mbox channel")
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/imx/imx-scu-irq.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/firmware/imx/imx-scu-irq.c
+++ b/drivers/firmware/imx/imx-scu-irq.c
@@ -137,6 +137,18 @@ int imx_scu_enable_general_irq_channel(s
 	struct mbox_chan *ch;
 	int ret = 0, i = 0;
 
+	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
+				       "#mbox-cells", 0, &spec)) {
+		i = of_alias_get_id(spec.np, "mu");
+		of_node_put(spec.np);
+	}
+
+	/* use mu1 as general mu irq channel if failed */
+	if (i < 0)
+		i = 1;
+
+	mu_resource_id = IMX_SC_R_MU_0A + i;
+
 	ret = imx_scu_get_handle(&imx_sc_irq_ipc_handle);
 	if (ret)
 		return ret;
@@ -159,18 +171,6 @@ int imx_scu_enable_general_irq_channel(s
 		return ret;
 	}
 
-	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
-				       "#mbox-cells", 0, &spec)) {
-		i = of_alias_get_id(spec.np, "mu");
-		of_node_put(spec.np);
-	}
-
-	/* use mu1 as general mu irq channel if failed */
-	if (i < 0)
-		i = 1;
-
-	mu_resource_id = IMX_SC_R_MU_0A + i;
-
 	return ret;
 }
 EXPORT_SYMBOL(imx_scu_enable_general_irq_channel);


