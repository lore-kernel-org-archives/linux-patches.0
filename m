Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BF04BEE32;
	Sat, 12 Sep 2026 11:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211973; cv=none; b=LnQ1Iazo/6+huX9lfzdSkGozGdQ4Plzith+2KyFvY7EXHY3TVkKVc0yPnSU6kYp8Bq6xD5dIyiKjwGk/Sl+OMKs4w2wlQ8OoDMiZ7+FRPAg9zOGq03jXq6sBKJIfMQAymX86O+UI9kmrgSSxP3Z2/0cg7vlVjc3gNt4mu2wBh0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211973; c=relaxed/simple;
	bh=5X1MVUjgGiptWK1GJmBjCr2MmY0CPTOsOPwdeLqJTT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcLWpyQCyF/l6cmHKfXd5k2o+wQrc/FY+ngbSDpEh7ERiUifyCvRD9WjhR3uggTH8cXTlK/SeCVfuRZjntmbfQMhBZVI/xlbCB+qeq3GWBSVQrCY/wxHhHaWnoB+zqAGPZLWl1seLzqKrIThuHDtgT5EtNX7maal1T8xoGIMVM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9EocgGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9EocgGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93AD1F000FF;
	Sat, 12 Sep 2026 11:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211972;
	bh=eucMdDcyPJQA/XdgnrbhmOmdfMdlbQ+znklcPAc8Mqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9EocgGIjg9ctEOV5uqaPT8f7Y6OCufThMwOEsQgb3HRwhhek6G+JXXlAw+CBza2w
	 sbLHYCD7yIZqdCUgVhKfRLmOVb8XSwEIfk+fzWNfNqnOaYOMnmAoLcF3n6GnO547KX
	 8XRmR1EweJj8riJgv5RSltXLWtn/4MxizHtfZ5Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1342/1518] IB/core: Add helper to convert port attributes to data rate
Date: Sat, 12 Sep 2026 08:58:31 +0200
Message-ID: <20260912065653.888606495@linuxfoundation.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 2941abac6d0bffd6bf8f438135505b39168a0a08 ]

Introduce ib_port_attr_to_rate() to compute the data rate in 100 Mbps
units (deci-Gb/sec) from a port's active_speed and active_width
attributes. This generic helper removes duplicated speed-to-rate
calculations, which are used by sysfs and the upcoming new verb.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport state modification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 51 +++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         | 14 +++++++++
 2 files changed, 65 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 2ef4358b01c52..4357164a9976c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -213,6 +213,57 @@ __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate)
 }
 EXPORT_SYMBOL(ib_rate_to_mbps);
 
+struct ib_speed_attr {
+	const char *str;
+	int speed;
+};
+
+#define IB_SPEED_ATTR(speed_type, _str, _speed) \
+	[speed_type] = {.str = _str, .speed = _speed}
+
+static const struct ib_speed_attr ib_speed_attrs[] = {
+	IB_SPEED_ATTR(IB_SPEED_SDR, " SDR", 25),
+	IB_SPEED_ATTR(IB_SPEED_DDR, " DDR", 50),
+	IB_SPEED_ATTR(IB_SPEED_QDR, " QDR", 100),
+	IB_SPEED_ATTR(IB_SPEED_FDR10, " FDR10", 100),
+	IB_SPEED_ATTR(IB_SPEED_FDR, " FDR", 140),
+	IB_SPEED_ATTR(IB_SPEED_EDR, " EDR", 250),
+	IB_SPEED_ATTR(IB_SPEED_HDR, " HDR", 500),
+	IB_SPEED_ATTR(IB_SPEED_NDR, " NDR", 1000),
+	IB_SPEED_ATTR(IB_SPEED_XDR, " XDR", 2000),
+};
+
+int ib_port_attr_to_speed_info(struct ib_port_attr *attr,
+			       struct ib_port_speed_info *speed_info)
+{
+	int speed_idx = attr->active_speed;
+
+	switch (attr->active_speed) {
+	case IB_SPEED_DDR:
+	case IB_SPEED_QDR:
+	case IB_SPEED_FDR10:
+	case IB_SPEED_FDR:
+	case IB_SPEED_EDR:
+	case IB_SPEED_HDR:
+	case IB_SPEED_NDR:
+	case IB_SPEED_XDR:
+	case IB_SPEED_SDR:
+		break;
+	default:
+		speed_idx = IB_SPEED_SDR; /* Default to SDR for invalid rates */
+		break;
+	}
+
+	speed_info->str = ib_speed_attrs[speed_idx].str;
+	speed_info->rate = ib_speed_attrs[speed_idx].speed;
+	speed_info->rate *= ib_width_enum_to_int(attr->active_width);
+	if (speed_info->rate < 0)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(ib_port_attr_to_speed_info);
+
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(unsigned int node_type)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0a1be798255bb..2205c92bdce0a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -876,6 +876,20 @@ __attribute_const__ int ib_rate_to_mult(enum ib_rate rate);
  */
 __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate);
 
+struct ib_port_speed_info {
+	const char *str;
+	int rate;	/* in deci-Gb/sec (100 MBps units) */
+};
+
+/**
+ * ib_port_attr_to_speed_info - Convert port attributes to speed information
+ * @attr: Port attributes containing active_speed and active_width
+ * @speed_info: Speed information to return
+ *
+ * Returns 0 on success, -EINVAL on error.
+ */
+int ib_port_attr_to_speed_info(struct ib_port_attr *attr,
+			       struct ib_port_speed_info *speed_info);
 
 /**
  * enum ib_mr_type - memory region type
-- 
2.53.0



