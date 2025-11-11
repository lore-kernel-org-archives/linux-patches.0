Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F274C97;
	Tue, 11 Nov 2025 00:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822580; cv=none; b=NBP1vJTFU3eZR2SKgFkMIawLr0wNgIka4zSlRiHv9PqKXXkGNpY3lsPibf3LGSdrcml5eG4L9EBSuA/WPr7ikmXdgJWcyHei0CkPbjTTaEINFtOYwzZLFlD4kuSPnHJd3KRGG7DSugId03pP8hlM6ihCTMkh1IRQK2flLHuyXrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822580; c=relaxed/simple;
	bh=cq7Q5voK4QWkc4tE7ECvGl1qMcL5KaSMGSIZcMpjiIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNw4843HZ4mWZGabNvA/q0g2iChROdnIDoOnTo+7qsRIxxXoEVgtpYxfdyIfjNrx6U8bVSk17J+yFYrA76mUE5uG0CzKbot65uc3JZP0idI79r85TC8txm+tdbqlumezTE1GoGetxCKjBQQ5SRz2lsmc4It2efvd1fpPQNSasNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2zn9GN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2zn9GN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F5FC113D0;
	Tue, 11 Nov 2025 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822580;
	bh=cq7Q5voK4QWkc4tE7ECvGl1qMcL5KaSMGSIZcMpjiIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2zn9GN/I6fIJqX86j5Tlv8xsUwkGWa4bAPcZj2cpmTD46+FJHsWdXENEzxhpmpcY
	 msjpfBTbCFhDIBWGBy9o3hxIcY0pYikbmPREekEZ/ucgWkmM8YQexmnOcsEZyWCffl
	 SnfPdsiyFgsrFCKkn2lScIGLYnEg4g/MHVGeh52U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Beier <nanovim@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 141/849] cpufreq/longhaul: handle NULL policy in longhaul_exit
Date: Tue, 11 Nov 2025 09:35:11 +0900
Message-ID: <20251111004539.807184926@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index ba0e08c8486a6..49e76b44468aa 100644
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



