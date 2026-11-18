Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036599;
	b=M0fqeKuPsj9EdFAZNeT5bzD+y2BFRibKCp+5pYxwMcnXI0skX7G1C5xTxeiYSNuw4srV
	 tH5N0nSW8bjo+fAQ2B/lapp+mvtF276HpBYGQ1ruI69dzvfGlwbD6HT+YjZ5rPrONB6SF
	 /6/+YCDaErA62L1zUjmBHUjQK5Qo9Z+CdSrylet/hdzIPoFXlxYCM2+K38uHnoF9Ve0y9
	 Oaf7nOVMfwhOoCtbGZxlQJwKShuqrmRq6bOnpI1pizgUk9jB+N9B6giuYLMZ2wrnuZAxy
	 HbQf+7rLRjp3BolbepT4+t9hNQgDGJYzV4QEIq/kKIlhAcSyGehrbwQLuButqvaqxuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5j7q8L3tlQ+mHXX6EZRbSjyoQjW0XMNuyPUNnjtLoM=;
	b=TAUX6ImTV7i+wVloD5C4NH9csLrSX58Vi/PAXFTBpTlDLuuSy+CPzslqZSphzSIz+BPe
	 SBuZ3oCiTN2YPsKqvTvybrJJijAGn+qQw1bLGxjEZgy0581GgATG3Mt0dgQjW11AHzRsB
	 4yk46CeR7UyLDWLJs9AnWNafnvq+/jQ2254EIryc7+qI9HL+4HESOK5IP8xo+bbQfC/+s
	 5I3K677sxGU93KJeYYZqpfn5GT/k7JOQ1szj7D6Lx7XabNV1TZJv3nFNBhO+oBuP+gOhj
	 6fuJE8rShuQbHJfSwpDC7W3n+xJXSEhr/82sbYKjcLpDqkc/AihO0Lj/85nt3eAJPZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7QZVRky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DD4606A325;
	Wed, 18 Nov 2026 21:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7QZVRky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89C51F000C4;
	Wed, 18 Nov 2026 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036599;
	bh=s5j7q8L3tlQ+mHXX6EZRbSjyoQjW0XMNuyPUNnjtLoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7QZVRkyc9gkfAEoV0aMz19wRBEZICXoRKaHGKki+NNqYCAn43ZlZYayHL3+iNasB
	 6FitMUKuyW0oGGrDdakDcgsxFI/SLYSo+o54UFCkGgQyLTMxMONEWyE3jd6maP6Pqs
	 BNny0pgrKK3ZxV4d2VtwmK0QdBJbWVay4KYM/+cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Hui Su <sh_def@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1118/3318] cpufreq: schedutil: Serialize sugov_start() against rate limit updates
Date: Wed, 18 Nov 2026 15:29:00 +0100
Message-ID: <20261118150353.557303856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit ce390caf5541c493c9061e7a2d98a463e66b736a ]

The current value of sg_policy->tunables->rate_limit_us is used in
sugov_start() without locking to update sg_policy->freq_update_delay_ns,
so if rate_limit_us_store() runs in parallel with it, the rate limit
update may go unnoticed and the new freq_update_delay_ns value may be
stale until the rate limit is updated again.

To avoid that, acquire the update_lock mutex of the rate limit sysfs
attribute, that is held by rate_limit_us_store() during rate limit
updates, around the freq_update_delay_ns in sugov_start().

Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on scheduler utilization data")
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Hui Su <sh_def@163.com>
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Subject adjustment, new changelog, edits of the new comment ]
[ rjw: Add empty code line after guard()() ]
Link: https://patch.msgid.link/20261013034235.2678177-1-sh_def@163.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 809452968eb44..caa221722cbb1 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -70,6 +70,18 @@ static void sugov_update_rate_limit_us(struct sugov_policy *sg_policy)
 		(s64)sg_policy->tunables->rate_limit_us * NSEC_PER_USEC;
 }
 
+static void sugov_update_rate_limit_us_sync(struct sugov_policy *sg_policy)
+{
+	/*
+	 * Serialize with rate_limit_us_store() to prevent this path from using
+	 * a stale rate limit tunable value to set the limit for the given
+	 * policy.
+	 */
+	guard(mutex)(&sg_policy->tunables->attr_set.update_lock);
+
+	sugov_update_rate_limit_us(sg_policy);
+}
+
 static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 {
 	s64 delta_ns;
@@ -834,7 +846,7 @@ static int sugov_start(struct cpufreq_policy *policy)
 	void (*uu)(struct update_util_data *data, u64 time, unsigned int flags);
 	unsigned int cpu;
 
-	sugov_update_rate_limit_us(sg_policy);
+	sugov_update_rate_limit_us_sync(sg_policy);
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;
-- 
2.53.0



