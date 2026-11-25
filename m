Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621536;
	b=27TDJ9IARfE4QLiJE9WRhL5SY4HeR74Q2hcpxY0H/AxbAZRc0i0Dhcij0lEvJBhf+T+H
	 xvcRriyLbSi1suHfJA111a7oFvydMdXpynjjulp0blsvLxBi/vg1qEYWH7DZRLaI6t3M7
	 qX7cPoMfv+eWfNo1r3pBKBgnPVY3gteufqRGcKsx/gvWZIt0n9t2aOFkabMcOoQnEOl+X
	 ciM6P5yaWKKQCzPqzAgWNNZq76o1BVI5zffJDpR5G8gqynJarSQ+rtkBfAPsCbzXwZfCn
	 in93BLNw9UdGNO1uLAR3Ntxv8ghGzoyz5YuLVNmbf+WCg9+kL4xl76Lpj44L7XNSjGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wECPynAaQV5ilB3SQKY5kTMEKGZ5tSTzbdGyZjTrNcM=;
	b=uAymMI+vmBLmM/1ZXDLQL98qma4Eti6vIlGDQ5Y6AtaztPC5bzdQWJCzGoHnj4sXkvt/
	 MRcyS+by4NqQy48Um4u4ph2Gq57yXSDjfkBLgyIAhy0YHdQexr2XJ01nTy2FZhgMAVBMW
	 MVa2r/82vCbfP3y0YohRrRtavEL7ua08Fb6i6uTB+Ywrv74x+w4yzJW5G5ag2WDNDncUV
	 kfQQ0SdRCbo4IVP+Rb3y/RuiB/zHkiCtcMzsUd+pbV3TQ32rEr+klY+NRq45odwwqIWJR
	 SYjJZqctwbfjOYb+Bj6DwYmAJ5DYWZaf9VfR9Sf8GFm7HvK52fF3c5JMKMsd93Sy4WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjV9eEPd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1303606A321;
	Wed, 25 Nov 2026 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjV9eEPd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F3E1F000D2;
	Wed, 25 Nov 2026 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621535;
	bh=wECPynAaQV5ilB3SQKY5kTMEKGZ5tSTzbdGyZjTrNcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjV9eEPdS/mQ6k8G6mx01SOQPdqR923CWZA8uM1gBiO3ndOLj2o2st5MiojTggM3i
	 lTSRudH0rpAI64p1UMc2emr2+EZZDkgmOfLJ5BxwZwmobubnasqTXbT5gJVOQ9OoHu
	 cLAyanqYEr2HjlJJ+MvlMPsmOo3sBaL/38kIfWaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/990] cpufreq: Hold the policy write lock when changing boost state
Date: Wed, 25 Nov 2026 15:27:01 +0100
Message-ID: <20261125143828.042011684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit e6f50e602e373583423654ec000cad8b8d08f7bc ]

The per-policy boost sysfs handler calls policy_set_boost() under
policy->rwsem, but the global boost handler and cpufreq_online() do not.
Consequently, global and per-policy boost changes can concurrently
update policy->boost_enabled, invoke the driver callback and update the
boost frequency QoS request. The driver callbacks also access policy
state, e.g. CPPC updates cpuinfo.max_freq that assumes policy->rw_sem
held.

Take policy->rwsem around policy_set_boost() in both unlocked
callers. Keep locking at the call sites because the per-policy sysfs
handler already holds the lock.

Fixes: 218a06a79d9a ("cpufreq: Support per-policy performance boost")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/be3739f8-e668-4711-912c-91459d77ed35@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ec577a20567b1..002afd47d2d59 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -597,6 +597,8 @@ static int policy_set_boost(struct cpufreq_policy *policy, bool enable)
 {
 	int ret;
 
+	lockdep_assert_held_write(&policy->rwsem);
+
 	if (policy->boost_enabled == enable)
 		return 0;
 
@@ -1631,6 +1633,8 @@ static int cpufreq_online(unsigned int cpu)
 	 */
 	if (cpufreq_driver->set_boost && policy->boost_supported &&
 	    (new_policy || !cpufreq_boost_enabled())) {
+		guard(cpufreq_policy_write)(policy);
+
 		ret = policy_set_boost(policy, cpufreq_boost_enabled());
 		if (ret) {
 			/* If the set_boost fails, the online operation is not affected */
@@ -2821,6 +2825,8 @@ static int cpufreq_boost_trigger_state(int state)
 		if (!policy->boost_supported)
 			continue;
 
+		guard(cpufreq_policy_write)(policy);
+
 		ret = policy_set_boost(policy, state);
 		if (ret)
 			goto err_reset_state;
-- 
2.53.0



