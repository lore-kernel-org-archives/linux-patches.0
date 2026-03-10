Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C4B38553F;
	Tue, 10 Mar 2026 11:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140807; cv=none; b=uIdCY6V139SN6IKAzPDPAeucq98fuihl2yWG15Qts1xgFwrXIq6FCZOjPndNeGZfPfZt/F0Sk4tcLrLYXDfziavFvuQdCD5lqs0X4nbk+MTyTlTBkkr4IIkd0AcleBHruZQy/s7eVixkN0OgyXdGT6L7iBBRa/VsEX0mHvIsa84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140807; c=relaxed/simple;
	bh=hgdfRU7sgtgjdf/4Za+A1lw1c6EKqEC/A23iJVnzUVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEjNUGE3NCS8DjMbSEKEFFDexHuGGzDKkx/GYcZR++cQCTOVsP6ixc+VwTogsfosdYdSgeslngNBc/N27CdLnXYJSrOdfF2pObJwIKxwl1GU3R9KrWFlMsiEfQ5mYYL+EqGUsIIbX+Eu5N/EA/Hr+5jw5aFiNyQMNjG7v0dZZLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMsT3rwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMsT3rwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48998C2BC9E;
	Tue, 10 Mar 2026 11:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140807;
	bh=hgdfRU7sgtgjdf/4Za+A1lw1c6EKqEC/A23iJVnzUVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMsT3rwPMzB1lh6A0TmBNm4FZNKgTZxGhCR3GQEIB0PKd/3jabqzDVs5jXbB6iQB6
	 5YZdhPtpecHkwLa7rbo1DsKJ5hVvqEVVXrqz2+4ffrOCtQQo3dqTXF1IJerRz2aR+M
	 6XZAPn7eyV7RnuU60MOg/J7AOP5zvWUcdZqMn8l8hXxnV+gDZzWzDYbf9+D6byYCEv
	 U3w9TfJXDfK0pgTZlnZhgcb4GYP29lxIILnn3ehbOPdMVq0H/SAYsvzvej7qSlej7v
	 1+Jjpk7FMyHDbNwlQhpynfzuJPhtV9E+Yfczpd5hQUZrE2ZCtfXwRLUDSzgkORwAmx
	 RzW/2owGPmKEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Abel Vesa <abelvesa@kernel.org>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 045/311] clk: scu/imx8qxp: do not register driver in probe()
Date: Tue, 10 Mar 2026 07:01:32 -0400
Message-ID: <6d9a4a86fb92453081835162e5e05a3fefb0e2cc.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 78437ab3b769f80526416570f60173c89858dd84 ]

imx_clk_scu_init() registers the imx_clk_scu_driver while commonly being
called from IMX driver's probe() callbacks.

However, it neither makes sense to register drivers from probe()
callbacks of other drivers, nor does the driver core allow registering
drivers with a device lock already being held.

The latter was revealed by commit dc23806a7c47 ("driver core: enforce
device_lock for driver_match_device()") leading to a deadlock condition
described in [1].

Besides that, nothing seems to unregister the imx_clk_scu_driver once
the corresponding driver module is unloaded, which leaves the
driver-core with a dangling pointer.

Also, if there are multiple matching devices for the imx8qxp_clk_driver,
imx8qxp_clk_probe() calls imx_clk_scu_init() multiple times.  However,
any subsequent call after the first one will fail, since the driver-core
does not allow to register the same struct platform_driver multiple
times.

Hence, register the imx_clk_scu_driver from module_init() and unregister
it in module_exit().

Note that we first register the imx8qxp_clk_driver and then call
imx_clk_scu_module_init() to avoid having to call
imx_clk_scu_module_exit() in the unwind path of imx8qxp_clk_init().

Fixes: dc23806a7c47 ("driver core: enforce device_lock for driver_match_device()")
Fixes: 220175cd3979 ("clk: imx: scu: fix build break when compiled as modules")
Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Closes: https://lore.kernel.org/lkml/13955113.uLZWGnKmhe@steina-w/
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com> # TQMa8x/MBa8x
Link: https://lore.kernel.org/lkml/DFU7CEPUSG9A.1KKGVW4HIPMSH@kernel.org/ [1]
Acked-by: Abel Vesa <abelvesa@kernel.org>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/20260212235842.85934-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp.c | 24 +++++++++++++++++++++++-
 drivers/clk/imx/clk-scu.c     | 12 +++++++++++-
 drivers/clk/imx/clk-scu.h     |  2 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8qxp.c b/drivers/clk/imx/clk-imx8qxp.c
index 3ae162625bb1a..c781425a005ef 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -346,7 +346,29 @@ static struct platform_driver imx8qxp_clk_driver = {
 	},
 	.probe = imx8qxp_clk_probe,
 };
-module_platform_driver(imx8qxp_clk_driver);
+
+static int __init imx8qxp_clk_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&imx8qxp_clk_driver);
+	if (ret)
+		return ret;
+
+	ret = imx_clk_scu_module_init();
+	if (ret)
+		platform_driver_unregister(&imx8qxp_clk_driver);
+
+	return ret;
+}
+module_init(imx8qxp_clk_init);
+
+static void __exit imx8qxp_clk_exit(void)
+{
+	imx_clk_scu_module_exit();
+	platform_driver_unregister(&imx8qxp_clk_driver);
+}
+module_exit(imx8qxp_clk_exit);
 
 MODULE_AUTHOR("Aisheng Dong <aisheng.dong@nxp.com>");
 MODULE_DESCRIPTION("NXP i.MX8QXP clock driver");
diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index 34c9dc1fb20e5..c90d21e05f916 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -191,6 +191,16 @@ static bool imx_scu_clk_is_valid(u32 rsrc_id)
 	return p != NULL;
 }
 
+int __init imx_clk_scu_module_init(void)
+{
+	return platform_driver_register(&imx_clk_scu_driver);
+}
+
+void __exit imx_clk_scu_module_exit(void)
+{
+	return platform_driver_unregister(&imx_clk_scu_driver);
+}
+
 int imx_clk_scu_init(struct device_node *np,
 		     const struct imx_clk_scu_rsrc_table *data)
 {
@@ -215,7 +225,7 @@ int imx_clk_scu_init(struct device_node *np,
 		rsrc_table = data;
 	}
 
-	return platform_driver_register(&imx_clk_scu_driver);
+	return 0;
 }
 
 /*
diff --git a/drivers/clk/imx/clk-scu.h b/drivers/clk/imx/clk-scu.h
index af7b697f51cae..ca82f2cce8974 100644
--- a/drivers/clk/imx/clk-scu.h
+++ b/drivers/clk/imx/clk-scu.h
@@ -25,6 +25,8 @@ extern const struct imx_clk_scu_rsrc_table imx_clk_scu_rsrc_imx8dxl;
 extern const struct imx_clk_scu_rsrc_table imx_clk_scu_rsrc_imx8qxp;
 extern const struct imx_clk_scu_rsrc_table imx_clk_scu_rsrc_imx8qm;
 
+int __init imx_clk_scu_module_init(void);
+void __exit imx_clk_scu_module_exit(void);
 int imx_clk_scu_init(struct device_node *np,
 		     const struct imx_clk_scu_rsrc_table *data);
 struct clk_hw *imx_scu_of_clk_src_get(struct of_phandle_args *clkspec,
-- 
2.51.0

