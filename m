Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3913603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300952; cv=none; b=PLMbN+GdPqzGJI4xtpXMYnWjpnVD2rM9rWKTr1ferOFQUM1E+LiLyYiN8ku+kN4beqxLTUooFdVRPQASsfQFdIa5pBeWIH9G9dYnKOrM2VmXzzpH91WWUlDiShPQifi1kwS26W9GJsMdvaK0YZP9dyA4V0kOheleJGOMbFqnGG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300952; c=relaxed/simple;
	bh=9FrqV9LZier/MYpMtH3dloyL7RxdLrUNwdItJ7ttS7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7dN5KXFVjAaK8E+DnfUw7Zxsv3rs7Y6CT4gWeNukH0VToQLHQzeMKT+/hKUejxCUDVmi9Byzxb4kPidWhppanQ6t0QLSTgbDAVtptQLLs0DJSHE1JVnUOcBRhEkQYKb9A6bK+gG7eNai4ma9i/uJOAjWXCtvlTR0KV1zkatoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9rZoNXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9rZoNXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CC6C19423;
	Sat, 28 Feb 2026 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300952;
	bh=9FrqV9LZier/MYpMtH3dloyL7RxdLrUNwdItJ7ttS7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9rZoNXFZvdrorK7N/aHaYCKQ8U/M2RT2/MsoKq9N/Q4fq3koJFbQwo1zgld3V0SG
	 B50Ik5oe5g6LOp+xQ4kQt9Hzus0x/cwQSHFwQedj6h8KWVeYeoL9QkmG4uif8olJz8
	 yi82fFEd3FBuDjbrwW3pEI0FGRJygNUcDjGBmU7390q4jJ6aWcB0AQRRleAhrjDkLA
	 NNQuiN8EI9FfJdldX6klZtJQkZ+1fwqyjLlEZofQmQo75qJumlAoCfOV7E0thrCRcU
	 PPsE5nLU+MxqutIdTNEYtR9b0TIMYVs+vdOGYobg37CLi41AtRMaMLG3eQqbCpR7PL
	 IgbW0j4A4UDaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Cupertino Miranda <cupertino.miranda@oracle.com>,
	Andrew Pinski <andrew.pinski@oss.qualcomm.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	David Faust <david.faust@oracle.com>,
	Jose Marchesi <jose.marchesi@oracle.com>,
	Elena Zannoni <elena.zannoni@oracle.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/752] bpf: verifier improvement in 32bit shift sign extension pattern
Date: Sat, 28 Feb 2026 12:36:26 -0500
Message-ID: <20260228174750.1542406-75-sashal@kernel.org>
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

From: Cupertino Miranda <cupertino.miranda@oracle.com>

[ Upstream commit d18dec4b8990048ce75f0ece32bb96b3fbd3f422 ]

This patch improves the verifier to correctly compute bounds for
sign extension compiler pattern composed of left shift by 32bits
followed by a sign right shift by 32bits.  Pattern in the verifier was
limitted to positive value bounds and would reset bound computation for
negative values.  New code allows both positive and negative values for
sign extension without compromising bound computation and verifier to
pass.

This change is required by GCC which generate such pattern, and was
detected in the context of systemd, as described in the following GCC
bugzilla: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=119731

Three new tests were added in verifier_subreg.c.

Signed-off-by: Cupertino Miranda  <cupertino.miranda@oracle.com>
Signed-off-by: Andrew Pinski  <andrew.pinski@oss.qualcomm.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Cc: David Faust  <david.faust@oracle.com>
Cc: Jose Marchesi  <jose.marchesi@oracle.com>
Cc: Elena Zannoni  <elena.zannoni@oracle.com>
Link: https://lore.kernel.org/r/20251202180220.11128-2-cupertino.miranda@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c4fa2268dbbc5..f7ca88fe20e75 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15224,21 +15224,17 @@ static void __scalar64_min_max_lsh(struct bpf_reg_state *dst_reg,
 				   u64 umin_val, u64 umax_val)
 {
 	/* Special case <<32 because it is a common compiler pattern to sign
-	 * extend subreg by doing <<32 s>>32. In this case if 32bit bounds are
-	 * positive we know this shift will also be positive so we can track
-	 * bounds correctly. Otherwise we lose all sign bit information except
-	 * what we can pick up from var_off. Perhaps we can generalize this
-	 * later to shifts of any length.
+	 * extend subreg by doing <<32 s>>32. smin/smax assignments are correct
+	 * because s32 bounds don't flip sign when shifting to the left by
+	 * 32bits.
 	 */
-	if (umin_val == 32 && umax_val == 32 && dst_reg->s32_max_value >= 0)
+	if (umin_val == 32 && umax_val == 32) {
 		dst_reg->smax_value = (s64)dst_reg->s32_max_value << 32;
-	else
-		dst_reg->smax_value = S64_MAX;
-
-	if (umin_val == 32 && umax_val == 32 && dst_reg->s32_min_value >= 0)
 		dst_reg->smin_value = (s64)dst_reg->s32_min_value << 32;
-	else
+	} else {
+		dst_reg->smax_value = S64_MAX;
 		dst_reg->smin_value = S64_MIN;
+	}
 
 	/* If we might shift our top bit out, then we know nothing */
 	if (dst_reg->umax_value > 1ULL << (63 - umax_val)) {
-- 
2.51.0

