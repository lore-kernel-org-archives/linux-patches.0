Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064860;
	b=YEsMfm7scFO/60ImBQQ94ehMB5llol2kzcfHiCxIiqxWlejqrZqqHRRHX+dLDak/GwJv
	 ySPkZ3zJ9VLi8Mlk/oza8WcyITbpglWdAldWbbGYcLnisHFp2wkmDJmymXsYjNzBmKJV/
	 lOv2K/O1t7Ob+N178hMhOyJJDNTByTLZA4ufVdse8vMXpZAVtvnSYk9UKe30YNKz4CXb4
	 qqo6qfNsp7Qml3fz/CaITdbDC36gT3Omku6XiKeeQGs08f0w9iG9lFHPb8qSY47CGBFhx
	 BnOoY+4E9Q9GgkKeHancY1IRrqx6BK6BSkoleF5wCCPlvALz4tAq2ibmDEX84B1D9lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ByEMR6fmAEPUKlsGoQt4KSpWavujDrbYvYwMJjE+vV8=;
	b=C6JVOdhNkZUIUNTcUKNq7zvDyjN8hAyz2hCnEp2gFqp8+IghoTSoWqrHDIz3vyxmV9JI
	 7sbmy8oD6BDiXj86XrWJvsP9IHI1Hq9yiYtmXOUBt6bblzEbiivj/6DEzRyOv83lQtlGM
	 ozNmIom5c25XvYtScuxUGIslMiqAFFwh90E2iiDY/HwyfXh//Msuq0KN75kldvtMjGC6z
	 TUcdzEcidM3Rk5/TsZC2SHsCyG0XeSOth+DA+6SAyphaVKIIMQ+b7ZZGb38ahdTKbmWiR
	 1IkcxW10RDgzHvOh3WLgC22ZUbDW5yK96Dj15NZC8GP+J3YHMXH1AXp3I02JC8su/aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLU8iNo3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53123606A326;
	Sat,  7 Nov 2026 15:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLU8iNo3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D548D1F0089F;
	Sat,  7 Nov 2026 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064860;
	bh=ByEMR6fmAEPUKlsGoQt4KSpWavujDrbYvYwMJjE+vV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLU8iNo3LWs37JSSkPMf3/7OxJ8x4/VFLhPDEyyaq6GX/rmrWh1dszMSIt62vs8eA
	 sWeT9siZ7VRxzIY11uL/fKADyliH1PedZZJYcgkYToMNXmDgzIps3Z76H+la6Y+mLL
	 7LgdRuesURrxvI/DCNimVcs7NWKtqFnddoLQpO78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Hui Su <sh_def@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0779/1257] cpufreq: schedutil: Serialize sugov_start() against rate limit updates
Date: Sat,  7 Nov 2026 08:51:15 -0500
Message-ID: <20261107135000.822224478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 49ccd6f1c1850..14405a6149911 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -73,6 +73,18 @@ static void sugov_update_rate_limit_us(struct sugov_policy *sg_policy)
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
@@ -861,7 +873,7 @@ static int sugov_start(struct cpufreq_policy *policy)
 	void (*uu)(struct update_util_data *data, u64 time, unsigned int flags);
 	unsigned int cpu;
 
-	sugov_update_rate_limit_us(sg_policy);
+	sugov_update_rate_limit_us_sync(sg_policy);
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;
-- 
2.53.0



