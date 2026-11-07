Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063398;
	b=s/C7pmWLLB4jMHMgNuaUsnEGwIymum6Ptqlu8hB1iZCEWJiKCVnCe1elh8rrBOknSj/u
	 OFtobnYyUxPnObayC9/GEnaEy70Ud+dHJuy8YIN6MF7t6SnsMSorCtxHTKkva1MN8CCZi
	 bQF6zNxH89sAtXdUehihehG883cl48vejwqLKL+Ow4At8gQtUgemIx2feTvzs81VGvE1o
	 laDkfAHv6NU7H6Jdr+HQfxZpbA4bWk0wr6o26noUJH3y9qyM3YM5EJwrpnnsjhShsOfXf
	 s6am7KkMic3Zj3tBUXvKTVrG39c6jJcN4E/vv1bAtnJmqXWARg0pwSMkI8N+h4OwUPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CetzwYpV7M1Dqo3nHXB7NC+unSew3jfV4290XFMJ7oI=;
	b=APcifkoRQSbD9V4Cmgh3c8dJVftQiy9ZmFKYnTOG2AdR87RFZ7UeK4f8SOAPsIhmiMee
	 e7ogFCLw9ma0HpRsAGNIHdEYdvgZB+ZhrUSJ7KPrJI1hdEJstih1C/z3NOqF/KuqV8P3t
	 rDXWDY0QhA+tfInMwAGIQTSiW3gR6fUbirWcmfDJmYVxpNda1Gn/xtOjIVm2vDi9WwmL9
	 B/aGO5ePFyWMlI2GBpUuivc7P/OgvisWPq69EKsE5CX669ER2CBN3VzkbhJFeyAPwJ0AP
	 ngXVb8n4ScwVX8P7pTvaGfE7K7PmBVNiykatmerqe6T1RD8XCiD9IW2FS5yaQ4SH8AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jFkVnK3X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD5E6082BE5;
	Sat,  7 Nov 2026 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jFkVnK3X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C051F008A1;
	Sat,  7 Nov 2026 14:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063398;
	bh=CetzwYpV7M1Dqo3nHXB7NC+unSew3jfV4290XFMJ7oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFkVnK3X9xftNqpQDl7NzlOaCW5fKm8l6sq6oeQEYV+KXQVaauSt83gV5FzW36wVE
	 6BtvSTTypkVzLbPUtg+vkjFTzk8l5SG9HcqaL+ByyiBUWKn6zFbNWmD3IY6dCUQGfM
	 RtTqdehXxQiSa6/pAYKWcKN+WV8Hj8wgHpqzM0HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Hui Su <sh_def@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 570/869] cpufreq: schedutil: Serialize sugov_start() against rate limit updates
Date: Sat,  7 Nov 2026 08:54:12 -0500
Message-ID: <20261107134912.573251528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 22a1fbccb929f..9b5db92744aee 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -72,6 +72,18 @@ static void sugov_update_rate_limit_us(struct sugov_policy *sg_policy)
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
@@ -859,7 +871,7 @@ static int sugov_start(struct cpufreq_policy *policy)
 	void (*uu)(struct update_util_data *data, u64 time, unsigned int flags);
 	unsigned int cpu;
 
-	sugov_update_rate_limit_us(sg_policy);
+	sugov_update_rate_limit_us_sync(sg_policy);
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;
-- 
2.53.0



