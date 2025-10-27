Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7B2320CAC;
	Mon, 27 Oct 2025 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590636; cv=none; b=t6JA2qwulAjUgtftC/2h5OIKpG0cPDaqp844i78yby3dSrsbJIZ6zK1BmngoAZ7neXitHX+ZNNA/YFQ7tl8yCJpKxeTkeRvXIBPmSAfA/bBUWA/5wtYFmuiUr7Ed9Bos4ieY/fG+3U/Rvolhs6qGIi1V7iLc78CJfyJvsHSOSNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590636; c=relaxed/simple;
	bh=+6TQgRtIGhxDt7x6ftUF8OpKVu7ss5gpdd4/CqQDoyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex8+bA78eTJvHCWfXJMiCeUUcZ9Sp6NCG0EMqVkKm+Ln54PQ5XkSHppHwRSo2bB9kuCPKo1oWmYshdSbV7BopB/12eUe81ffkKxCSwxr2NnHw5DPWHxK86jb5tyLQcPXi0H9/0IYAuV2TLzSla5YwQb/BAOT0sEYaD8xIyjfl/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FeqN9dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FeqN9dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E491AC4CEF1;
	Mon, 27 Oct 2025 18:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590636;
	bh=+6TQgRtIGhxDt7x6ftUF8OpKVu7ss5gpdd4/CqQDoyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FeqN9dddc4zCSOgPGQfpEqI/CuA2HqxKP3bHooJvhEzvkRWkjPkHqc3s6Z2p3ZE4
	 6mu5N7VIzFIBhOtap2jefzo2//KzT/kNHM24sDwesowu+n1ec6R5TnxcR8yh+MO6I3
	 lPaPJxdVYMCHySdsvbXZrJzYINY1a9v+Ih9l934w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.4 102/224] arm64: dts: qcom: msm8916: Add missing MDSS reset
Date: Mon, 27 Oct 2025 19:34:08 +0100
Message-ID: <20251027183511.719524587@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 99b78773c2ae55dcc01025f94eae8ce9700ae985 upstream.

On most MSM8916 devices (aside from the DragonBoard 410c), the bootloader
already initializes the display to show the boot splash screen. In this
situation, MDSS is already configured and left running when starting Linux.
To avoid side effects from the bootloader configuration, the MDSS reset can
be specified in the device tree to start again with a clean hardware state.

The reset for MDSS is currently missing in msm8916.dtsi, which causes
errors when the MDSS driver tries to re-initialize the registers:

 dsi_err_worker: status=6
 dsi_err_worker: status=6
 dsi_err_worker: status=6
 ...

It turns out that we have always indirectly worked around this by building
the MDSS driver as a module. Before v6.17, the power domain was temporarily
turned off until the module was loaded, long enough to clear the register
contents. In v6.17, power domains are not turned off during boot until
sync_state() happens, so this is no longer working. Even before v6.17 this
resulted in broken behavior, but notably only when the MDSS driver was
built-in instead of a module.

Cc: stable@vger.kernel.org
Fixes: 305410ffd1b2 ("arm64: dts: msm8916: Add display support")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250915-msm8916-resets-v1-1-a5c705df0c45@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1599,6 +1599,8 @@
 		hexagon_smp2p_in: slave-kernel {
 			qcom,entry-name = "slave-kernel";
 
+			resets = <&gcc GCC_MDSS_BCR>;
+
 			interrupt-controller;
 			#interrupt-cells = <2>;
 		};


