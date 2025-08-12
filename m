Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88949268C73;
	Tue, 12 Aug 2025 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021121; cv=none; b=uWUdzMB3ONmaQrPZuqKyMrmMnCenQUb/Eb8+h3uABwnYuTJIYB9cVZUvLoMKc2dSIee3i1JdoGbPw5il1YW1/iO+CrCLYyPh4m8bX0P6DrsDUb4vW8dcI6KOj0fg1FmvUfQhkXaxdjtYzIJ+EGoNqtThMSXJGqMWJie3d6+lwis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021121; c=relaxed/simple;
	bh=FEf95jaYQkCK28ohvOYLm6Dkutjg9qZFXq+wGMG9gp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxroGIM7HHNIKCse03j8M4oy1Vz90qopIXDzZLrKqmLyAkN2V9R8Cel6c9yebDLvgZlREuvradRtybDnWnMbKRywJfByHkymojoFUbDXhe8YFZSBowtgGKR7IvyE8xMk4OH0k+NCfjkWQF0qpet7+/k5OlCdv5gz7ka0MuW2u04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R08Lp6Tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R08Lp6Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA446C4CEF0;
	Tue, 12 Aug 2025 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021121;
	bh=FEf95jaYQkCK28ohvOYLm6Dkutjg9qZFXq+wGMG9gp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R08Lp6TxdFdGIgOihtmShmOohoK2I4GAnXgijl2UK3/vOTrN05MJ8JSkYMHJeRKec
	 BuSFiFYIZ0wZlC2u7CN33WKDN70M+u7Zk5oY0rBzDmE0KCvr+6tygTBQfSQ3+5rNkX
	 YuKei2h+TYF133o9tdaie7qepMNu0sIiRsyJeC60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/262] cpufreq: Init policy->rwsem before it may be possibly used
Date: Tue, 12 Aug 2025 19:27:09 +0200
Message-ID: <20250812172954.707974535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d48a7feba54d..cc98d8cf5433 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1287,6 +1287,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 		goto err_free_real_cpus;
 	}
 
+	init_rwsem(&policy->rwsem);
+
 	freq_constraints_init(&policy->constraints);
 
 	policy->nb_min.notifier_call = cpufreq_notifier_min;
@@ -1309,7 +1311,6 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 	}
 
 	INIT_LIST_HEAD(&policy->policy_list);
-	init_rwsem(&policy->rwsem);
 	spin_lock_init(&policy->transition_lock);
 	init_waitqueue_head(&policy->transition_wait);
 	INIT_WORK(&policy->update, handle_update);
-- 
2.39.5



