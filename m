Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D7F1AC893;
	Thu, 15 Aug 2024 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732775; cv=none; b=nv/ISySdSjpYh5P3lRmwYSNdxQTBsLN6Ymdk9n6iiDSX7W5sMLYNMbF3v4Cb/FnoB2UAnPfdl/8VRVF8QYk/9azY/q5Qk2/2C0amIGdaJLAuMrx1RKwpGnMyH+6WlWToRfC/Mrzf5SV+XhayXc4KT2aSWjv6BQyUM7OF7c4Cpd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732775; c=relaxed/simple;
	bh=QfWZlf6QQKs8S/5o2SdHb7VzmSz0A3z5pPHPN6tSyA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMwxNKMcpxYd/G/s0nBf5BIRhy1Enj1z2Ogv+xEwjUkEgtc3DayZz5HeVJC+scbf9k248flG6AHm2Ky7bqotGcdV2QgrUyNSU32h8m1x5jVsxgF5qzu2SqbtWSIfNWeFHwZ8RH98EIm5tDgsb5ktMzLMb6cvnKQXuZmH211DDa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQ5CyFoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQ5CyFoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58390C32786;
	Thu, 15 Aug 2024 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732775;
	bh=QfWZlf6QQKs8S/5o2SdHb7VzmSz0A3z5pPHPN6tSyA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQ5CyFoyts02Pw1zNY7AkHInV78YL20Q1OotID7n3QjkHyJa565XqsviTp9pcNdn6
	 Y5AFk2WCtINfUKy8ShzLOoILqQLH1td4HclfwYHOlIQbiaSOC00DYiiSjqJ+Q5Y1Ak
	 9WNXaiQY1/GWQVWBmdzscozts3CCCTLn5Nb7vKBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/352] arm64: cpufeature: Force HWCAP to be based on the sysreg visible to user-space
Date: Thu, 15 Aug 2024 15:25:47 +0200
Message-ID: <20240815131930.313083404@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit 237405ebef580a7352a52129b2465c117145eafa ]

arm64 advertises hardware features to user-space via HWCAPs, and by
emulating access to the CPUs id registers. The cpufeature code has a
sanitised system-wide view of an id register, and a sanitised user-space
view of an id register, where some features use their 'safe' value
instead of the hardware value.

It is currently possible for a HWCAP to be advertised where the user-space
view of the id register does not show the feature as supported.
Erratum workaround need to remove both the HWCAP, and the feature from
the user-space view of the id register. This involves duplicating the
code, and spreading it over cpufeature.c and cpu_errata.c.

Make the HWCAP code use the user-space view of id registers. This ensures
the values never diverge, and allows erratum workaround to remove HWCAP
by modifying the user-space view of the id register.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20220909165938.3931307-2-james.morse@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: fixup lack of 'width' parameter ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 36 +++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 1f0a2deafd643..11a42fcf94bfc 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1196,17 +1196,39 @@ feature_matches(u64 reg, const struct arm64_cpu_capabilities *entry)
 	return val >= entry->min_field_value;
 }
 
-static bool
-has_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
+static u64
+read_scoped_sysreg(const struct arm64_cpu_capabilities *entry, int scope)
 {
-	u64 val;
-
 	WARN_ON(scope == SCOPE_LOCAL_CPU && preemptible());
 	if (scope == SCOPE_SYSTEM)
-		val = read_sanitised_ftr_reg(entry->sys_reg);
+		return read_sanitised_ftr_reg(entry->sys_reg);
 	else
-		val = __read_sysreg_by_encoding(entry->sys_reg);
+		return __read_sysreg_by_encoding(entry->sys_reg);
+}
+
+static bool
+has_user_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	int mask;
+	struct arm64_ftr_reg *regp;
+	u64 val = read_scoped_sysreg(entry, scope);
+
+	regp = get_arm64_ftr_reg(entry->sys_reg);
+	if (!regp)
+		return false;
+
+	mask = cpuid_feature_extract_unsigned_field(regp->user_mask,
+						    entry->field_pos);
+	if (!mask)
+		return false;
+
+	return feature_matches(val, entry);
+}
 
+static bool
+has_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	u64 val = read_scoped_sysreg(entry, scope);
 	return feature_matches(val, entry);
 }
 
@@ -2172,7 +2194,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 };
 
 #define HWCAP_CPUID_MATCH(reg, field, s, min_value)				\
-		.matches = has_cpuid_feature,					\
+		.matches = has_user_cpuid_feature,				\
 		.sys_reg = reg,							\
 		.field_pos = field,						\
 		.sign = s,							\
-- 
2.43.0



