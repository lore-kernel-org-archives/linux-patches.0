Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45183289E06;
	Thu, 27 Nov 2025 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255407; cv=none; b=n/7PZ5KudXFM6qFdr1HZtlHSg6jo0Ys3FFMU7O/MIPxeIWWts8DVQQVPSVGaeyC8AdZ7+5Byd90LyDU47NneXJAc6kBF+/h01dZU8B7KgWKNoraWJTHLp6m26gCLjTkRU0khnHT/DwU0Rj3+zEuKy3gcsGqU3JWYw9W2lOMImpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255407; c=relaxed/simple;
	bh=hG9AmPVJGewKC9dIFmRo21WcksmsyqI+2uqsZ7lf6AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5+GvhBUz2xSFP3bcCICQ4rC/1/VWWF3i2rGkh9sYfM/JYEGA+Zr602tZEr3Blhi18kKP9gKfkxOu8achROQdKLQIDAsFd1ccVdusBcF8zfmaubPYW0U09yGtG69QM/emwBEs3+soXE0fwEoY8PrGI4Q9yBTse8CuUjIBGmm9KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7Hm96XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7Hm96XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1131C4CEF8;
	Thu, 27 Nov 2025 14:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255407;
	bh=hG9AmPVJGewKC9dIFmRo21WcksmsyqI+2uqsZ7lf6AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7Hm96XH6NV+e8yxO+jYnxCfjVfBY/8fA6EILjOyPr6NkBKjRVU7m+mCOfCNysBCG
	 J1zdc9uRy2rSnmu30hXSddYltXGw4tFSuHTWu7tRETZ0fD2axprIyh9itpzx6Zz0uY
	 escc9cKa5FFhusN6Um30N53Y3lScgGeiXKptiUfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Maydell <peter.maydell@linaro.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/112] KVM: arm64: Make all 32bit ID registers fully writable
Date: Thu, 27 Nov 2025 15:46:36 +0100
Message-ID: <20251127144036.280838576@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 3f9eacf4f0705876a5d6526d7d320ca91d7d7a16 upstream.

32bit ID registers aren't getting much love these days, and are
often missed in updates. One of these updates broke restoring
a GICv2 guest on a GICv3 machine.

Instead of performing a piecemeal fix, just bite the bullet
and make all 32bit ID regs fully writable. KVM itself never
relies on them for anything, and if the VMM wants to mess up
the guest, so be it.

Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
Reported-by: Peter Maydell <peter.maydell@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20251030122707.2033690-2-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 61 ++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42791971f7588..5c09c788aaa61 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2176,22 +2176,26 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = 0,				\
 }
 
-/* sys_reg_desc initialiser for known cpufeature ID registers */
-#define AA32_ID_SANITISED(name) {		\
+/* sys_reg_desc initialiser for writable ID registers */
+#define ID_WRITABLE(name, mask) {		\
 	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
-	.visibility = aa32_id_visibility,	\
+	.visibility = id_visibility,		\
 	.reset = kvm_read_sanitised_id_reg,	\
-	.val = 0,				\
+	.val = mask,				\
 }
 
-/* sys_reg_desc initialiser for writable ID registers */
-#define ID_WRITABLE(name, mask) {		\
+/*
+ * 32bit ID regs are fully writable when the guest is 32bit
+ * capable. Nothing in the KVM code should rely on 32bit features
+ * anyway, only 64bit, so let the VMM do its worse.
+ */
+#define AA32_ID_WRITABLE(name) {		\
 	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
+	.visibility = aa32_id_visibility,	\
 	.reset = kvm_read_sanitised_id_reg,	\
-	.val = mask,				\
+	.val = GENMASK(31, 0),			\
 }
 
 /*
@@ -2380,40 +2384,39 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
-	AA32_ID_SANITISED(ID_PFR0_EL1),
-	AA32_ID_SANITISED(ID_PFR1_EL1),
+	AA32_ID_WRITABLE(ID_PFR0_EL1),
+	AA32_ID_WRITABLE(ID_PFR1_EL1),
 	{ SYS_DESC(SYS_ID_DFR0_EL1),
 	  .access = access_id_reg,
 	  .get_user = get_id_reg,
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK |
-		 ID_DFR0_EL1_CopDbg_MASK, },
+	  .val = GENMASK(31, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
-	AA32_ID_SANITISED(ID_MMFR0_EL1),
-	AA32_ID_SANITISED(ID_MMFR1_EL1),
-	AA32_ID_SANITISED(ID_MMFR2_EL1),
-	AA32_ID_SANITISED(ID_MMFR3_EL1),
+	AA32_ID_WRITABLE(ID_MMFR0_EL1),
+	AA32_ID_WRITABLE(ID_MMFR1_EL1),
+	AA32_ID_WRITABLE(ID_MMFR2_EL1),
+	AA32_ID_WRITABLE(ID_MMFR3_EL1),
 
 	/* CRm=2 */
-	AA32_ID_SANITISED(ID_ISAR0_EL1),
-	AA32_ID_SANITISED(ID_ISAR1_EL1),
-	AA32_ID_SANITISED(ID_ISAR2_EL1),
-	AA32_ID_SANITISED(ID_ISAR3_EL1),
-	AA32_ID_SANITISED(ID_ISAR4_EL1),
-	AA32_ID_SANITISED(ID_ISAR5_EL1),
-	AA32_ID_SANITISED(ID_MMFR4_EL1),
-	AA32_ID_SANITISED(ID_ISAR6_EL1),
+	AA32_ID_WRITABLE(ID_ISAR0_EL1),
+	AA32_ID_WRITABLE(ID_ISAR1_EL1),
+	AA32_ID_WRITABLE(ID_ISAR2_EL1),
+	AA32_ID_WRITABLE(ID_ISAR3_EL1),
+	AA32_ID_WRITABLE(ID_ISAR4_EL1),
+	AA32_ID_WRITABLE(ID_ISAR5_EL1),
+	AA32_ID_WRITABLE(ID_MMFR4_EL1),
+	AA32_ID_WRITABLE(ID_ISAR6_EL1),
 
 	/* CRm=3 */
-	AA32_ID_SANITISED(MVFR0_EL1),
-	AA32_ID_SANITISED(MVFR1_EL1),
-	AA32_ID_SANITISED(MVFR2_EL1),
+	AA32_ID_WRITABLE(MVFR0_EL1),
+	AA32_ID_WRITABLE(MVFR1_EL1),
+	AA32_ID_WRITABLE(MVFR2_EL1),
 	ID_UNALLOCATED(3,3),
-	AA32_ID_SANITISED(ID_PFR2_EL1),
+	AA32_ID_WRITABLE(ID_PFR2_EL1),
 	ID_HIDDEN(ID_DFR1_EL1),
-	AA32_ID_SANITISED(ID_MMFR5_EL1),
+	AA32_ID_WRITABLE(ID_MMFR5_EL1),
 	ID_UNALLOCATED(3,7),
 
 	/* AArch64 ID registers */
-- 
2.51.0



