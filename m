Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2BA47255C;
	Thu, 20 Aug 2026 17:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248106; cv=none; b=X7dakpcS9zYBAwdkF0xPsq4on8jqzYasPXLFHcjuqZUcNXqrzQmNQ/JUyQQ+jYTqky7ygDZk0PnikVrTo/2nUJcxiKEW/mjFTrhCrUOeZ0QXmb90JKM9GnIO+Hiv+849CQLtkkfEZ+Y94ciENzDVinN612gyDxOENvUelXtx4fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248106; c=relaxed/simple;
	bh=h3ZU6lZYHF9C1cT5iIux1Olxy/b4/hXz80UcybhVKcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km5SlU4KbI5KLLJmJWYtgXunqY1Om6lsNSDHnhutaY1MCI/WmgozA76NLUINUrq8K8PUiPIWG8QTqp2tIVS9YoyHdPRPDMWahOwpEXVMFjQ6c2NVrIVbfqt/H4mvCe3QiJmpERFJSZk1VXJUEDSg75uKS8E71CZjV9DHp8dnbxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12ohd3JE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12ohd3JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8891F000E9;
	Thu, 20 Aug 2026 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248104;
	bh=lLxMsoX7L08KLmUHWkoCAAOAxLaqyivzPVYfWOtqY2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12ohd3JE/zZLE2qGe0tkYnN27PRiTBBs9VHIf2pvBYXPWYKuSpHSnQBqtNUnqZnBz
	 eZW4UNo3BjK84hvIzV2M7w5DxbXf/mhxiGgxFvtDl1qoZ3JqaDGH+NwabsMN2Q5lPX
	 rrgM7NxCG5WDyB+o4IIHdQG+GBiPNit7KTkSA5K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Lal <quic_ylal@quicinc.com>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/303] remoteproc: qcom: pas: Adjust the phys addr wrt the mem region
Date: Thu, 20 Aug 2026 16:54:09 +0200
Message-ID: <20260820145256.676753412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Yogesh Lal <quic_ylal@quicinc.com>

[ Upstream commit a376c10d45a8e6ee5ea55791193f90625b35e156 ]

The minidump table in the toc contains physical addresses that may lie
before the physical address of the first elf segment in relocatable
images. This change adds a custom dump function for minidumps which
calculates the offset into the carveout region using the start of
the physical address instead of the start of the first elf segment.

Signed-off-by: Yogesh Lal <quic_ylal@quicinc.com>
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1667409129-6254-1-git-send-email-quic_ylal@quicinc.com
Stable-dep-of: ecf9fc18e62c ("remoteproc: qcom: Fix leak when custom dump_segments addition fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_common.c   |   13 +++++++++----
 drivers/remoteproc/qcom_common.h   |    5 ++++-
 drivers/remoteproc/qcom_q6v5_pas.c |   20 +++++++++++++++++++-
 3 files changed, 32 insertions(+), 6 deletions(-)

--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -101,7 +101,9 @@ static void qcom_minidump_cleanup(struct
 	}
 }
 
-static int qcom_add_minidump_segments(struct rproc *rproc, struct minidump_subsystem *subsystem)
+static int qcom_add_minidump_segments(struct rproc *rproc, struct minidump_subsystem *subsystem,
+			void (*rproc_dumpfn_t)(struct rproc *rproc, struct rproc_dump_segment *segment,
+				void *dest, size_t offset, size_t size))
 {
 	struct minidump_region __iomem *ptr;
 	struct minidump_region region;
@@ -131,7 +133,7 @@ static int qcom_add_minidump_segments(st
 			}
 			da = le64_to_cpu(region.address);
 			size = le64_to_cpu(region.size);
-			rproc_coredump_add_custom_segment(rproc, da, size, NULL, name);
+			rproc_coredump_add_custom_segment(rproc, da, size, rproc_dumpfn_t, name);
 		}
 	}
 
@@ -139,7 +141,10 @@ static int qcom_add_minidump_segments(st
 	return 0;
 }
 
-void qcom_minidump(struct rproc *rproc, unsigned int minidump_id)
+void qcom_minidump(struct rproc *rproc, unsigned int minidump_id,
+		void (*rproc_dumpfn_t)(struct rproc *rproc,
+		struct rproc_dump_segment *segment, void *dest, size_t offset,
+		size_t size))
 {
 	int ret;
 	struct minidump_subsystem *subsystem;
@@ -169,7 +174,7 @@ void qcom_minidump(struct rproc *rproc,
 		return;
 	}
 
-	ret = qcom_add_minidump_segments(rproc, subsystem);
+	ret = qcom_add_minidump_segments(rproc, subsystem, rproc_dumpfn_t);
 	if (ret) {
 		dev_err(&rproc->dev, "Failed with error: %d while adding minidump entries\n", ret);
 		goto clean_minidump;
--- a/drivers/remoteproc/qcom_common.h
+++ b/drivers/remoteproc/qcom_common.h
@@ -33,7 +33,10 @@ struct qcom_rproc_ssr {
 	struct qcom_ssr_subsystem *info;
 };
 
-void qcom_minidump(struct rproc *rproc, unsigned int minidump_id);
+void qcom_minidump(struct rproc *rproc, unsigned int minidump_id,
+			void (*rproc_dumpfn_t)(struct rproc *rproc,
+				struct rproc_dump_segment *segment, void *dest, size_t offset,
+				size_t size));
 
 void qcom_add_glink_subdev(struct rproc *rproc, struct qcom_rproc_glink *glink,
 			   const char *ssr_name);
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -86,6 +86,24 @@ struct qcom_adsp {
 	struct qcom_scm_pas_metadata pas_metadata;
 };
 
+void adsp_segment_dump(struct rproc *rproc, struct rproc_dump_segment *segment,
+		       void *dest, size_t offset, size_t size)
+{
+	struct qcom_adsp *adsp = rproc->priv;
+	int total_offset;
+
+	total_offset = segment->da + segment->offset + offset - adsp->mem_phys;
+	if (total_offset < 0 || total_offset + size > adsp->mem_size) {
+		dev_err(adsp->dev,
+			"invalid copy request for segment %pad with offset %zu and size %zu)\n",
+			&segment->da, offset, size);
+		memset(dest, 0xff, size);
+		return;
+	}
+
+	memcpy_fromio(dest, adsp->mem_region + total_offset, size);
+}
+
 static void adsp_minidump(struct rproc *rproc)
 {
 	struct qcom_adsp *adsp = rproc->priv;
@@ -93,7 +111,7 @@ static void adsp_minidump(struct rproc *
 	if (rproc->dump_conf == RPROC_COREDUMP_DISABLED)
 		return;
 
-	qcom_minidump(rproc, adsp->minidump_id);
+	qcom_minidump(rproc, adsp->minidump_id, adsp_segment_dump);
 }
 
 static int adsp_pds_enable(struct qcom_adsp *adsp, struct device **pds,


