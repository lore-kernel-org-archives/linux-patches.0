Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6861C18DB2A;
	Wed, 25 Feb 2026 01:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983124; cv=none; b=ezA5O5hohGFHyWiDdqtyZ9zxwb2kDSKe89h5OLnGRxX3RpH9cRncr7eu0mQY6YKvSQzDRbX5+0ldqdIt+YAEh1rc3KVqnpz6+b7GA5DR02VgQv1f1Uo7Ts9VV/Ms0u+OzZL3KWHF4nQc5x7IAT3daU1EHxd346O/DwoO2fTnnOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983124; c=relaxed/simple;
	bh=dhYiJ4wPt3YhlQNQSpW7OTx82IzhObkaaO5mh+QLYF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz5D/B2jqm0SZ6xEOtYA2ZqBjRcJaWRLsRgES01UBONifNp9WrWv7uonkBBoAwEYE3liIFXU7+yybn58Do8aGjVpOGg3K5E33ELWIjLv7eOtafJsV/vFHb2F5iuQuCCiu8cmuR1FUQ2yxVztDwfINelV4AqvXtyF+NynLir533E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbbviyER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbbviyER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABEBC19424;
	Wed, 25 Feb 2026 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983124;
	bh=dhYiJ4wPt3YhlQNQSpW7OTx82IzhObkaaO5mh+QLYF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbbviyERVgPGM41VsfwXkPtB8aVEFrYMoarWGcAlTf2Zz2Q9kCrQTHPE5VORd1OZn
	 C5QB1i0AjfSz9NHXf5L3ue7Qbfq6hBGDgrxHniDEDw7hauIVXRcR0Mcj/safb5375A
	 TfNy7OZSZoqx20/ETxPknFejhTD2ws31OZfG+MNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 282/781] drm/msm/dp: Avoid division by zero in msm_dp_ctrl_config_msa()
Date: Tue, 24 Feb 2026 17:16:31 -0800
Message-ID: <20260225012406.618320489@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit f185076da44c774241a16a82a7773ece3c1c607b ]

An (admittedly problematic) optimization change in LLVM 20 [1] turns
known division by zero into the equivalent of __builtin_unreachable(),
which invokes undefined behavior if it is encountered in a control flow
graph, destroying code generation. When compile testing for x86_64,
objtool flags an instance of this optimization triggering in
msm_dp_ctrl_config_msa(), inlined into msm_dp_ctrl_on_stream():

  drivers/gpu/drm/msm/msm.o: warning: objtool: msm_dp_ctrl_on_stream(): unexpected end of section .text.msm_dp_ctrl_on_stream

The zero division happens if the else branch in the first if statement
in msm_dp_ctrl_config_msa() is taken because pixel_div is initialized to
zero and it is not possible for LLVM to eliminate the else branch since
rate is still not known after inlining into msm_dp_ctrl_on_stream().

Transform the if statements into a switch statement with a default case
with the existing error print and an early return to avoid the invalid
division. Add a comment to note this helps the compiler, even though the
case is known to be unreachable. With this, pixel_dev's default zero
initialization can be dropped, as it is dead with this change.

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Link: https://github.com/llvm/llvm-project/commit/37932643abab699e8bb1def08b7eb4eae7ff1448 [1]
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601081959.9UVJEOfP-lkp@intel.com/
Suggested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/698355/
Link: https://lore.kernel.org/r/20260113-drm-msm-dp_ctrl-avoid-zero-div-v2-1-f1aa67bf6e8e@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index cbcc7c2f0ffc4..94411870a5e0a 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -2395,20 +2395,32 @@ static void msm_dp_ctrl_config_msa(struct msm_dp_ctrl_private *ctrl,
 			       bool is_ycbcr_420)
 {
 	u32 pixel_m, pixel_n;
-	u32 mvid, nvid, pixel_div = 0, dispcc_input_rate;
+	u32 mvid, nvid, pixel_div, dispcc_input_rate;
 	u32 const nvid_fixed = DP_LINK_CONSTANT_N_VALUE;
 	u32 const link_rate_hbr2 = 540000;
 	u32 const link_rate_hbr3 = 810000;
 	unsigned long den, num;
 
-	if (rate == link_rate_hbr3)
+	switch (rate) {
+	case link_rate_hbr3:
 		pixel_div = 6;
-	else if (rate == 162000 || rate == 270000)
-		pixel_div = 2;
-	else if (rate == link_rate_hbr2)
+		break;
+	case link_rate_hbr2:
 		pixel_div = 4;
-	else
+		break;
+	case 162000:
+	case 270000:
+		pixel_div = 2;
+		break;
+	default:
+		/*
+		 * This cannot be reached but the compiler is not able to know
+		 * that statically so return early to avoid a possibly invalid
+		 * division.
+		 */
 		DRM_ERROR("Invalid pixel mux divider\n");
+		return;
+	}
 
 	dispcc_input_rate = (rate * 10) / pixel_div;
 
-- 
2.51.0



