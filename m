Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298433EC;
	Tue,  6 Jan 2026 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720709; cv=none; b=Cw1HeN9+xBEBr44WeRbsrkFa0ZlsfzfbLjQ7XP3XrgF48TRy3GYuk3dejWveii8KNDhVGlbvebHbWbMOgXv6jrJiKGbi1tooCvfoigh2oHYd/mSv1fvyJnWzNqfsSbG4T+AfsSvdyED6wB9KF0gV+ap3vcW2EnkjbXXoCrVBMQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720709; c=relaxed/simple;
	bh=P9qZ50A7HYIZnsTXw0SO9VTyHr2COprpqCLxd/Tenpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrS4308gscOYn+IGE+EMUO3ZeDqB2oi4mPpvxGBUNVCCqEhmQdpeaPCZPk8AfsxDRGJeuAIhshioaff2FIgLatIdd9inY4IZh1hKGtRCK86JsKOyUPR/Ybjd/q9be932EajYm10mdtsc3JRcFsizouz0VCV29Lhei8uQQXiGTLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaQRnViO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaQRnViO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D21C116C6;
	Tue,  6 Jan 2026 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720709;
	bh=P9qZ50A7HYIZnsTXw0SO9VTyHr2COprpqCLxd/Tenpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaQRnViOPyHKawUD1jXT56urOJ31ToRan2DeJN2qnRDt9P/Tw3XWbFawXFSzB2031
	 Bi9JgiyFD5Yb97cXRCD1g2d76mcXK1P/cPV+2XVBObNdhUxy/CsANymsYDbXkXup2+
	 eOS9We/K3c/wcQhsNia+VjgKUHTFlJuq4I3Ern54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Lakshmi Sowjanya D <quic_laksd@quicinc.com>
Subject: [PATCH 6.12 285/567] interconnect: qcom: sdx75: Drop QPIC interconnect and BCM nodes
Date: Tue,  6 Jan 2026 18:01:07 +0100
Message-ID: <20260106170501.874208622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>

commit 295f58fdccd05b2d6da1f4a4f81952ccb565c4dc upstream.

As like other SDX SoCs, SDX75 SoC's QPIC BCM resource was modeled as a
RPMh clock in clk-rpmh driver. However, for SDX75, this resource was also
described as an interconnect and BCM node mistakenly. It is incorrect to
describe the same resource in two different providers, as it will lead to
votes from clients overriding each other.

Hence, drop the QPIC interconnect and BCM nodes and let the clients use
clk-rpmh driver to vote for this resource.

Without this change, the NAND driver fails to probe on SDX75, as the
interconnect sync state disables the QPIC nodes as there were no clients
voting for this ICC resource. However, the NAND driver had already voted
for this BCM resource through the clk-rpmh driver. Since both votes come
from Linux, RPMh was unable to distinguish between these two and ends up
disabling the QPIC resource during sync state.

Cc: stable@vger.kernel.org
Fixes: 3642b4e5cbfe ("interconnect: qcom: Add SDX75 interconnect provider driver")
Signed-off-by: Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>
[mani: dropped the reference to bcm_qp0, reworded description]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Lakshmi Sowjanya D <quic_laksd@quicinc.com>  # on SDX75
Link: https://lore.kernel.org/r/20250926-sdx75-icc-v2-1-20d6820e455c@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/sdx75.c |   26 --------------------------
 drivers/interconnect/qcom/sdx75.h |    2 --
 2 files changed, 28 deletions(-)

--- a/drivers/interconnect/qcom/sdx75.c
+++ b/drivers/interconnect/qcom/sdx75.c
@@ -16,15 +16,6 @@
 #include "icc-rpmh.h"
 #include "sdx75.h"
 
-static struct qcom_icc_node qpic_core_master = {
-	.name = "qpic_core_master",
-	.id = SDX75_MASTER_QPIC_CORE,
-	.channels = 1,
-	.buswidth = 4,
-	.num_links = 1,
-	.links = { SDX75_SLAVE_QPIC_CORE },
-};
-
 static struct qcom_icc_node qup0_core_master = {
 	.name = "qup0_core_master",
 	.id = SDX75_MASTER_QUP_CORE_0,
@@ -375,14 +366,6 @@ static struct qcom_icc_node xm_usb3 = {
 	.links = { SDX75_SLAVE_A1NOC_CFG },
 };
 
-static struct qcom_icc_node qpic_core_slave = {
-	.name = "qpic_core_slave",
-	.id = SDX75_SLAVE_QPIC_CORE,
-	.channels = 1,
-	.buswidth = 4,
-	.num_links = 0,
-};
-
 static struct qcom_icc_node qup0_core_slave = {
 	.name = "qup0_core_slave",
 	.id = SDX75_SLAVE_QUP_CORE_0,
@@ -831,12 +814,6 @@ static struct qcom_icc_bcm bcm_mc0 = {
 	.nodes = { &ebi },
 };
 
-static struct qcom_icc_bcm bcm_qp0 = {
-	.name = "QP0",
-	.num_nodes = 1,
-	.nodes = { &qpic_core_slave },
-};
-
 static struct qcom_icc_bcm bcm_qup0 = {
 	.name = "QUP0",
 	.keepalive = true,
@@ -898,14 +875,11 @@ static struct qcom_icc_bcm bcm_sn4 = {
 };
 
 static struct qcom_icc_bcm * const clk_virt_bcms[] = {
-	&bcm_qp0,
 	&bcm_qup0,
 };
 
 static struct qcom_icc_node * const clk_virt_nodes[] = {
-	[MASTER_QPIC_CORE] = &qpic_core_master,
 	[MASTER_QUP_CORE_0] = &qup0_core_master,
-	[SLAVE_QPIC_CORE] = &qpic_core_slave,
 	[SLAVE_QUP_CORE_0] = &qup0_core_slave,
 };
 
--- a/drivers/interconnect/qcom/sdx75.h
+++ b/drivers/interconnect/qcom/sdx75.h
@@ -33,7 +33,6 @@
 #define SDX75_MASTER_QDSS_ETR			24
 #define SDX75_MASTER_QDSS_ETR_1			25
 #define SDX75_MASTER_QPIC			26
-#define SDX75_MASTER_QPIC_CORE			27
 #define SDX75_MASTER_QUP_0			28
 #define SDX75_MASTER_QUP_CORE_0			29
 #define SDX75_MASTER_SDCC_1			30
@@ -76,7 +75,6 @@
 #define SDX75_SLAVE_QDSS_CFG			67
 #define SDX75_SLAVE_QDSS_STM			68
 #define SDX75_SLAVE_QPIC			69
-#define SDX75_SLAVE_QPIC_CORE			70
 #define SDX75_SLAVE_QUP_0			71
 #define SDX75_SLAVE_QUP_CORE_0			72
 #define SDX75_SLAVE_SDCC_1			73


