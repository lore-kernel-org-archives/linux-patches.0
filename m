Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4714C34166C;
	Tue, 26 Aug 2025 14:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217298; cv=none; b=Q3k6H6hWge96dKyw+yRpgJvOMQBGe6RfbJ1vAawWMJmkSiFVnTsSGx6wgRL0Z7Xz58i8B59zoLY/c6RLkZ9hqSIh68M/0c/SBLoxbdm78oIavkzSM+v9A61Ekbr1nzmEqEMnmDURcPNpt4PtS/AEVyKvyfo0VeYE7vaGzNodRmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217298; c=relaxed/simple;
	bh=wvcrVePOSppCJY5fVFHHEvd/fAcCn9VNwSxCWlyS9aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=splHctimAYfh5Qwfzrn7/NnR4XMnZ0d4oLH0LZjexXYwUJaODC7K1xoy3ogjj23d8jyEfF/uiDsX85rJW6JCR1KwzeEhDLXqHJDXe7y07dAwsHRLITDYW3qv0UE0k6NTzfk46JecwGJZAlkBxNFK9eUJ2dRnV9RM7KfgWnyRiiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VLpiuEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VLpiuEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC401C4CEF1;
	Tue, 26 Aug 2025 14:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217298;
	bh=wvcrVePOSppCJY5fVFHHEvd/fAcCn9VNwSxCWlyS9aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VLpiuEszP4gIlx8bSFgbyKAEOvtan/drFPuhHMoka44EVAS1axSySWRBb2TxvFIS
	 JvyUoZTtfjyPjWXMPX2TC8558fyUH9/ClTBUkNgQunkhJoyk4/vVXCSW9SN5UJWj7v
	 lgt41Jp5aD/wZo9+OfgFPUNFJ6jR4oWbEp9EDHHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/523] cpufreq: Init policy->rwsem before it may be possibly used
Date: Tue, 26 Aug 2025 13:05:00 +0200
Message-ID: <20250826110926.771602940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit d1378d1d7edb3a4c4935a44fe834ae135be03564 ]

In cpufreq_policy_put_kobj(), policy->rwsem is used. But in
cpufreq_policy_alloc(), if freq_qos_add_notifier() returns an error, error
path via err_kobj_remove or err_min_qos_notifier will be reached and
cpufreq_policy_put_kobj() will be called before policy->rwsem is
initialized. Thus, the calling of init_rwsem() should be moved to where
before these two error paths can be reached.

Fixes: 67d874c3b2c6 ("cpufreq: Register notifiers with the PM QoS framework")
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-3-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6e03526ee759..d1277f98d1fd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1227,6 +1227,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 		goto err_free_real_cpus;
 	}
 
+	init_rwsem(&policy->rwsem);
+
 	freq_constraints_init(&policy->constraints);
 
 	policy->nb_min.notifier_call = cpufreq_notifier_min;
@@ -1249,7 +1251,6 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 	}
 
 	INIT_LIST_HEAD(&policy->policy_list);
-	init_rwsem(&policy->rwsem);
 	spin_lock_init(&policy->transition_lock);
 	init_waitqueue_head(&policy->transition_wait);
 	INIT_WORK(&policy->update, handle_update);
-- 
2.39.5



