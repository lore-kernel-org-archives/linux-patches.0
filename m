Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6550DB67E;
	Wed,  8 Apr 2026 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673449; cv=none; b=f8EWf8oHLAawJv7G/EiSR80SpcOIZ+4kFEx8O5SPDCmS6AhlPVLoxIyMBE1uWgavOaiIDqxveUdU37SuGeXccQodGTxGfkKbDNOgO1N/F4qBP9OM1LZCO+XF5hMy6daztXbbmxKVmwp9HylYS6c7vHQ2R/PDS4zvOg/zhLNxG7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673449; c=relaxed/simple;
	bh=V/mB7+pNEJVwFzTMydVj6TK20Qi927GkORKqwkG4dwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0iPPUvpkyDWiYKi1yRWviBefJ51yrY9JEZffKVfu6Kb78ZT9m0GA/2nIP5ZUUDQ2OQmQ2sE3Rm/e5I660hkwye/+aeQ8BmXWKJJsAYEvvkq+Y1FpdKHVQX7QqjFqSv7ynVklGwfEBF+7a0bO39mfLKcrUG2IGtIN0C2qPzFnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4a82mnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4a82mnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBE0C19421;
	Wed,  8 Apr 2026 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673449;
	bh=V/mB7+pNEJVwFzTMydVj6TK20Qi927GkORKqwkG4dwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4a82mnO53YWvTbxDtvOSGhnWKZ2LvzP8VpX7ZcgYebcVB6pqjSMm4a3xg22dGk/R
	 qWpYugVD8gJOlKxlRs0dOb8sSPHEM7A0AC+FrKiN2sEX37uoYIVZhJrQVLH5fhJ84g
	 ZQvicHsei4W5Nkn5fkniVUDtnpgvtLMtNIcu1zoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 236/277] cpufreq: governor: fix double free in cpufreq_dbs_governor_init() error path
Date: Wed,  8 Apr 2026 20:03:41 +0200
Message-ID: <20260408175942.669843476@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 6dcf9d0064ce2f3e3dfe5755f98b93abe6a98e1e upstream.

When kobject_init_and_add() fails, cpufreq_dbs_governor_init() calls
kobject_put(&dbs_data->attr_set.kobj).

The kobject release callback cpufreq_dbs_data_release() calls
gov->exit(dbs_data) and kfree(dbs_data), but the current error path
then calls gov->exit(dbs_data) and kfree(dbs_data) again, causing a
double free.

Keep the direct kfree(dbs_data) for the gov->init() failure path, but
after kobject_init_and_add() has been called, let kobject_put() handle
the cleanup through cpufreq_dbs_data_release().

Fixes: 4ebe36c94aed ("cpufreq: Fix kobject memleak")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260401024535.1395801-1-lgs201920130244@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq_governor.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -468,13 +468,13 @@ int cpufreq_dbs_governor_init(struct cpu
 	/* Failure, so roll back. */
 	pr_err("initialization failed (dbs_data kobject init error %d)\n", ret);
 
-	kobject_put(&dbs_data->attr_set.kobj);
-
 	policy->governor_data = NULL;
 
 	if (!have_governor_per_policy())
 		gov->gdbs_data = NULL;
-	gov->exit(dbs_data);
+
+	kobject_put(&dbs_data->attr_set.kobj);
+	goto free_policy_dbs_info;
 
 free_dbs_data:
 	kfree(dbs_data);


