Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D062134405B;
	Tue, 12 May 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608940; cv=none; b=T9KPyIFX8dFdH/Gt1ULDT2WJ8Si1OlfVeNfonz1NnUqx6rvSSxha0mS8xF3HtuThbrZR7zkASS6BFhym59wXHctOz5FXw6RFnDdUFPBw+6Xc8fa8sTS5xjB4qoKfzfh6ZfE/eiaqAK8mthOMN1FSh8eRAMFtLTUx7Gs0kCF5P3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608940; c=relaxed/simple;
	bh=C1HG8G91Lkj8uzFSr2nstXpHL/lr8EmuVl92bhTKbQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooTewFtJBt/ROmKtpDjYRo3EM7h2SaD5XgKnJi+hvEEVYoaeKGRCawBC5Gq9k17ENPcgtarTbUEf3KdBKkPE3pcMJwRD+VFmjdnfI9f4U6B5/Fvp0S7Ut7zkMoTWg0B/4AiPOqxk9k9WRVdmrNlOLHlwdcn3XMAD6KTQTnK4CEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrC5frAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrC5frAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6917DC2BCB0;
	Tue, 12 May 2026 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608940;
	bh=C1HG8G91Lkj8uzFSr2nstXpHL/lr8EmuVl92bhTKbQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrC5frAHXVh3+5nK15QDzNA9MNe9J+N8Lx8shRR7BILsfKnuWrs9FZGdvUDYfL50k
	 lkvlRoELl0f4pv+tTbRwZx5cOGYtvzaw7Ns3dnfYIjUDfkCidERMiar9HXhjWtzMQ6
	 WjjpFt3EFcFzyiTQhS84H63lkmdgNpl7yKk+X1S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 260/270] firmware: exynos-acpm: Drop fake const on handle pointer
Date: Tue, 12 May 2026 19:41:01 +0200
Message-ID: <20260512173943.922594979@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit a2be37eedb52ea26938fa4cc9de1ff84963c57ad ]

All the functions operating on the 'handle' pointer are claiming it is a
pointer to const thus they should not modify the handle.  In fact that's
a false statement, because first thing these functions do is drop the
cast to const with container_of:

  struct acpm_info *acpm = handle_to_acpm_info(handle);

And with such cast the handle is easily writable with simple:

  acpm->handle.ops.pmic_ops.read_reg = NULL;

The code is not correct logically, either, because functions like
acpm_get_by_node() and acpm_handle_put() are meant to modify the handle
reference counting, thus they must modify the handle.  Modification here
happens anyway, even if the reference counting is stored in the
container which the handle is part of.

The code does not have actual visible bug, but incorrect 'const'
annotations could lead to incorrect compiler decisions.

Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260224104203.42950-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
[ dropped hunks for DVFS/clk-acpm files and `acpm_dvfs_ops` struct that don't exist in 6.18 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/samsung/exynos-acpm-pmic.c           |   10 +++---
 drivers/firmware/samsung/exynos-acpm-pmic.h           |   10 +++---
 drivers/firmware/samsung/exynos-acpm.c                |   16 +++++----
 drivers/firmware/samsung/exynos-acpm.h                |    2 -
 drivers/mfd/sec-acpm.c                                |   10 +++---
 include/linux/firmware/samsung/exynos-acpm-protocol.h |   29 +++++++-----------
 6 files changed, 37 insertions(+), 40 deletions(-)

--- a/drivers/firmware/samsung/exynos-acpm-pmic.c
+++ b/drivers/firmware/samsung/exynos-acpm-pmic.c
@@ -77,7 +77,7 @@ static void acpm_pmic_init_read_cmd(u32
 	cmd[3] = ktime_to_ms(ktime_get());
 }
 
-int acpm_pmic_read_reg(const struct acpm_handle *handle,
+int acpm_pmic_read_reg(struct acpm_handle *handle,
 		       unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 		       u8 *buf)
 {
@@ -107,7 +107,7 @@ static void acpm_pmic_init_bulk_read_cmd
 		 FIELD_PREP(ACPM_PMIC_VALUE, count);
 }
 
-int acpm_pmic_bulk_read(const struct acpm_handle *handle,
+int acpm_pmic_bulk_read(struct acpm_handle *handle,
 			unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 			u8 count, u8 *buf)
 {
@@ -150,7 +150,7 @@ static void acpm_pmic_init_write_cmd(u32
 	cmd[3] = ktime_to_ms(ktime_get());
 }
 
-int acpm_pmic_write_reg(const struct acpm_handle *handle,
+int acpm_pmic_write_reg(struct acpm_handle *handle,
 			unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 			u8 value)
 {
@@ -187,7 +187,7 @@ static void acpm_pmic_init_bulk_write_cm
 	}
 }
 
-int acpm_pmic_bulk_write(const struct acpm_handle *handle,
+int acpm_pmic_bulk_write(struct acpm_handle *handle,
 			 unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 			 u8 count, const u8 *buf)
 {
@@ -220,7 +220,7 @@ static void acpm_pmic_init_update_cmd(u3
 	cmd[3] = ktime_to_ms(ktime_get());
 }
 
-int acpm_pmic_update_reg(const struct acpm_handle *handle,
+int acpm_pmic_update_reg(struct acpm_handle *handle,
 			 unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 			 u8 value, u8 mask)
 {
--- a/drivers/firmware/samsung/exynos-acpm-pmic.h
+++ b/drivers/firmware/samsung/exynos-acpm-pmic.h
@@ -11,19 +11,19 @@
 
 struct acpm_handle;
 
-int acpm_pmic_read_reg(const struct acpm_handle *handle,
+int acpm_pmic_read_reg(struct acpm_handle *handle,
 		       unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 		       u8 *buf);
-int acpm_pmic_bulk_read(const struct acpm_handle *handle,
+int acpm_pmic_bulk_read(struct acpm_handle *handle,
 			unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 			u8 count, u8 *buf);
-int acpm_pmic_write_reg(const struct acpm_handle *handle,
+int acpm_pmic_write_reg(struct acpm_handle *handle,
 			unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 			u8 value);
-int acpm_pmic_bulk_write(const struct acpm_handle *handle,
+int acpm_pmic_bulk_write(struct acpm_handle *handle,
 			 unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 			 u8 count, const u8 *buf);
-int acpm_pmic_update_reg(const struct acpm_handle *handle,
+int acpm_pmic_update_reg(struct acpm_handle *handle,
 			 unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
 			 u8 value, u8 mask);
 #endif /* __EXYNOS_ACPM_PMIC_H__ */
--- a/drivers/firmware/samsung/exynos-acpm.c
+++ b/drivers/firmware/samsung/exynos-acpm.c
@@ -409,7 +409,7 @@ static int acpm_wait_for_message_respons
  *
  * Return: 0 on success, -errno otherwise.
  */
-int acpm_do_xfer(const struct acpm_handle *handle, const struct acpm_xfer *xfer)
+int acpm_do_xfer(struct acpm_handle *handle, const struct acpm_xfer *xfer)
 {
 	struct acpm_info *acpm = handle_to_acpm_info(handle);
 	struct exynos_mbox_msg msg;
@@ -649,7 +649,7 @@ static int acpm_probe(struct platform_de
  * acpm_handle_put() - release the handle acquired by acpm_get_by_phandle.
  * @handle:	Handle acquired by acpm_get_by_phandle.
  */
-static void acpm_handle_put(const struct acpm_handle *handle)
+static void acpm_handle_put(struct acpm_handle *handle)
 {
 	struct acpm_info *acpm = handle_to_acpm_info(handle);
 	struct device *dev = acpm->dev;
@@ -675,9 +675,11 @@ static void devm_acpm_release(struct dev
  * @np:		ACPM device tree node.
  *
  * Return: pointer to handle on success, ERR_PTR(-errno) otherwise.
+ *
+ * Note: handle CANNOT be pointer to const
  */
-static const struct acpm_handle *acpm_get_by_node(struct device *dev,
-						  struct device_node *np)
+static struct acpm_handle *acpm_get_by_node(struct device *dev,
+					    struct device_node *np)
 {
 	struct platform_device *pdev;
 	struct device_link *link;
@@ -718,10 +720,10 @@ static const struct acpm_handle *acpm_ge
  *
  * Return: pointer to handle on success, ERR_PTR(-errno) otherwise.
  */
-const struct acpm_handle *devm_acpm_get_by_node(struct device *dev,
-						struct device_node *np)
+struct acpm_handle *devm_acpm_get_by_node(struct device *dev,
+					  struct device_node *np)
 {
-	const struct acpm_handle **ptr, *handle;
+	struct acpm_handle **ptr, *handle;
 
 	ptr = devres_alloc(devm_acpm_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
--- a/drivers/firmware/samsung/exynos-acpm.h
+++ b/drivers/firmware/samsung/exynos-acpm.h
@@ -17,7 +17,7 @@ struct acpm_xfer {
 
 struct acpm_handle;
 
-int acpm_do_xfer(const struct acpm_handle *handle,
+int acpm_do_xfer(struct acpm_handle *handle,
 		 const struct acpm_xfer *xfer);
 
 #endif /* __EXYNOS_ACPM_H__ */
--- a/drivers/mfd/sec-acpm.c
+++ b/drivers/mfd/sec-acpm.c
@@ -217,7 +217,7 @@ static const struct regmap_config s2mpg1
 };
 
 struct sec_pmic_acpm_shared_bus_context {
-	const struct acpm_handle *acpm;
+	struct acpm_handle *acpm;
 	unsigned int acpm_chan_id;
 	u8 speedy_channel;
 };
@@ -240,7 +240,7 @@ static int sec_pmic_acpm_bus_write(void
 				   size_t count)
 {
 	struct sec_pmic_acpm_bus_context *ctx = context;
-	const struct acpm_handle *acpm = ctx->shared->acpm;
+	struct acpm_handle *acpm = ctx->shared->acpm;
 	const struct acpm_pmic_ops *pmic_ops = &acpm->ops.pmic_ops;
 	size_t val_count = count - BITS_TO_BYTES(ACPM_ADDR_BITS);
 	const u8 *d = data;
@@ -260,7 +260,7 @@ static int sec_pmic_acpm_bus_read(void *
 				  void *val_buf, size_t val_size)
 {
 	struct sec_pmic_acpm_bus_context *ctx = context;
-	const struct acpm_handle *acpm = ctx->shared->acpm;
+	struct acpm_handle *acpm = ctx->shared->acpm;
 	const struct acpm_pmic_ops *pmic_ops = &acpm->ops.pmic_ops;
 	const u8 *r = reg_buf;
 	u8 reg;
@@ -279,7 +279,7 @@ static int sec_pmic_acpm_bus_reg_update_
 					     unsigned int val)
 {
 	struct sec_pmic_acpm_bus_context *ctx = context;
-	const struct acpm_handle *acpm = ctx->shared->acpm;
+	struct acpm_handle *acpm = ctx->shared->acpm;
 	const struct acpm_pmic_ops *pmic_ops = &acpm->ops.pmic_ops;
 
 	return pmic_ops->update_reg(acpm, ctx->shared->acpm_chan_id, ctx->type, reg & 0xff,
@@ -335,7 +335,7 @@ static int sec_pmic_acpm_probe(struct pl
 	struct regmap *regmap_common, *regmap_pmic, *regmap;
 	const struct sec_pmic_acpm_platform_data *pdata;
 	struct sec_pmic_acpm_shared_bus_context *shared_ctx;
-	const struct acpm_handle *acpm;
+	struct acpm_handle *acpm;
 	struct device *dev = &pdev->dev;
 	int ret, irq;
 
--- a/include/linux/firmware/samsung/exynos-acpm-protocol.h
+++ b/include/linux/firmware/samsung/exynos-acpm-protocol.h
@@ -14,21 +14,16 @@ struct acpm_handle;
 struct device_node;
 
 struct acpm_pmic_ops {
-	int (*read_reg)(const struct acpm_handle *handle,
-			unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
-			u8 *buf);
-	int (*bulk_read)(const struct acpm_handle *handle,
-			 unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
-			 u8 count, u8 *buf);
-	int (*write_reg)(const struct acpm_handle *handle,
-			 unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
-			 u8 value);
-	int (*bulk_write)(const struct acpm_handle *handle,
-			  unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
-			  u8 count, const u8 *buf);
-	int (*update_reg)(const struct acpm_handle *handle,
-			  unsigned int acpm_chan_id, u8 type, u8 reg, u8 chan,
-			  u8 value, u8 mask);
+	int (*read_reg)(struct acpm_handle *handle, unsigned int acpm_chan_id,
+			u8 type, u8 reg, u8 chan, u8 *buf);
+	int (*bulk_read)(struct acpm_handle *handle, unsigned int acpm_chan_id,
+			 u8 type, u8 reg, u8 chan, u8 count, u8 *buf);
+	int (*write_reg)(struct acpm_handle *handle, unsigned int acpm_chan_id,
+			 u8 type, u8 reg, u8 chan, u8 value);
+	int (*bulk_write)(struct acpm_handle *handle, unsigned int acpm_chan_id,
+			  u8 type, u8 reg, u8 chan, u8 count, const u8 *buf);
+	int (*update_reg)(struct acpm_handle *handle, unsigned int acpm_chan_id,
+			  u8 type, u8 reg, u8 chan, u8 value, u8 mask);
 };
 
 struct acpm_ops {
@@ -45,7 +40,7 @@ struct acpm_handle {
 
 struct device;
 
-const struct acpm_handle *devm_acpm_get_by_node(struct device *dev,
-						struct device_node *np);
+struct acpm_handle *devm_acpm_get_by_node(struct device *dev,
+					  struct device_node *np);
 
 #endif /* __EXYNOS_ACPM_PROTOCOL_H */


