Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6770E335BA9;
	Mon, 18 Aug 2025 13:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525058; cv=none; b=upv35hR5YTtWcbccqXgdyjCIFTd7BttbMQcHkfYzQOjD4mtp5fATZbWjHlBN1A86Ps9eaVpk4etPNLKvjrnHPlqGUObStb0HQ/T8bJ0+RdFtlwFtJQiLbH5VEgrkE+Md6RiqDEnmPS6sx30y2HXYqNZxiGs3UqMdQ6byzlC/wjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525058; c=relaxed/simple;
	bh=gDkQPI+JvC2spzmrXHCrTHVOBBQ3V/wYsm9UA7zBIOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni3/ZkgK9w9y5mBx8eq0sXUhmROpUG9DfE7lhiKmpuvSjyTXC/BToQJdlXR4omgEg7xz1PaNWFg1N38ndhQoS8S8gF/aUqjq2M+9kh7gwHE2SAG8ZtgbTkTuNNdC6tnbXU6/xe8+X2iZcij0i31nltWR9Vq+TFcP+nmgzG/autk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLHmxWkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLHmxWkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8717C4CEF1;
	Mon, 18 Aug 2025 13:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525058;
	bh=gDkQPI+JvC2spzmrXHCrTHVOBBQ3V/wYsm9UA7zBIOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLHmxWkxAys0xvnmS+44dE9vD+L+ig3sbt/dAj7VrlQgG6tSg5nu0ZBWQL0V443Bj
	 jNZ8aOmysRR+745JH2w5Hf4lowigDB+yQF49rSaWe635u6/4+EPwg8Mm1YvMz0Qjzl
	 Xr2arkgBnvzGyqBNXD5bEzk39oZVjwbIjlqcjmNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 146/570] cpufreq: Exit governor when failed to start old governor
Date: Mon, 18 Aug 2025 14:42:13 +0200
Message-ID: <20250818124511.446427460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 0ae204405095abfbc2d694ee0fbb49bcbbe55c57 ]

Detect the result of starting old governor in cpufreq_set_policy(). If it
fails, exit the governor and clear policy->governor.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-5-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c1c6f11ac551..628f5b633b61 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2716,10 +2716,12 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	pr_debug("starting governor %s failed\n", policy->governor->name);
 	if (old_gov) {
 		policy->governor = old_gov;
-		if (cpufreq_init_governor(policy))
+		if (cpufreq_init_governor(policy)) {
 			policy->governor = NULL;
-		else
-			cpufreq_start_governor(policy);
+		} else if (cpufreq_start_governor(policy)) {
+			cpufreq_exit_governor(policy);
+			policy->governor = NULL;
+		}
 	}
 
 	return ret;
-- 
2.39.5



