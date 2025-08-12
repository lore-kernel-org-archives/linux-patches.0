Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25431DF27F;
	Tue, 12 Aug 2025 18:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023307; cv=none; b=QHOSdy+4mJkNah0GKz1rj2+Yz13tmOLyvwPtgyu3eNf50iu544I9KVFy85043Uv33Ixsbn1LeenrVFo9CK61539LTsNqW/6fm7rxIIdo1OvEthSMnKX1YFVdD4SILzTYrON3/gAfPj32mWEqMej8NA0WMCSAC3VKGCmJaHhh8Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023307; c=relaxed/simple;
	bh=5x+NS+iQefR3oqC0M+hXo3uesDGinVC2YtlSbbJP7Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mE5jSgdAgOuajieydgW9BOy88h+2ZWEbFQD7B+zF3dbMBcJDgmDeDJTa+bhg/6O68sNlD+pyYSo5VWSVcopi1OXSEr0eNZvZrAZZAWC06zc/OHTJYeJMK8kw2b4nU771ekWJdlJbwMjUJKXnl0StET33BcWE65ohxWkVv2/Xz4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7KnbpP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7KnbpP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210F4C4CEF1;
	Tue, 12 Aug 2025 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023307;
	bh=5x+NS+iQefR3oqC0M+hXo3uesDGinVC2YtlSbbJP7Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7KnbpP/zN0MTkHD2QIH8NSLnxUIn/gZ7v9chpvf1hU7FXCtU2wWyTMTwL11I3dXG
	 rdyMiaPXYin6Lo9qkMstL63uCbVmesxddqWYqku6YetxxMfEyLi4oDNJOSDhKT4yHI
	 VEJKCsts3Knt4jHDkvVh+iq+RruJJ5iylMwSNwF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 042/627] arm64: dts: qcom: qcs615: fix a crash issue caused by infinite loop for Coresight
Date: Tue, 12 Aug 2025 19:25:37 +0200
Message-ID: <20250812173420.943144038@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit bd4f35786d5f0798cc1f8c187a81a7c998e6c58f ]

An infinite loop has been created by the Coresight devices. When only a
source device is enabled, the coresight_find_activated_sysfs_sink function
is recursively invoked in an attempt to locate an active sink device,
ultimately leading to a stack overflow and system crash. Therefore, disable
the replicator1 to break the infinite loop and prevent a potential stack
overflow.

replicator1_out   ->   funnel_swao_in6   ->   tmc_etf_swao_in   ->  tmc_etf_swao_out
     |                                                                     |
replicator1_in                                                     replicator_swao_in
     |                                                                     |
replicator0_out1                                                   replicator_swao_out0
     |                                                                     |
replicator0_in                                                     funnel_in1_in3
     |                                                                     |
tmc_etf_out <- tmc_etf_in <- funnel_merg_out <- funnel_merg_in1 <- funnel_in1_out

[call trace]
   dump_backtrace+0x9c/0x128
   show_stack+0x20/0x38
   dump_stack_lvl+0x48/0x60
   dump_stack+0x18/0x28
   panic+0x340/0x3b0
   nmi_panic+0x94/0xa0
   panic_bad_stack+0x114/0x138
   handle_bad_stack+0x34/0xb8
   __bad_stack+0x78/0x80
   coresight_find_activated_sysfs_sink+0x28/0xa0 [coresight]
   coresight_find_activated_sysfs_sink+0x5c/0xa0 [coresight]
   coresight_find_activated_sysfs_sink+0x5c/0xa0 [coresight]
   coresight_find_activated_sysfs_sink+0x5c/0xa0 [coresight]
   coresight_find_activated_sysfs_sink+0x5c/0xa0 [coresight]
   ...
   coresight_find_activated_sysfs_sink+0x5c/0xa0 [coresight]
   coresight_enable_sysfs+0x80/0x2a0 [coresight]

side effect after the change:
Only trace data originating from AOSS can reach the ETF_SWAO and EUD sinks.

Fixes: bf469630552a ("arm64: dts: qcom: qcs615: Add coresight nodes")
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250522005016.2148-1-jie.gan@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs615.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/qcs615.dtsi b/arch/arm64/boot/dts/qcom/qcs615.dtsi
index bb8b6c3ebd03..559d3a4ba605 100644
--- a/arch/arm64/boot/dts/qcom/qcs615.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs615.dtsi
@@ -1902,6 +1902,7 @@ replicator@604a000 {
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
+			status = "disabled";
 
 			in-ports {
 				port {
-- 
2.39.5



