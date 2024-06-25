Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDC213C90B;
	Tue, 25 Jun 2024 09:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308353; cv=none; b=N4xj0UUJ7gAu8ry2JcZBTOihQl8M3oqA/fNv8GGDLICE9wQabXEOzTw6ZQPCsPnnJTQS5EhQyMKT5P4PQdY2PVSRGLt5mVcJkls4tvkV6bdtvmo7XvzGsLcrRmZ02i4qlGFdwWsIwiU4eYN3F7yjyfwUkw2Q40o+s5UAr+xRGKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308353; c=relaxed/simple;
	bh=HFjcG4brG0TyTMvfJFyHZZKKlaABJ/sEDUpGFgzmfTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlTAVjYOxEYi9tVl2Jn1LeIax5Ss3zK5FRkqwQP2e4YBPD/g/yiOg/3fWCg0SnFaI8P3iBWtaRs1SvJcN932nZIIPMNQBPTrvBYp7Dra5RtVdYVTC5wJVHRG7CNmjX9aL2YFyhK83EkqAKOX1NT2Ilp9Sma1m4KHVObmFrlda6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZeKC3e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZeKC3e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B045C32781;
	Tue, 25 Jun 2024 09:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308353;
	bh=HFjcG4brG0TyTMvfJFyHZZKKlaABJ/sEDUpGFgzmfTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZeKC3e+RaMmHEqZeOqC2rVnIv0PiJgZn5qoJi1BOVOUeRnYgAYZ1TtDuGCh8Kp+O
	 rTk+aXlsgoRGjhvApRXFKJFkvr+xDsS0XFDO0XUKjFi7f1xAEfExH03PvCoyhEAZa4
	 N/jbU/odzijre2CXN8EpL7RP3TsS7/ykjRS5FfZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Ma <andypma@tencent.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <Perry.Yuan@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 091/250] cpufreq: amd-pstate: fix memory leak on CPU EPP exit
Date: Tue, 25 Jun 2024 11:30:49 +0200
Message-ID: <20240625085551.562332941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Ma <andypma@tencent.com>

[ Upstream commit cea04f3d9aeebda9d9c063c0dfa71e739c322c81 ]

The cpudata memory from kzalloc() in amd_pstate_epp_cpu_init() is
not freed in the analogous exit function, so fix that.

Signed-off-by: Peng Ma <andypma@tencent.com>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Perry Yuan <Perry.Yuan@amd.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 6c989d859b396..6af175e6c08ac 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1462,6 +1462,13 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 
 static int amd_pstate_epp_cpu_exit(struct cpufreq_policy *policy)
 {
+	struct amd_cpudata *cpudata = policy->driver_data;
+
+	if (cpudata) {
+		kfree(cpudata);
+		policy->driver_data = NULL;
+	}
+
 	pr_debug("CPU %d exiting\n", policy->cpu);
 	return 0;
 }
-- 
2.43.0



