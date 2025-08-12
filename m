Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B168C17993;
	Tue, 12 Aug 2025 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022117; cv=none; b=dFzjhP06z5533MRBuYefu8L1hJ08likoQWGyg1sosAXVk3OORtWudpN+HXp/QexbEwK+tTEk8R+lwd/W8CzMN9/0j57dDL/dZuRLyMRI75deP/3tVr9E/VekrKQsktJZ7ZRXf6nPO50fAL81B7s44fIGVuUM9PF2RCm1ExgJoN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022117; c=relaxed/simple;
	bh=QI+/d4blvY8ETO81GDO6nOWn4kEK9sD1T1RtWoCaCj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqzlwT+OrhXsH0AcZBAl1YzpSTbJ5swINFnDFlounHT8ccbJuWPOqy6WXZcaijcHirfnx3NgmTPtv1yQb1DFjhPjCxtBEfipV4uIo5Oa4C9vEQUhR4G/crOLVPksgRZ9UKz6SQLkhWD6un6l44RY8DLq+7rStmi0PsHgMnaIrwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiJSsOd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiJSsOd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201BEC4CEF7;
	Tue, 12 Aug 2025 18:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022117;
	bh=QI+/d4blvY8ETO81GDO6nOWn4kEK9sD1T1RtWoCaCj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiJSsOd+aYqrarzOSU2U25Z4yhY7YU3L9zlS9vHWOnr5i0GkpEbWpr6DiZGpAvWxg
	 hYVPKZEgEbqQleplzsfH2k3qhZfYQz2zMhW4areahXeeBDy9YenFS8wd+u3CTis1nv
	 fPu5vBCzfSKiXgd6nRW0naHZHqiyCNxfvnOGLKX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/369] cpufreq: Init policy->rwsem before it may be possibly used
Date: Tue, 12 Aug 2025 19:25:56 +0200
Message-ID: <20250812173016.982132421@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index df3c8daede26..fab94ffcb22c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1275,6 +1275,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 		goto err_free_real_cpus;
 	}
 
+	init_rwsem(&policy->rwsem);
+
 	freq_constraints_init(&policy->constraints);
 
 	policy->nb_min.notifier_call = cpufreq_notifier_min;
@@ -1297,7 +1299,6 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 	}
 
 	INIT_LIST_HEAD(&policy->policy_list);
-	init_rwsem(&policy->rwsem);
 	spin_lock_init(&policy->transition_lock);
 	init_waitqueue_head(&policy->transition_wait);
 	INIT_WORK(&policy->update, handle_update);
-- 
2.39.5



