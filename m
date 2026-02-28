Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666904A341A;
	Sat, 28 Feb 2026 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301308; cv=none; b=PrcnK9hb4r9dVHJLJJhb8A+x8+RsaqDzx35dVqsVG4kx/nWwUtZolG25ez7tlxr8OCceCFryblE2M36yhaC/DBGWGkKYmUXR/opqnVbGC2yGmWUgZ8vUnwrsSSg9rBxGleVuCH9+PafNPycdsBgsMzWOzTZ++BQVaed0iCfjJWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301308; c=relaxed/simple;
	bh=jTlycEQO76xPIXbgF0xpHuEnoACw670ePo4XEz+gF6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brrRgewjCzlc/eUvhRbPywLok7B50tvV90fYVtGVsAiZ5rN+Dsed5p3zPVfZvn1yVcTSfugtlxJMKZsNmismS8XNfHKsBgJ2mR38HgvzlYk5BeNPdLPMvuh+ydan4VbbGONqk01QkS6ZOWRoXJWmtgrIZuOHe3WTjj4D3q1ITxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0FsEZ5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0FsEZ5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D420C19425;
	Sat, 28 Feb 2026 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301308;
	bh=jTlycEQO76xPIXbgF0xpHuEnoACw670ePo4XEz+gF6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0FsEZ5c2/kDt8oBqV0KLG7N8S7D/VeBh1pjXL6usFWApEji7d9RXdxmjO+Iy1EVC
	 9H8TvNqou4inQV/dw8b0k63Ry4U3LuIXyBecAd1dwhisU0V64QZTsnBKbMpE6e4YdV
	 47f33o/WDMuOHGvdNZIYp10EuvNspyaHeXzNkkCdDg42SswqKEuaSCbuUmzEC8Fgsb
	 1NcO9aqzpZ3tCekMwbRjWJwzUJ/JGa9BhGwPFEGqo+Cmahequn0OyFVVFPPgHizBbv
	 7Uj0emAoqpcOv/KS5LDvZsaZuN7/pIoSTru1CdqB4y/g3y08DO0qTACVO5jxw0NSP/
	 B9jll+pNUK5fQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 493/752] arm64: dts: qcom: sm8750: Fix BAM DMA probing
Date: Sat, 28 Feb 2026 12:43:24 -0500
Message-ID: <20260228174750.1542406-493-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 1c6192ec9c4ab8bdb7b2cf8763b7ef7e38671ffe ]

Bindings always required "qcom,num-ees" and "num-channels" properties,
as reported by dtbs_check:

  sm8750-mtp.dtb: dma-controller@1dc4000 (qcom,bam-v1.7.4): 'anyOf' conditional failed, one must be fixed:
    'qcom,powered-remotely' is a required property
    'num-channels' is a required property
    'qcom,num-ees' is a required property
    'clocks' is a required property
    'clock-names' is a required property

However since commit 5068b5254812 ("dmaengine: qcom: bam_dma: Fix DT
error handling for num-channels/ees") missing properties are actually
fatal and BAM does not probe:

  bam-dma-engine 1dc4000.dma-controller: num-channels unspecified in dt
  bam-dma-engine 1dc4000.dma-controller: probe with driver bam-dma-engine failed with error -22

Fixes: eeb0f3e4ea67 ("arm64: dts: qcom: sm8750: Add QCrypto nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251229115734.205744-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index a82d9867c7cb6..33963fee1f699 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -2072,6 +2072,8 @@ cryptobam: dma-controller@1dc4000 {
 				 <&apps_smmu 0x481 0>;
 
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <20>;
 			qcom,controlled-remotely;
 		};
 
-- 
2.51.0

