Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F84530C348;
	Wed,  3 Dec 2025 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775989; cv=none; b=ngc75KcRT1CfILEburlmGsYAuJXZ5QuZyBCAUpmNvtiZb6tWisbIxF4ZlrT8YUkP8FZhGLFoMkGuOwNkIcNmiFUjemFo8OCjQQRK+LcC0Rl7m/BXdR7fGuBmYW7gZkf2ak9HUHx8r0OLiMqDRWmvVt15q1MIJTc2X1lLqKb6mwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775989; c=relaxed/simple;
	bh=hFWfRGNQ3O9zi9hsawHCHFdq+hC+zAKM4h7TqYbySeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWe12hI71YYXFJ8yEfTEJYoUyARZza5HQYth4TqmkrfdRK/wEmgDT/NHQdOyy7IVe8xBqD0yaWVwLhHMj9wVZ5+Qi58C1dRn4EmP5ME15wp9QSD40JPcow85zzL+u3Mem1+QLJB8mlHtVhTC/yz5BG/X2TGGhiL0OeGBDtwRmoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jARclX4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jARclX4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8F8C4CEF5;
	Wed,  3 Dec 2025 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775988;
	bh=hFWfRGNQ3O9zi9hsawHCHFdq+hC+zAKM4h7TqYbySeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jARclX4QDhXlcC3ckTT9XQKHYVhpgEalOGqRIvlxGuaPclGe9IBDGO8yi+ycoTYDm
	 u+Pg88YFbSjf5xB1xiL81vPiZyYAo5E6jLFe7MqTSa59PIALcG6pchJ+Te35uXF+2r
	 tVsP5ghr/G+mD5AaPlmKmvA7ohESVF8mH57zhotQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Beier <nanovim@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/300] cpufreq/longhaul: handle NULL policy in longhaul_exit
Date: Wed,  3 Dec 2025 16:24:11 +0100
Message-ID: <20251203152402.358160804@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 182a4dbca0952..7197b0daabea2 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -955,6 +955,9 @@ static void __exit longhaul_exit(void)
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



