Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F25B254AFF;
	Fri, 21 Nov 2025 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732379; cv=none; b=iRxTNWKgpbSiC1+uq4fxWiQdEVtpUJPg37RpGZpIvJ8SIZfpCAukMIhPuGVpli50xIO5nR/r+mar70qvwhG6pYof5SS+PwtAS8ZmLBRZ03Sc4QssPGJHV4VZBNWeKnt8QgdKMj35btbE/7qE5tCBdG5Ud48Ou0lIhbqA8UQNKSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732379; c=relaxed/simple;
	bh=bMyUjnVD97kkQ8Xtk+BAr/NXc89TTbHIm08GhHkPlDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSGgXzI6Fw3Qd8HTruo82N1e0CD+H1wDopMNDJ+Jyq4HZp34QGiGh5OgW3zweTNyR9Cr1iAmX5y6cKXu4b1kYF7Dy0OxeywyPlZtNOW+dm9qYPtXWapOV/+E23Gm0+qyImnfapws63mnTheiE682Z+XwDbNQHQQg96NBvoa4/ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MErDvG+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MErDvG+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98488C4CEF1;
	Fri, 21 Nov 2025 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732379;
	bh=bMyUjnVD97kkQ8Xtk+BAr/NXc89TTbHIm08GhHkPlDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MErDvG+6rBmhUK5yCiNHZdiAR5Y5dtkm27pKndaARMaeqhiA5PnvM+ZalKHtKAT+h
	 Gd4awYYey22VMMPwaw09rq5GWVqlzJzfCpIs8OcDwmaTyYqu95LcuO5wMYZ3/wAEgg
	 bXSYkIEcP4NAiL9HJYLYc6ilXxifWK1bwGrq3U3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Beier <nanovim@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/529] cpufreq/longhaul: handle NULL policy in longhaul_exit
Date: Fri, 21 Nov 2025 14:06:06 +0100
Message-ID: <20251121130233.411862146@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c57c6725c134..1412d4617a04a 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -953,6 +953,9 @@ static void __exit longhaul_exit(void)
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



