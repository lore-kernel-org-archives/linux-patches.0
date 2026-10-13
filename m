Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3710123E33D;
	Tue, 13 Oct 2026 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895464; cv=none; b=odB5kPTsPTobbDi1LNeWrUhgMMqFTbv8uhvdMm0JqUyVdKYIFSj9RGnXl9x/wOhAPe34OcV17a350l6wlQ0uItEZuiZVaay3aRon6sN+uf2jY3vXBKuPduKf5ls99FBOzL8pLvdj+5iwUkRg4XDGEB10P5TzirnmPQUYgpYiWBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895464; c=relaxed/simple;
	bh=JwLKeyrDQWWaIouZhcpnOkV63NeD106oUeL4Kp5MwzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYdxdVMiN0R9o9o+GcB1lafd0OKe3rpaFHTeSadymjwna2cjVZSZD7fLEt1pmMR+goopF6paBWPCBfJUfQEaybq7Fvq/cJ2dJnQDq6IXIS4nG8zGqqZuxF7njmc0fn96orqKNhIMI4ydyT0jjGD7kyiMwYsFRXgcMpfwQ7pn7eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lf28/jsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lf28/jsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CA61F00898;
	Tue, 13 Oct 2026 12:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895462;
	bh=aGBEWstA6p/WrvKysEMTTqjkxk9zIbdmFqmBLlNDeEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lf28/jsRlxtcc3+GjjTIKE2ojkT8Cu3Kv1Y/icbs2Pj13esEQ2QZpT3uFa/UByqX/
	 493mSQu4EpMjnvVu3gb0ZIg/FhDpxO0/33pYttgN9RluMzInwW1YhUHHRie7+Uo1Fs
	 DS9zQ5OeeaXgsucDxnQEDdx5mMz2uf+dBgzV048M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/497] arm64/fpsimd: signal: Mandate SVE payload for streaming-mode state
Date: Tue, 13 Oct 2026 13:37:31 +0200
Message-ID: <20261013112914.635129133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit b465ace42620970e840c7aeb2c44a6e3b1002fec ]

Non-streaming SVE state may be preserved without an SVE payload, in
which case the SVE context only has a header with VL==0, and all state
can be restored from the FPSIMD context. Streaming SVE state is always
preserved with an SVE payload, where the SVE context header has VL!=0,
and the SVE_SIG_FLAG_SM flag is set.

The kernel never preserves an SVE context where SVE_SIG_FLAG_SM is set
without an SVE payload. However, restore_sve_fpsimd_context() doesn't
forbid restoring such a context, and will handle this case by clearing
PSTATE.SM and restoring the FPSIMD context into non-streaming mode,
which isn't consistent with the SVE_SIG_FLAG_SM flag.

Forbid this case, and mandate an SVE payload when the SVE_SIG_FLAG_SM
flag is set. This avoids an awkward ABI quirk and reduces the risk that
later rework to this code permits configuring a task with PSTATE.SM==1
and fp_type==FP_STATE_FPSIMD.

I've marked this as a fix given that we never intended to support this
case, and we don't want anyone to start relying upon the old behaviour
once we re-enable SME.

Fixes: 85ed24dad290 ("arm64/sme: Implement streaming SVE signal handling")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250508132644.1395904-4-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/signal.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 6a5d83d9179da..fc817154e8990 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -392,6 +392,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	unsigned int vl, vq;
 	struct user_fpsimd_state fpsimd;
 	u16 user_vl, flags;
+	bool sm;
 
 	if (user->sve_size < sizeof(*user->sve))
 		return -EINVAL;
@@ -401,7 +402,8 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	if (err)
 		return err;
 
-	if (flags & SVE_SIG_FLAG_SM) {
+	sm = flags & SVE_SIG_FLAG_SM;
+	if (sm) {
 		if (!system_supports_sme())
 			return -EINVAL;
 
@@ -421,7 +423,16 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	if (user_vl != vl)
 		return -EINVAL;
 
-	if (user->sve_size == sizeof(*user->sve)) {
+	/*
+	 * Non-streaming SVE state may be preserved without an SVE payload, in
+	 * which case the SVE context only has a header with VL==0, and all
+	 * state can be restored from the FPSIMD context.
+	 *
+	 * Streaming SVE state is always preserved with an SVE payload. For
+	 * consistency and robustness, reject restoring streaming SVE state
+	 * without an SVE payload.
+	 */
+	if (!sm && user->sve_size == sizeof(*user->sve)) {
 		clear_thread_flag(TIF_SVE);
 		current->thread.svcr &= ~SVCR_SM_MASK;
 		current->thread.fp_type = FP_STATE_FPSIMD;
-- 
2.53.0



