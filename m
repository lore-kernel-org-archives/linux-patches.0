Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2029F2264B8;
	Tue, 26 Aug 2025 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215776; cv=none; b=tIzKVmmNTMIUzY2F7z95nfu3Sd5+sBGzkOLGmgCYuVqD81tu1SldQdZKw+8qiWAUNowLATadE/oOszZmTQrKCUrA01/SVDgAvtG4tFuX+hg2U4yl68MOYZtUtTU5cfFSxKc2WIj+C3q5FeH1I1iAmFXKG5cZxWnbUWaRQm7SWKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215776; c=relaxed/simple;
	bh=GiMEsQlRsA6qIR7VKcL60N9yejI5q0Z+8C35zbReGzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDmi2py0kRZMNfZ7CqR/eGuf08M8lZLEud+ZyxKsPPpI4n7PEwZXEvr/++tJZUvgRBSW7d9XDoTEQs1kZdMvC1ToOHbVaHkYo/0ghf4PGqjiobNGx9L+4gXc8TffwUghCCNdD/1banGc8XZe01SjCkKRCSE2W/dHbeqXb4tqorM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsdwsE4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsdwsE4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A320EC4CEF1;
	Tue, 26 Aug 2025 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215776;
	bh=GiMEsQlRsA6qIR7VKcL60N9yejI5q0Z+8C35zbReGzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsdwsE4GoGYy6D4BPUY187SXfaY+wy1ClkXxzQVfntF31mZhHwiILAtv0QUcSv7wE
	 Ec+d000GQeWwFbsCu6v2OjmCF6uRquyZfrLK2Bh3ZMwDD40ZUG/fHiqox6vvqHnIvr
	 ITu319C1rXhUB3pq+enh0oIW0WEqks8n4/G5Wcqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/644] cpufreq: Init policy->rwsem before it may be possibly used
Date: Tue, 26 Aug 2025 13:03:42 +0200
Message-ID: <20250826110949.754700871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7d7158fa70c5..33c080e08623 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1228,6 +1228,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 		goto err_free_real_cpus;
 	}
 
+	init_rwsem(&policy->rwsem);
+
 	freq_constraints_init(&policy->constraints);
 
 	policy->nb_min.notifier_call = cpufreq_notifier_min;
@@ -1250,7 +1252,6 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 	}
 
 	INIT_LIST_HEAD(&policy->policy_list);
-	init_rwsem(&policy->rwsem);
 	spin_lock_init(&policy->transition_lock);
 	init_waitqueue_head(&policy->transition_wait);
 	INIT_WORK(&policy->update, handle_update);
-- 
2.39.5



