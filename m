Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B61D19049B;
	Thu, 20 Aug 2026 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243463; cv=none; b=LoUz6BwYTr2k7BMwME3U7wtiCi1eC8nbrGHsiy//y68gJzL/asP7uPU5qfMFzShdmT5I4Q9tBWI3+eydGpUjnXpPwWAUHn6kIhY7x8Q2Kz6MhYEHDgGTwUElI4m1yBx6mwrRlT9FAZoA9L8PuPg7sAiAXJnsjqh9/uB9AvRYavk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243463; c=relaxed/simple;
	bh=Xejtk1F8uIm7PtIdOzQdFpXpRDN5lRzAUjkgDfsbDvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r77nzWo+wBzNkJz4DMbCaR5tO7GdgZAIb0klau2mLutjfurR4q56SrKznn1zJOCR2LXRbcwFY1Hul8lACjIP/Xx0c6OcalKkn4QMm59yrjS5h+H7KQzRPDnFf2QFZOav0K03Y++qJQmfsPbyosWbP3pryFQrnffwGS9lY77vpxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSQBuVfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSQBuVfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CF91F000E9;
	Thu, 20 Aug 2026 16:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243462;
	bh=plChmC2hQaaXyedmiLerFHcm/I7q9zsPYbN3dsCua8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSQBuVfJJwB10G7V8CNB/NcfnbwEblSIVTTp2A26mru+K6IXpecVyNk/OPpr8sI69
	 Y66oUpUJeKq35kUp5l4uu3xLE3KPTYnvs4DUD1a4edrVfyQMuws8NlK4J4aVPgo5/K
	 ImsgkrJ1fTlBplO7Ec5SSxurdEyrxIWGJ3vRLk8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Lal <quic_ylal@quicinc.com>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/272] remoteproc: qcom: pas: Adjust the phys addr wrt the mem region
Date: Thu, 20 Aug 2026 16:54:46 +0200
Message-ID: <20260820145234.330092915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -83,6 +83,24 @@ struct qcom_adsp {
 	struct qcom_sysmon *sysmon;
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
@@ -90,7 +108,7 @@ static void adsp_minidump(struct rproc *
 	if (rproc->dump_conf == RPROC_COREDUMP_DISABLED)
 		return;
 
-	qcom_minidump(rproc, adsp->minidump_id);
+	qcom_minidump(rproc, adsp->minidump_id, adsp_segment_dump);
 }
 
 static int adsp_pds_enable(struct qcom_adsp *adsp, struct device **pds,


