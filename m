Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725D62DCF41;
	Mon,  1 Dec 2025 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588392; cv=none; b=TY1t1LdHWhOl8ongRt0lNPiXca4NDj9urcEJJ9oXcA7xmuQ0OYDCk8Or+/5IVtrm9HkR4r1C2HmFoU9Jhh6EUV0F32tTlTJ9Oe9oeGghvXAnDYFv6cMQ8PtOMn+RqNGSpB2WjbfehWoykY9gXhYnVVlSUn9ndjKHe1jlp0t8PgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588392; c=relaxed/simple;
	bh=nVLvfcPtCEtdoE3o/Y15XGe7QY07jmyY4YNc4rWZpeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGvddjlRestjeHH8ugMcnuselL0Q1nlC3Pw06LKHGp1i6vFtj18sUL8sy5ZXgBDyu2PgjcHTe8pFm4h91zA5IYusZ4rFokd50ta7vzAlozjvW0gRfNKtBEJj6Scn+82JZPJ9XQ1lYsBUnTYX6waJEtf3ueS2uBaKCFmcFH3zK2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1yC6jnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1yC6jnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9106C4CEF1;
	Mon,  1 Dec 2025 11:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588392;
	bh=nVLvfcPtCEtdoE3o/Y15XGe7QY07jmyY4YNc4rWZpeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1yC6jnBhzPYLL3YL5jqe2QVosIfIWnLMSdxB2G+fo8WcPX210Oat92Dhj8lrCT9k
	 p9/tZLMoI7ubFLtBYnGOFexiS2QvwJFG50h255y+N9MUDYmOixNtBa6P+urDyS6YoR
	 vBWBVNAHTlaTvdoBWavym1tYjCMEgANkjHwL98ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Beier <nanovim@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/187] cpufreq/longhaul: handle NULL policy in longhaul_exit
Date: Mon,  1 Dec 2025 12:22:20 +0100
Message-ID: <20251201112242.413142619@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

From: Dennis Beier <nanovim@gmail.com>

[ Upstream commit 592532a77b736b5153e0c2e4c74aa50af0a352ab ]

longhaul_exit() was calling cpufreq_cpu_get(0) without checking
for a NULL policy pointer. On some systems, this could lead to a
NULL dereference and a kernel warning or panic.

This patch adds a check using unlikely() and returns early if the
policy is NULL.

Bugzilla: #219962

Signed-off-by: Dennis Beier <nanovim@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/longhaul.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 92d92e67ae0a1..a9887011f1fa1 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -956,6 +956,9 @@ static void __exit longhaul_exit(void)
 	struct cpufreq_policy *policy = cpufreq_cpu_get(0);
 	int i;
 
+	if (unlikely(!policy))
+		return;
+
 	for (i = 0; i < numscales; i++) {
 		if (mults[i] == maxmult) {
 			struct cpufreq_freqs freqs;
-- 
2.51.0



