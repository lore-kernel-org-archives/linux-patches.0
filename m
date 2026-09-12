Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7A4428475;
	Sat, 12 Sep 2026 10:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208382; cv=none; b=n6p9/OgqTeyJpD9m4gw6dS+f88Qz6jCY231g6QcZ86zm7Z07devMuAs8AiygacvrGsuRs44L5mxZUEIQRUOY+xpPOgY8cJyGOtnZEAyZENfWAwM2jlAFpHy/7c42Nfb68sE9uzUZtCO4xgRXubHHLJrCiwfrWBP7saXHAsyWGqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208382; c=relaxed/simple;
	bh=zIWXP0NRHsrS5kypF10LwXeU6CBcw3c0+OQz++G/Y4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp2vnbgm2c3qjRxA1XiICd71BGTPUYV89oEn1EuI9x1HL3LLGnYo3iUXNq4d4ZWBDiya4iBfuvi29xQ+4BIf0acHzjhsVDunWZDMyH5R5Mjl0CFc2HqWj/evO0wgMnjkad6EP7+HIiISNRumYmvRV4u0qgiFaAZw6Ha9RW73yvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijQBigF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijQBigF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2D21F000FF;
	Sat, 12 Sep 2026 10:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208378;
	bh=rVxPJkXp+mnEfp68YmQWTuRSJYILk6DGPzu7BTsBp5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijQBigF9L+qK4zen1/qpDMUZ8kNLI0Ql3XJDTq5k7MoI7bZ0IgYOPA9d5ahUzQDx2
	 dfzxI8AYlO6hEUIsr5C4FDg/L/UCXuXA52KsHbxXJlO9y8sNYCB99qy6I/yqMpVaJO
	 shrZCK+wjj8PdKMGcSX6dGfO1nRpakUmb9GPGUIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0598/1518] firmware: qcom_scm: Introduce PAS context allocator helper function
Date: Sat, 12 Sep 2026 08:46:07 +0200
Message-ID: <20260912065636.951691072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit ccb7bde5f7cc794dee0cd66fd451cb0e0715712d ]

When the Peripheral Authentication Service (PAS) method runs on a SoC
where Linux operates at EL2 (i.e., without the Gunyah hypervisor), the
reset sequences are handled by TrustZone. In such cases, Linux must
perform additional steps before invoking PAS SMC calls, such as creating
a SHM bridge. Therefore, PAS SMC calls require awareness and handling of
these additional steps when Linux runs at EL2.

To support this, there is a need for a data structure that can be
initialized prior to invoking any SMC or MDT functions. This structure
allows those functions to determine whether they are operating in the
presence or absence of the Gunyah hypervisor and behave accordingly.

Currently, remoteproc and non-remoteproc subsystems use different
variants of the MDT loader helper API, primarily due to differences in
metadata context handling. Remoteproc subsystems retain the metadata
context until authentication and reset are completed, while
non-remoteproc subsystems (e.g., video, graphics, IPA, etc.) do not
retain the metadata context and can free it within the
qcom_scm_pas_init() call by passing a NULL context parameter and due to
these differences, it is not possible to extend metadata context
handling to support remoteproc and non remoteproc subsystem use PAS
operations, when Linux operates at EL2.

Add PAS context data structure allocator helper function.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260105-kvmrprocv10-v10-4-022e96815380@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 0ea50486978f ("remoteproc: qcom: q6v5: Request shutdown if crash is triggered host-side")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c       | 34 ++++++++++++++++++++++++++
 include/linux/firmware/qcom/qcom_scm.h | 14 +++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 3379607eaf94f..2e51c4d80fdce 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -558,6 +558,40 @@ static void qcom_scm_set_download_mode(u32 dload_mode)
 		dev_err(__scm->dev, "failed to set download mode: %d\n", ret);
 }
 
+/**
+ * devm_qcom_scm_pas_context_alloc() - Allocate peripheral authentication service
+ *				       context for a given peripheral
+ *
+ * PAS context is device-resource managed, so the caller does not need
+ * to worry about freeing the context memory.
+ *
+ * @dev:	  PAS firmware device
+ * @pas_id:	  peripheral authentication service id
+ * @mem_phys:	  Subsystem reserve memory start address
+ * @mem_size:	  Subsystem reserve memory size
+ *
+ * Returns: The new PAS context, or ERR_PTR() on failure.
+ */
+struct qcom_scm_pas_context *devm_qcom_scm_pas_context_alloc(struct device *dev,
+							     u32 pas_id,
+							     phys_addr_t mem_phys,
+							     size_t mem_size)
+{
+	struct qcom_scm_pas_context *ctx;
+
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->dev = dev;
+	ctx->pas_id = pas_id;
+	ctx->mem_phys = mem_phys;
+	ctx->mem_size = mem_size;
+
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(devm_qcom_scm_pas_context_alloc);
+
 /**
  * qcom_scm_pas_init_image() - Initialize peripheral authentication service
  *			       state machine for a given peripheral, using the
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index a13f703b16cd4..5045f8fe876da 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -72,6 +72,20 @@ struct qcom_scm_pas_metadata {
 	ssize_t size;
 };
 
+struct qcom_scm_pas_context {
+	struct device *dev;
+	u32 pas_id;
+	phys_addr_t mem_phys;
+	size_t mem_size;
+	void *ptr;
+	dma_addr_t phys;
+	ssize_t size;
+};
+
+struct qcom_scm_pas_context *devm_qcom_scm_pas_context_alloc(struct device *dev,
+							     u32 pas_id,
+							     phys_addr_t mem_phys,
+							     size_t mem_size);
 int qcom_scm_pas_init_image(u32 pas_id, const void *metadata, size_t size,
 			    struct qcom_scm_pas_metadata *ctx);
 void qcom_scm_pas_metadata_release(struct qcom_scm_pas_metadata *ctx);
-- 
2.53.0



