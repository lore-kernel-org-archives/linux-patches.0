Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056147;
	b=jdI4oCzqsC+oKC4GWMv3wbJfNb5bie9qxybtKYlTnaK348mgO5pIRRcf20NJP3VOPb5N
	 Wk7bKNHpGejSajab4dY9kW65bL4FwGfFHWtl+CdgjPMWeYDJyiwZTBgoonUu3q7BaAhgX
	 d7d+fn1x8LEjJiht+xgGYBN90DMff3/R6c1Zn7OgxdM/e4hKQJEp3Xz70PBxNoCBnduGW
	 dRGNGJ47lVDMjFvP37YAhAXZrYOzVM58iGtPFPEogL0nihZwWzCutQsx0wx2SDWOsC2P+
	 eUExMXMtLnMsqFoQg2HJBod5wfb2wd+MnxXXf1mkvOrzPLfSgxexDTT2jtoiluCthjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xuBirsZQDNmSpaie2UXixhevv6r8Vu/xZSqAasHFCGk=;
	b=x1wkd+ycOtmOYeMvoaL3HhrvFlKy5N+v/mPstlWKjF/hzyAk2ty7rkElRU00Q/PQKwHW
	 qtFTjbOch+CmKILdEigIiqpeoHMc/7hFO8hK6ESWQUC62YtBpBzBeBmGaa/W7SqYlNCK/
	 o2tcHthbIfFycqSiymltFhGU1d2ljk7eRx9OfT3Z3LprkDqHW2UQmReRgPEeTmkDs019K
	 TtQ9ns7zCnsju1nG9xAUvc+9PqebWtE3pKl+gka9Yo7PZSM5DuksQwXnBmQCQL3pVdVSs
	 gNTq16JoDVB2+HoX+nNkOm4wyIEmv2ctKJ7Sp2sBkyuvZWpkIrnaVUCHPnLQHRTfRtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MfAtqETJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F18606A333;
	Thu, 19 Nov 2026 02:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MfAtqETJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589121F000C7;
	Thu, 19 Nov 2026 02:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056146;
	bh=xuBirsZQDNmSpaie2UXixhevv6r8Vu/xZSqAasHFCGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfAtqETJpQW5JYlm/urZwickdjTuqqj0k1wambs2slyI8U4gUnmC6vI4mUKhapp0j
	 VU1iFvDQXE592HRfAJBlWMBahbXJscSiEOASMgspBYM/fo1RWo2Ce2MVO/A3xkLSot
	 cvNCMruDXUKmlqzkufqj/lQLHam7cBf8GaCJABG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1884/2214] clk: qcom: rcg2: Clear force enable after rate failure
Date: Wed, 18 Nov 2026 15:59:20 +0100
Message-ID: <20261118150126.600194349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit d4e8c6b9aef42d06cf5755543ad10097b2217990 ]

Shared RCG rate changes assert force-enable before programming the new
configuration. If programming fails, the function returns without
clearing force-enable, leaving the root running while CCF can release
temporary parent and resource references.

Attempt to clear force-enable on the configuration error path before
returning the original programming error. This restores the same cleanup
performed after a successful configuration while preserving the primary
failure for callers.

Fixes: 7ef6f11887bd ("clk: qcom: Configure the RCGs to a safe source as needed")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-qc_clk_fixes-v1-3-5531cb00514b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index d72e6424ea1b1..71aa7f1ef32f1 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -965,8 +965,10 @@ clk_rcg2_shared_force_enable_clear(struct clk_hw *hw, const struct freq_tbl *f)
 		return ret;
 
 	ret = clk_rcg2_configure(rcg, f);
-	if (ret)
+	if (ret) {
+		clk_rcg2_clear_force_enable(hw);
 		return ret;
+	}
 
 	return clk_rcg2_clear_force_enable(hw);
 }
-- 
2.53.0



