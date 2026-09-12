Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4C6384242;
	Sat, 12 Sep 2026 18:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238490; cv=none; b=u8+6lLVVjHmE7lvJ67Wz8WlIhEJTn4YP3Zh4k4QBdcIbMRwF2prTI+Iczw53ZGMI5Xm+5tGDG4MBCTLMNbQP8A0UcBqfgkkUs7Bm0xYvs1VQzWdl9roFHGQwloygVusjGCG82OAFCOwB6/0X29rOxyUc9giIm9GQFYzSLMzmmpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238490; c=relaxed/simple;
	bh=CFTVERL7hXk9nEWsplsvvQp22qGqJ8osIh9dn0pQGa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBrLkQC3cPUnlU+isfKnDcS2+O4lBX62y4m7/zWuFLuuO63Tz16u45xUILihx0sJWBxPJpp76x5vID6CqQSPva1ovEolM59xcARwmEKk0Cw1S/ZQiH9G4cvoHgwCRPPND5f6rxj9xy90H8HqnQbM8D4BMF65PG7M3XgPxXsYPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GzxA5kM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GzxA5kM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01731F000FF;
	Sat, 12 Sep 2026 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238488;
	bh=iLM4QJ6ikURUxJjDFLngGY11mfaL2LpU83IHN5eNuH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GzxA5kMhwvK4i0tXbiUoCcw4IgFEE5+HKqL9W6fuqPFfCD+G1pkJpqb7HtLxH8W+
	 B1YvWsnF3oJF/QyKguqi735hqrzILZXa5XTs1gPxEVFDQr+30lyIxqNPgVG9WAryYx
	 Yosa0SRe+mmRaCv4Oibx3K27QgMhO0WeRg29itac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 472/935] clk: qcom: gdsc: Release pm subdomains in reverse add order
Date: Sat, 12 Sep 2026 08:58:22 +0200
Message-ID: <20260912065537.653406039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 0e6dfde439df0bb977cddd3cf7fff150a084a9bf ]

gdsc_unregister() should release subdomains in the reverse order to the
order in which those subdomains were added.

I've made this patch a standalone patch because it facilitates a subsequent
fix to stable.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250117-b4-linux-next-24-11-18-clock-multiple-power-domains-v10-1-13f2bb656dad@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 86b23609d5e1 ("clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 6db451fb77974..ab1b42dd7ee0a 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -539,7 +539,7 @@ void gdsc_unregister(struct gdsc_desc *desc)
 	size_t num = desc->num;
 
 	/* Remove subdomains */
-	for (i = 0; i < num; i++) {
+	for (i = num - 1; i >= 0; i--) {
 		if (!scs[i])
 			continue;
 		if (scs[i]->parent)
-- 
2.53.0



