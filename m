Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1721285CBA;
	Wed, 20 May 2026 18:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301941; cv=none; b=fQbyQN1lQOH/WI1YoQfsKJiqIIyn08jkeY04z8n3F5uImfrIdqwwyNqksmwYyHvIT2z9ikF8DxLdB+2dqgL+lqTbUGjblut+QGbeMFE+4QPW1wLgN38Y7y2Xym22QhLVt1QGuhQzDeeMuIUK34KmPP6adJ45LOu3kyjvN4PeKO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301941; c=relaxed/simple;
	bh=041WuzKkpjDX1/GzvkxY40L2W7ChFCmLWsqkDew948g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPJKJBe3mZ0jZlceo2QDX+e03hHl3QkzbJXU02PVzErBtPjT/lXL5HFvDJ9mTGHpOCFR+0fBFTFvgsJVmgqfCbN4mDzmHmUEMzR4QB1bb0z02axboC1BzSIpmYYh9Bunqs1oaMkWJBalZEMKCBgMEhW96TwJV/5ZKV1Pg/b10eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1p2qu1x0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1p2qu1x0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F8C1F000E9;
	Wed, 20 May 2026 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301940;
	bh=pO/8EoF7Q+5XlVbvDIlP3reU0EZb8VJ9eC1CugRpWto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1p2qu1x0xesExmQty/lsAROOlizZvf89rZslJ0StFRquauF1UHd0esKH//DZ3HSy3
	 a1aUxzFdoVWulJr3BBdsQcatLp6HnkhmL0mbxPBpUUezNHghLlV+rF5FADERxa2C/Z
	 5IoemIA9/0JEnEHl/ofFjN0JRF7nroImOf9OixRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Colton Lewis <coltonlewis@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/508] arm64: cpufeature: Make PMUVer and PerfMon unsigned
Date: Wed, 20 May 2026 18:17:39 +0200
Message-ID: <20260520162059.374633597@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit d1dcc20bcc40efe1f1c71639376c91dafa489222 ]

On the host, this change doesn't make a difference because the fields
are defined as FTR_EXACT. However, KVM allows userspace to set these
fields for a guest and overrides the type to be FTR_LOWER_SAFE. And
while KVM used to do an unsigned comparison to validate that the new
value is lower than what the hardware provides, since the linked commit
it uses the generic sanitization framework which does a signed
comparison.

Fix it by defining these fields as unsigned. In theory, without this
fix, userspace could set a higher PMU version than the hardware supports
by providing any value with the top bit set.

Fixes: c118cead07a7 ("KVM: arm64: Use generic sanitisation for ID_(AA64)DFR0_EL1")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 4561c4a670afb..5db25bfb854ff 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -453,7 +453,7 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	 * We can instantiate multiple PMU instances with different levels
 	 * of support.
 	 */
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_EL1_PMUVer_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_EL1_PMUVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_EL1_DebugVer_SHIFT, 4, 0x6),
 	ARM64_FTR_END,
 };
@@ -597,7 +597,7 @@ static const struct arm64_ftr_bits ftr_id_pfr2[] = {
 
 static const struct arm64_ftr_bits ftr_id_dfr0[] = {
 	/* [31:28] TraceFilt */
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_DFR0_EL1_PerfMon_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_DFR0_EL1_PerfMon_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_EL1_MProfDbg_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_EL1_MMapTrc_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_EL1_CopTrc_SHIFT, 4, 0),
-- 
2.53.0



