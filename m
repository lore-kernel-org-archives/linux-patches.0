Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178741E1A35;
	Tue, 15 Oct 2024 12:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994024; cv=none; b=ADdSTtCYv8D37ffBRs/HHOGKoQae3IL5v1laQ1OBEGOJNoJtWkJyVvfb3aG5CShs1UVApKCfus9kESkCdpltr/yobs9iqztDtYlfURRWc036ikWLhYeUDy/QwdJJQJ25F7+3xt5LDu+mRUExUwaF9WbgJB5+CTlnOwvBuSFAyyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994024; c=relaxed/simple;
	bh=g1C8c6xyKUSa5GDIMgU1tozETRyhRIkIvc1Zqd3UyCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=of2lUeJTeC1saryhe3gpu/XqmdmU9usQxZdrpv/cU7PPmLd9aPNkCp7Gaq8pAUaEDVl1h9I+L6Dco1xG7HXLUuCZChj5aCI4jTLDYNq0PcRmBdSrJh3XproswEQc9V9yxV6dkVy64b2jvCjo+YBfrOMqF+iWbu92znjfyxm5EeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gz1JXySy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gz1JXySy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A98FC4CEC6;
	Tue, 15 Oct 2024 12:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994024;
	bh=g1C8c6xyKUSa5GDIMgU1tozETRyhRIkIvc1Zqd3UyCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gz1JXySyqmorelAoN6dZ2wlcTb4mkFnJKnZhT+n10L7fd+u1ZWG0goq6vMAL3bKQ1
	 BjJ3gR1Vmq3zr2fokx3G61grOV3BxTX2Wz5Rnir6j2eTF2xFmaKsgtuHoCVPBv3EqC
	 V4svNk3oKgNs8WhVaf0R4oUn+ZGnHdzUMefbUsXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 553/691] i2c: create debugfs entry per adapter
Date: Tue, 15 Oct 2024 13:28:21 +0200
Message-ID: <20241015112502.288962259@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 73febd775bdbdb98c81255ff85773ac410ded5c4 ]

Two drivers already implement custom debugfs handling for their
i2c_adapter and more will come. So, let the core create a debugfs
directory per adapter and pass that to drivers for their debugfs files.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 8d3cefaf6592 ("i2c: core: Lock address during client device instantiation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 11 +++++++++++
 include/linux/i2c.h         |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index c8cb6f44a0f88..76d70de2d317d 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -16,6 +16,7 @@
 #include <linux/acpi.h>
 #include <linux/clk/clk-conf.h>
 #include <linux/completion.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -66,6 +67,8 @@ static int i2c_detect(struct i2c_adapter *adapter, struct i2c_driver *driver);
 static DEFINE_STATIC_KEY_FALSE(i2c_trace_msg_key);
 static bool is_registered;
 
+static struct dentry *i2c_debugfs_root;
+
 int i2c_transfer_trace_reg(void)
 {
 	static_branch_inc(&i2c_trace_msg_key);
@@ -1526,6 +1529,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 		goto out_list;
 	}
 
+	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
+
 	res = i2c_setup_smbus_alert(adap);
 	if (res)
 		goto out_reg;
@@ -1564,6 +1569,7 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 	return 0;
 
 out_reg:
+	debugfs_remove_recursive(adap->debugfs);
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
 	wait_for_completion(&adap->dev_released);
@@ -1765,6 +1771,8 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 
 	i2c_host_notify_irq_teardown(adap);
 
+	debugfs_remove_recursive(adap->debugfs);
+
 	/* wait until all references to the device are gone
 	 *
 	 * FIXME: This is old code and should ideally be replaced by an
@@ -2062,6 +2070,8 @@ static int __init i2c_init(void)
 
 	is_registered = true;
 
+	i2c_debugfs_root = debugfs_create_dir("i2c", NULL);
+
 #ifdef CONFIG_I2C_COMPAT
 	i2c_adapter_compat_class = class_compat_register("i2c-adapter");
 	if (!i2c_adapter_compat_class) {
@@ -2100,6 +2110,7 @@ static void __exit i2c_exit(void)
 #ifdef CONFIG_I2C_COMPAT
 	class_compat_unregister(i2c_adapter_compat_class);
 #endif
+	debugfs_remove_recursive(i2c_debugfs_root);
 	bus_unregister(&i2c_bus_type);
 	tracepoint_synchronize_unregister();
 }
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 8bcc0142c32c2..7c2ff4d7c360a 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -740,6 +740,8 @@ struct i2c_adapter {
 
 	struct irq_domain *host_notify_domain;
 	struct regulator *bus_regulator;
+
+	struct dentry *debugfs;
 };
 #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
 
-- 
2.43.0



