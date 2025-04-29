Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A5244679;
	Tue, 29 Apr 2025 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945167; cv=none; b=N2TlN7CLr+h1x8TuLqt5KU83U1m7HFEk5YoKMCX6FfxHgM4U9LJjQfW0W88t0T0UYVwlRC7CZgEP8P2wH50aWnexlVgNeUgDs+5Xynk72EnU4Smcj8/45S2805QPRTBd+GS6bX5VFRLpkdaokjC1F5RXyC39LAONhgyUNwiVkzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945167; c=relaxed/simple;
	bh=ToSindjh371pNdM8VUC/yxebkY8YHvpLoV8jQX8QgOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+s2SdiRIzVqoDD/l/UE4Y4I4gBwxppgK3EZVjpz3UaGRs5Rg5LVEXebtR65XE6x6xP7JyovukIQValZvr9s8XPugZboKkTimhw5FfPa6eQAe5mGBazorSsBbxjdHNdRnIpnQTz+y+1f2B8xC2MbF8kX9IWC3pj5Kv3qcUS1Jfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzvSTXoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzvSTXoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B2DC4CEE3;
	Tue, 29 Apr 2025 16:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945167;
	bh=ToSindjh371pNdM8VUC/yxebkY8YHvpLoV8jQX8QgOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzvSTXoJ/4vqTkLnxnLKHyJJFHhJEnNQ3NdCuntIXddwyNuRvE7xqwlN2b61a4acN
	 PKWGKy6txBJKu4mhc4LW9lljdTpGJRTb1Vc6lcYNiFQi6CX6/JZZmvCdDnX6zdOvW8
	 0wP9duplD5DwtYcf50sRhoRLG67cS4wbDJ0CaOyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/179] pm: cpupower: bench: Prevent NULL dereference on malloc failure
Date: Tue, 29 Apr 2025 18:39:08 +0200
Message-ID: <20250429161049.689942542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 208baa3ec9043a664d9acfb8174b332e6b17fb69 ]

If malloc returns NULL due to low memory, 'config' pointer can be NULL.
Add a check to prevent NULL dereference.

Link: https://lore.kernel.org/r/20250219122715.3892223-1-quic_zhonhan@quicinc.com
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/bench/parse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/power/cpupower/bench/parse.c b/tools/power/cpupower/bench/parse.c
index e63dc11fa3a53..48e25be6e1635 100644
--- a/tools/power/cpupower/bench/parse.c
+++ b/tools/power/cpupower/bench/parse.c
@@ -120,6 +120,10 @@ FILE *prepare_output(const char *dirname)
 struct config *prepare_default_config()
 {
 	struct config *config = malloc(sizeof(struct config));
+	if (!config) {
+		perror("malloc");
+		return NULL;
+	}
 
 	dprintf("loading defaults\n");
 
-- 
2.39.5



