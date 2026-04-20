Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DE12FE56A;
	Mon, 20 Apr 2026 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700711; cv=none; b=nmDWlSY3sllrZS8J2d07n3e2Ro9gPQJu7imzhclxn7y1bIulqStOLMO9emFIQAInkE/GBxI/ixdDZvbyl3bBpwscvVeEJZGtwupyHyDGl+cGmxKzbIUP4jSA9/sS1fR//pDOig8gfvEn46BAGj4toFonzUq3CrrCYAUS0IWRpso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700711; c=relaxed/simple;
	bh=ZEQMvAoT7TU2samyFQpH0YmhbRAeb9Ty1pmC4hUzoHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kWMCQwnuWlzGc3glrmCnhj54VbV8rz7uarDjwXoyp4v5m4cOe9yfI2FdFGT+k58lhdgOB7FlqT7lwfHaqwxRTTa1DuIlaDfnueE50Tk0mp7USU8f3RwXoUtVcCogn3BjNvdVcnekuEWuHWWF+RFDtvhDaHU6yP4hYQz/aRkCSbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNL8rGaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNL8rGaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DEAC19425;
	Mon, 20 Apr 2026 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700710;
	bh=ZEQMvAoT7TU2samyFQpH0YmhbRAeb9Ty1pmC4hUzoHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNL8rGaSoQml77QlE6BkkJ4q/MtyvBYWqXV/1kCcz1+xWvTiQauuIxTOfebJV3437
	 cvvF64FsaBzjGMG2l9TjdErebjOD2XwYFdkBUBWSiILnxnI4LqSFBWGDQayKbcqHYy
	 JGW0cEuzluUpauC84QBxaep3I22BiSYn1+GuaXQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/198] arm64: dts: qcom: monaco: Reserve full Gunyah metadata region
Date: Mon, 20 Apr 2026 17:40:36 +0200
Message-ID: <20260420153937.668147168@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 85d98669fa7f1d3041d962515e45ee6e392db6f8 ]

We observe spurious "Synchronous External Abort" exceptions
(ESR=0x96000010) and kernel crashes on Monaco-based platforms.
These faults are caused by the kernel inadvertently accessing
hypervisor-owned memory that is not properly marked as reserved.

>From boot log, The Qualcomm hypervisor reports the memory range
at 0x91a80000 of size 0x80000 (512 KiB) as hypervisor-owned:
qhee_hyp_assign_remove_memory: 0x91a80000/0x80000 -> ret 0

However, the EFI memory map provided by firmware only reserves the
subrange 0x91a40000–0x91a87fff (288 KiB). The remaining portion
(0x91a88000–0x91afffff) is incorrectly reported as conventional
memory (from efi debug):
efi:   0x000091a40000-0x000091a87fff [Reserved...]
efi:   0x000091a88000-0x0000938fffff [Conventional...]

As a result, the allocator may hand out PFNs inside the hypervisor
owned region, causing fatal aborts when the kernel accesses those
addresses.

Add a reserved-memory carveout for the Gunyah hypervisor metadata
at 0x91a80000 (512 KiB) and mark it as no-map so Linux does not
map or allocate from this area.

For the record:
Hyp version: gunyah-e78adb36e debug (2025-11-17 05:38:05 UTC)
UEFI Ver: 6.0.260122.BOOT.MXF.1.0.c1-00449-KODIAKLA-1

Fixes: 7be190e4bdd2 ("arm64: dts: qcom: add QCS8300 platform")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260302142603.1113355-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8300.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcs8300.dtsi b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
index b8d4a75baee22..7a4c3e872d8ee 100644
--- a/arch/arm64/boot/dts/qcom/qcs8300.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
@@ -756,6 +756,11 @@ smem_mem: smem@90900000 {
 			hwlocks = <&tcsr_mutex 3>;
 		};
 
+		gunyah_md_mem: gunyah-md-region@91a80000 {
+			reg = <0x0 0x91a80000 0x0 0x80000>;
+			no-map;
+		};
+
 		lpass_machine_learning_mem: lpass-machine-learning-region@93b00000 {
 			reg = <0x0 0x93b00000 0x0 0xf00000>;
 			no-map;
-- 
2.53.0



