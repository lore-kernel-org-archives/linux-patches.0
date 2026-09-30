Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A060C4F4049;
	Wed, 30 Sep 2026 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787648; cv=none; b=Fg1OQJY7fR8rqGjzjH+pyTYask8a+9e1UwboGR0WKPfE05o5l5wiMTVQwfCf1I8y5DgextyaaXrXZmZXDXDTiBogiZJvpgZWTpjU8Aev9nWEjCyGCfckE99bKnmBn0CVD7RKIDSeQEB2y4X6sfT9HPvs7I75hfQzrWH/AG0rE5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787648; c=relaxed/simple;
	bh=7H1V0FbYx7MU49Xjg5PJSluN4sOD9UUw1Nw4o9XhBQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSp/ye0m0JVs5bUAa2lo4F6G+8ICr2BV5HhqxaEPJ4YbjFVRt221wxq1BuJ8dqFCReantZ4xWWF/6wfwW7dCENcvfyFo8FT2zawWU9iBOKN5zG81aJzBAnf7YB/XuB14V8Wauk6rafi0bPTEbr3v8HDEQU20rrovWudMXaN48Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEEDdPLs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEEDdPLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085481F000FF;
	Wed, 30 Sep 2026 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787647;
	bh=eh5R8My5nQrig2xhQL5v4pBbPVgKFmhfpU1SM5QD4G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEEDdPLs/ayGTyeGuJKL5eojSaDRRp1WL+gZ/OLsZc7YrApr60+rzEBi14EGGy7f5
	 Uu8tPX/f1myYiwZbFaWjkaqqj1AfIW7BYvL7gkxQ9Mjs+zUos4suMTotoGT0GUi9dH
	 AQJ5reYRBqhGfhndQFeTBlbB+S0/fZsnxYIAM9sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 249/457] arm64: errata: match the target implementation CPUs own MIDR
Date: Wed, 30 Sep 2026 17:25:54 +0200
Message-ID: <20260930152351.422279575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit b7403afb7a5f85073243df10238b3483958ad69e upstream.

__is_affected_midr_range() is handed the MIDR and REVIDR of one target
implementation CPU, but tests the erratum's range with is_midr_in_range(),
which re-scans all of target_impl_cpus[] and ignores the @midr argument.
The range test is thus constant across the per-CPU loop in
is_affected_midr_range() and only answers "is any target CPU in range".

Since just the fixed_revs REVIDR check uses the iteration's own registers,
an out-of-range target CPU can decide whether a MIDR_FIXED() exemption
applies. A VM then enables a workaround whose only in-range CPU is fixed
silicon, e.g. erratum 2658417 on a Cortex-A510 r1p1 with REVIDR_EL1[25]
set.

Factor the range test into __is_midr_in_range(), which takes an explicit
MIDR, and use it in __is_affected_midr_range().

Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -28,18 +28,21 @@ bool cpu_errata_set_target_impl(u64 num,
 	return true;
 }
 
+static inline bool __is_midr_in_range(u32 midr, struct midr_range const *range)
+{
+	return midr_is_cpu_model_range(midr, range->model,
+				       range->rv_min, range->rv_max);
+}
+
 static inline bool is_midr_in_range(struct midr_range const *range)
 {
 	int i;
 
 	if (!target_impl_cpu_num)
-		return midr_is_cpu_model_range(read_cpuid_id(), range->model,
-					       range->rv_min, range->rv_max);
+		return __is_midr_in_range(read_cpuid_id(), range);
 
 	for (i = 0; i < target_impl_cpu_num; i++) {
-		if (midr_is_cpu_model_range(target_impl_cpus[i].midr,
-					    range->model,
-					    range->rv_min, range->rv_max))
+		if (__is_midr_in_range(target_impl_cpus[i].midr, range))
 			return true;
 	}
 	return false;
@@ -59,7 +62,7 @@ __is_affected_midr_range(const struct ar
 			 u32 midr, u32 revidr)
 {
 	const struct arm64_midr_revidr *fix;
-	if (!is_midr_in_range(&entry->midr_range))
+	if (!__is_midr_in_range(midr, &entry->midr_range))
 		return false;
 
 	midr &= MIDR_REVISION_MASK | MIDR_VARIANT_MASK;


