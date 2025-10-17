Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F543328EA;
	Fri, 17 Oct 2025 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713619; cv=none; b=Fiuyrami0vuIu2gv+gyGq3d8nJEoO2BMtoDlBrPcIl9OTjxuQuzuB+YUmjqxri3jQ7gVQmQooZvBXaSc84yqxpSyk73uYsKwzhQymIfMjbup9HRP/xHqQyT15FBuKf83cgxjpiN3Tq8PsQEQf1XvOHXzIQvtrfc0vUlG4VGhB08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713619; c=relaxed/simple;
	bh=Sby2kkEji8S2hpsjWklzqKSA+9W0fSsKSPEgL6n/fiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7ESdFJuOf6NPYrBgzvFBB3N5jETDlxVNrJoQ+oy2nfr994mn21h3lKi597z0CIrnzEOCSIZsU+KftIy3IGid4dU1MpDt6aot+tP8MCBHqinSO2j/vhGp9K9/WROPmbJ+PRAX61McuVOvo3QfOKd48rm3bVyXowIOvYd0u4CJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYqdxguJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYqdxguJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7A5C4CEE7;
	Fri, 17 Oct 2025 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713619;
	bh=Sby2kkEji8S2hpsjWklzqKSA+9W0fSsKSPEgL6n/fiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYqdxguJfNOvPmDm0FeTq89Dqwhi2Aa0g6UPN9TuPitegN/o3fav5185+bLo9+glI
	 quqmrwoUBtWzn2wzpnqkNmtCZ4DmiyDRn5qOBPZQosjhvi4lUxB2xxNMoESZcZlkhO
	 wRyer/e7ejUJEV4LLwQjPkz4Aaplkou8U580JxEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 061/201] arm64: dts: qcom: msm8916: Add missing MDSS reset
Date: Fri, 17 Oct 2025 16:52:02 +0200
Message-ID: <20251017145136.991399169@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1529,6 +1529,8 @@
 
 			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 
+			resets = <&gcc GCC_MDSS_BCR>;
+
 			interrupt-controller;
 			#interrupt-cells = <1>;
 


