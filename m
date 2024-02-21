Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF643EA71;
	Wed, 21 Feb 2024 13:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521070; cv=none; b=sPaTuFRCUE+Fr+Ni7zLvAGIuosrHdYfkZkMJSR6asEG5ku9Bqp1HbbG/eHoCd+GpIBB8e0lkq94943emAGgZSgcuhMbxNESdD87TGBxoczm/ntPPQD5/QoQPrB1KpkDc8m1XDyjuW9XFcR1jVmnnjqji8hDpY0Pxl+OBPuKbafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521070; c=relaxed/simple;
	bh=CubFgC7yWsP4yUz9DBjsYXVA7cEahnWoRc9FJxBSi/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEAakCfLPPL123KYf03llRH0OPOEU4KaczPUnrNq2/kxj2Tx4XVr8Av9ypmJArr4apF1yP6+1ib4u7gxrsY6bG73hlXDJCT6PjIHp9k8AxdPaBvP1KInnNWigXUdfuhKPPyfXSY8fJ8RyF/PdGoNwYnPgPEXbZEPf0dnmgEvVjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/KGtkvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/KGtkvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2002C433F1;
	Wed, 21 Feb 2024 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521070;
	bh=CubFgC7yWsP4yUz9DBjsYXVA7cEahnWoRc9FJxBSi/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/KGtkvZ9QerxTpAoSN6jsGw55YZOa4GDEQVS4k9bfR1/oj9UwBX2m0Xxr1qqUiMu
	 47+4/FPFNZ8fd/Mhqtasxku4hE9Yh43fnaGfTId0z+7pPMrck2xpul7Ad9zjx8i1je
	 j/Y62MlcfH58Tv3QYgunDLWdO9fF+o/Zc9GGMNzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <a.hajda@samsung.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/202] driver core: add device probe log helper
Date: Wed, 21 Feb 2024 14:05:08 +0100
Message-ID: <20240221125931.981661835@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <a.hajda@samsung.com>

[ Upstream commit a787e5400a1ceeb0ef92d71ec43aeb35b1fa1334 ]

During probe every time driver gets resource it should usually check for
error printk some message if it is not -EPROBE_DEFER and return the error.
This pattern is simple but requires adding few lines after any resource
acquisition code, as a result it is often omitted or implemented only
partially.
dev_err_probe helps to replace such code sequences with simple call,
so code:
	if (err != -EPROBE_DEFER)
		dev_err(dev, ...);
	return err;
becomes:
	return dev_err_probe(dev, err, ...);

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20200713144324.23654-2-a.hajda@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6d710b769c1f ("serial: sc16is7xx: add check for unsupported SPI modes during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  3 +++
 2 files changed, 45 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6e380ad9d08a..b66647277d52 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3334,6 +3334,48 @@ define_dev_printk_level(_dev_info, KERN_INFO);
 
 #endif
 
+/**
+ * dev_err_probe - probe error check and log helper
+ * @dev: the pointer to the struct device
+ * @err: error value to test
+ * @fmt: printf-style format string
+ * @...: arguments as specified in the format string
+ *
+ * This helper implements common pattern present in probe functions for error
+ * checking: print debug or error message depending if the error value is
+ * -EPROBE_DEFER and propagate error upwards.
+ * It replaces code sequence:
+ * 	if (err != -EPROBE_DEFER)
+ * 		dev_err(dev, ...);
+ * 	else
+ * 		dev_dbg(dev, ...);
+ * 	return err;
+ * with
+ * 	return dev_err_probe(dev, err, ...);
+ *
+ * Returns @err.
+ *
+ */
+int dev_err_probe(const struct device *dev, int err, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (err != -EPROBE_DEFER)
+		dev_err(dev, "error %d: %pV", err, &vaf);
+	else
+		dev_dbg(dev, "error %d: %pV", err, &vaf);
+
+	va_end(args);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(dev_err_probe);
+
 static inline bool fwnode_is_primary(struct fwnode_handle *fwnode)
 {
 	return fwnode && !IS_ERR(fwnode->secondary);
diff --git a/include/linux/device.h b/include/linux/device.h
index bccd367c11de..0714d6e5d500 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1581,6 +1581,9 @@ do {									\
 	WARN_ONCE(condition, "%s %s: " format, \
 			dev_driver_string(dev), dev_name(dev), ## arg)
 
+extern __printf(3, 4)
+int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
2.43.0



