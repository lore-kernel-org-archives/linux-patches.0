Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BD6198E96;
	Wed,  6 Nov 2024 12:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896462; cv=none; b=U+DPfq6r5RGCKxmxdhRCEn2L3QCYzOZeHR4oQcOD1Vr3h8g4rF64jL+fL/UGLrdZPP7zqPovktJzEVseNTTybSobsHwdVslUO+c7kJbF6E1rZx3pFwxtHvjwQqfcKHd1nMC+y6AgM6PNdCsI3W1sngq56AM2c8MWaqRetJkVw/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896462; c=relaxed/simple;
	bh=7S4mPqKfStussWm0zjfZkJG9xiVRhomlAsR9jkG53Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XntNjqUDYVnEKjOJv47RRnlaasEXim1NtsLAnV6z/WI42eQGUrXutSdx/EqVuWarsTYae3ND6wbgIIi/CkYNf4gKrQVC2vQiUPzqP6VHCUkNVyZRYOEvwQ1zexoc89gP/DdCS/skG9j05YCFDb1zBCDN3ygKIcTgh2tYoVacLj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRbkoR2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRbkoR2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A1BC4CECD;
	Wed,  6 Nov 2024 12:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896462;
	bh=7S4mPqKfStussWm0zjfZkJG9xiVRhomlAsR9jkG53Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRbkoR2VsXgh9oTNOm30b55ZBv6dsma2e0RLESnT6t+6W7mhUNMX07L8CwFKQ/ntv
	 ch2/VxZ1vEAXxY9VT3fiQcA5GJHCeaxmjzTPKDNWz5HOLzsYe8OrKe4fK/NBzEIjXQ
	 S3BA4CRJ1hmSqoXXe02vpIoT61kb8oPlvblr+pb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Parent <fabien.parent@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 211/245] arm64: dts: qcom: msm8939: revert use of APCS mbox for RPM
Date: Wed,  6 Nov 2024 13:04:24 +0100
Message-ID: <20241106120324.448844507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabien Parent <fabien.parent@linaro.org>

commit d92e9ea2f0f918d7b01cbacb838288bffccc8954 upstream.

Commit 22e4e43484c4 ("arm64: dts: qcom: msm8939: Use mboxes
properties for APCS") broke the boot on msm8939 platforms.

The issue comes from the SMD driver failing to request the mbox
channel because of circular dependencies:
	1. rpm -> apcs1_mbox -> rpmcc (RPM_SMD_XO_CLK_SRC) -> rpm.
	2. rpm -> apcs1_mbox -> gcc -> rpmcc (RPM_SMD_XO_CLK_SRC) -> rpm
	3. rpm -> apcs1_mbox -> apcs2 -> gcc -> rpmcc (RPM_SMD_XO_CLK_SRC) -> rpm

To fix this issue let's switch back to using the deprecated
qcom,ipc property for the RPM node.

Fixes: 22e4e43484c4 ("arm64: dts: qcom: msm8939: Use mboxes properties for APCS")
Signed-off-by: Fabien Parent <fabien.parent@linaro.org>
Link: https://lore.kernel.org/r/20240904-msm8939-rpm-apcs-fix-v1-1-b608e7e48fe1@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8939.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8939.dtsi b/arch/arm64/boot/dts/qcom/msm8939.dtsi
index 46d9480cd464..39405713329b 100644
--- a/arch/arm64/boot/dts/qcom/msm8939.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8939.dtsi
@@ -248,7 +248,7 @@ rpm: remoteproc {
 
 		smd-edge {
 			interrupts = <GIC_SPI 168 IRQ_TYPE_EDGE_RISING>;
-			mboxes = <&apcs1_mbox 0>;
+			qcom,ipc = <&apcs1_mbox 8 0>;
 			qcom,smd-edge = <15>;
 
 			rpm_requests: rpm-requests {
-- 
2.47.0



