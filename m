Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0053D27CB28;
	Tue, 27 May 2025 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367987; cv=none; b=bpiKsC1JjXdc6D3uv1pbjP5hwuAuf3q3luQSh/vpu3a7HPOLSi/pRTlLddXVeU8XOiBl14u4RW3lB2HHkdrqRYZ4uQ2H12j5x5jvnJ3CdyFdIT70NvaAYo/5mR7B3E87nPoDg/lEttf5/QJ9EP63Vs4cnavpG9ggeeDs0lJVhPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367987; c=relaxed/simple;
	bh=trr1pJlhufPOKH9RrNX6ngrvvYI/UGUD7vDxP5EPEag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbhqg7u82N217Ej1aIUqjsYUXGrRA2luY47Q99IqBbc8EkoVlFCfILUgIfN4cWiperC1RAO663JuaUZbXRQmgOJcKACnN6MOiB7mSAS/dJ4OUHxmCOaD9tdwLDWFbEe9SLzt/+y9PVZzvceEpclzUYmQTKeZqcBJ+ZQThGgho4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+WAuwP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+WAuwP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767C8C4CEE9;
	Tue, 27 May 2025 17:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367986;
	bh=trr1pJlhufPOKH9RrNX6ngrvvYI/UGUD7vDxP5EPEag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+WAuwP6CSj3Ol4WiSDSusOA/9/Tncet0qdalvsqrOuWSTkfYoUU911Do2jkoOMXz
	 PTXWjFYc+flqJFgxFI4zryNT9xyRR9pqAhjXOTerkJ1jEYqsWuoI5ccMGyS4r7yUVx
	 lHlMGdLVAJEYQ6NPMwYlcwrfO0a/1xA8Ze1wf1cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 562/783] cpufreq: amd-pstate: Remove unnecessary driver_lock in set_boost
Date: Tue, 27 May 2025 18:25:59 +0200
Message-ID: <20250527162536.031692382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>

[ Upstream commit db1cafc77aaaf871509da06f4a864e9af6d6791f ]

set_boost is a per-policy function call, hence a driver wide lock is
unnecessary. Also this mutex_acquire can collide with the mutex_acquire
from the mode-switch path in status_store(), which can lead to a
deadlock. So, remove it.

Signed-off-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 1b26845703f68..a27749d948b46 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -746,7 +746,6 @@ static int amd_pstate_set_boost(struct cpufreq_policy *policy, int state)
 		pr_err("Boost mode is not supported by this processor or SBIOS\n");
 		return -EOPNOTSUPP;
 	}
-	guard(mutex)(&amd_pstate_driver_lock);
 
 	ret = amd_pstate_cpu_boost_update(policy, state);
 	refresh_frequency_limits(policy);
-- 
2.39.5



