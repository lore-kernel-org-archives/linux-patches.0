Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD13218EB1;
	Mon, 27 Oct 2025 18:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590364; cv=none; b=CqxASKIYHecrEs+q8rtVwgQoPecAMBwKRofyb/RCFq3xL0XsdWwkZXpHcOc25JfnDG+ovFZw1LLMe2UAscNR6AvXCZanIonNF4B2YsujeYGHi7zF6h2WzkKEAdT8Ez5HipVqgE1nLQM4+XLRPvfUy6ZsuryofasbWwp4xQ+cBQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590364; c=relaxed/simple;
	bh=5hwQQJ20oYszOFB+gJWk10vzl2YcFldq1JR4QPk4Zxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7j/p77zcQCZOVjjwjib3hIe/d3T3B+o4bBv0QuCkK3v/a17+Z7W3BzkfGlje12XEJ2Wr3OfgrMHKacFwYOYUPn4vYLVOBV0iz6QQVedx0iXrx4DyNk1CptWdOD2b1OxXJBDQQmP9hetu0cgMCiIIUuv5aJyMGh1dRjOb2qc3Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+oF7ohn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+oF7ohn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E16C4CEF1;
	Mon, 27 Oct 2025 18:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590364;
	bh=5hwQQJ20oYszOFB+gJWk10vzl2YcFldq1JR4QPk4Zxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+oF7ohnrIp7y5vARgXkdIKlyqTOFwvoUtgsBvnBEqGp6WootcLrfPmKPvPCd+Ahg
	 PEXvkugIXY5+Wqdeapd77q2Oh+xC5U37rFzR/Vc4hhTcpgL/WFkzZ/nUpWxkIe6TMb
	 a6TlTuQyT49Gqpk4BGO0xwgLLWVr1NGoa0ISXyVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/224] perf: arm_spe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 27 Oct 2025 19:32:44 +0100
Message-ID: <20251027183509.483678767@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit a29fea30dd93da16652930162b177941abd8c75e ]

Cast nr_pages to unsigned long to avoid overflow when handling large
AUX buffer sizes (>= 2 GiB).

Fixes: d5d9696b0380 ("drivers/perf: Add support for ARMv8.2 Statistical Profiling Extension")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_spe_pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 079701e8de186..91a6631af5567 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -75,7 +75,8 @@ struct arm_spe_pmu {
 #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
 
 /* Convert a free-running index from perf into an SPE buffer offset */
-#define PERF_IDX2OFF(idx, buf)	((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /* Keep track of our dynamic hotplug state */
 static enum cpuhp_state arm_spe_pmu_online;
-- 
2.51.0



