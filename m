Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9F51C6FE1;
	Tue, 11 Nov 2025 00:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822774; cv=none; b=lAA2vG/7PimZ0dpIGNhXWK96bHnRIG0Ly/oafriz8H6ZpPp8sUbMllcYHE67sRLhTlo4bj3CsoJP5/bjKnqrTVSnDUwa1Ob7LN5tJ+WOi59vrYKOAUxYkfbRBbkKSPpCOjnYVnj/IxmEUfuc8GRSJuV2aBCCN5Q9vw8BFpcrlvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822774; c=relaxed/simple;
	bh=Vbs8Yir4WWl50cVgp7l9sKLQMitJIywHDA84cA3vS9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T653z8xzJIK/sdmbQALwy+oAKP7w1Sy7FS/T71n+0SBIQPiij6GJGlMZ1/i2LWLY6VwyQDd0fDsqdhkXZpMWXFSzpLhkro3hFkhwcKlE5KbI/u7rY2q/okFBqtz2sP9jPD9ZTHzSWyi4X7L2vCZH6646f5hY4yO1xUIKaGSpzN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1IIA3Pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1IIA3Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AEDC4CEFB;
	Tue, 11 Nov 2025 00:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822774;
	bh=Vbs8Yir4WWl50cVgp7l9sKLQMitJIywHDA84cA3vS9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1IIA3Pv0ap5oR8I8C9RWGPIKKs86zn3AxyoC96lZ7CAxbF1xJQE0Wy7gP3t6Nwz+
	 9dZX2kLF/0Hvv+8iPIG+4Jr9EeULi0m9NAwmV29yrSC7h26cYtbIfVwGSzwpfMUxsx
	 oJ1QUcp/aIqHDcumnU93aIFRhe9uAW+6YwFh0crE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Beier <nanovim@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/565] cpufreq/longhaul: handle NULL policy in longhaul_exit
Date: Tue, 11 Nov 2025 09:39:22 +0900
Message-ID: <20251111004529.340129743@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index bd6fe8638d399..02767c1f9edef 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -954,6 +954,9 @@ static void __exit longhaul_exit(void)
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



