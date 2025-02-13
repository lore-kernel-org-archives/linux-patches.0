Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F2826B0A5;
	Thu, 13 Feb 2025 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459645; cv=none; b=R5CQK2r85XVThUBaIgfLxbIp/a37Vjvjtl9HF4o1ML/RM4q4hMyvTppIcFfJaivVTCGZqGKCqpidDxwlQA9IRwfV+L79Cg+KBT87xK2I/YIQpYrsqJfDOU/l/jLcmQ212UxoG9eNGn8CvxC4dbLUFPJZszi9+Sjp25OOBXBxCJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459645; c=relaxed/simple;
	bh=CbZf/auuhtQ+YJlmx3sPjd/MhQZBKoLfggxgqlrcd+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlLY2J3QhBi7sbaVPr+Gtqc81JPSHLEI9qr3C4cfAqFKBb+UyEB160028CwZ7QbYOP2vBUtUN5bcWUbF6c4BLtYCXrjVQrL38SUvugBOFts2YX4YYbz2FtKrMeJVpVy6bJSQmo1AF6osYD/H+TyDT+mdXn8etaYhmYtGoBIesKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIfxKng8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIfxKng8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E057C4CED1;
	Thu, 13 Feb 2025 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459644;
	bh=CbZf/auuhtQ+YJlmx3sPjd/MhQZBKoLfggxgqlrcd+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIfxKng8OagwLyBXn1zX6j4347iEXa35PwFqzl+wu/Sg6+3AaxVNb7WXXlTWfcOIS
	 y5g5XlEAj7MwPNntshr2BnxIcpycI4JHh6AIGSGJmo3DomuAwdzlyN01kwcl6FHO7H
	 2L+mW64KomvM7cF+HF+kw8TFrkdzGihE4oUeD/3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 323/443] arm64: dts: qcom: sm8650: correct MDSS interconnects
Date: Thu, 13 Feb 2025 15:28:08 +0100
Message-ID: <20250213142453.083996005@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 9fa33cbca3d2842f1f47ed4e5f6574e611dae32b upstream.

SM8650 lists two interconnects for the display subsystem, mdp0-mem
(between MDP and LLCC) and mdp1-mem (between LLCC and EBI, memory).
The second interconnect is a misuse. mdpN-mem paths should be used for
several outboud MDP interconnects rather than the path between LLCC and
memory. This kind of misuse can result in bandwidth underflows, possibly
degrading picture quality as the required memory bandwidth is divided
between all mdpN-mem paths (and LLCC-EBI should not be a part of such
division).

Drop the second path and use direct MDP-EBI path for mdp0-mem until we
support separate MDP-LLCC and LLCC-EBI paths.

Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Cc: stable@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241026-fix-sm8x50-mdp-icc-v2-2-fd8ddf755acc@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -3603,11 +3603,8 @@
 			resets = <&dispcc DISP_CC_MDSS_CORE_BCR>;
 
 			interconnects = <&mmss_noc MASTER_MDP QCOM_ICC_TAG_ALWAYS
-					 &gem_noc SLAVE_LLCC QCOM_ICC_TAG_ALWAYS>,
-					<&mc_virt MASTER_LLCC QCOM_ICC_TAG_ALWAYS
 					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
-			interconnect-names = "mdp0-mem",
-					     "mdp1-mem";
+			interconnect-names = "mdp0-mem";
 
 			power-domains = <&dispcc MDSS_GDSC>;
 


