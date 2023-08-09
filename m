Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A932117AAB
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28492C433C9;
	Wed,  9 Aug 2023 11:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580701;
	bh=g68AwBAkkKu0j96obhkoU8GYjIBrGhEWnM2znVKMmxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0JxXN5hnkKHKfb6lZo1Oeu/BnNv2tQGQVlcSYvnqUrCsrunWz5t1XTIlMPGGCVPN
	 GcY2/uijSOQ711rFxtsfo6TWf1lsbsLWIQ8D3wj3kE4dKr2Tr9tQHQs8C91yCxLkDQ
	 RS+7lovdrSJfk2Zo2gQyI5DIzD1SoQARZ5UT4jTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <a.hajda@samsung.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/154] driver core: add device probe log helper
Date: Wed,  9 Aug 2023 12:42:22 +0200
Message-ID: <20230809103640.617209878@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Stable-dep-of: ef45e8400f5b ("net: ll_temac: fix error checking of irq_of_parse_and_map()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  3 +++
 2 files changed, 45 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f8e157ede44f8..4949aba7e1880 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3399,6 +3399,48 @@ define_dev_printk_level(_dev_info, KERN_INFO);
 
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
index d74275e2047a4..c7be3a8073ec3 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1871,6 +1871,9 @@ do {									\
 	WARN_ONCE(condition, "%s %s: " format, \
 			dev_driver_string(dev), dev_name(dev), ## arg)
 
+extern __printf(3, 4)
+int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
2.40.1



