Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045854;
	b=OzNpVHk8Q0ZS5oyJlXDFEwmMq027flvPAA1uLXqW5YZ7bh1snsxYL5rIBn4gy9Pz0tgM
	 06hrNf6IfOfJiBuPSMREB69JNDGdHkUZ6kcxVr94ZvPEgXs9VKAmHEJnlMGJBZoVCHNFa
	 oGB4+CRoExC5ebddxaridgyep9VVf7HmA9pKL9YsO9Mo2AhLzKivmoOL1OYlXv3ib3+cQ
	 tNrHIipbSqOEq1BzJVm9Iq8EZyTdJzHTvUBCyL4sBQ4baO4Yq5q1VJGYI3Ge8V3a8EKJx
	 Ivt5NYbPgABjZ33ecI2K/5n5VvAE2vQyNuXxVo64zhgRDR2sDXAahVdgtGuIPlat39Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+1FD8Ouz/+2mFrvqcXxCjsqeP2625VydqYq3+gmVhEA=;
	b=1ukiizCH7yVwwSHDyOZ7f3NySONAcne7/SThlZB2lF0d648FArKozPO5/Dlk3ikfEONs
	 /UNfNrlY0v3m6RK4T1cXB/WkFG/tXmwWRZ0HMptVOl23gO+Ovp/NzscjCWc2DGeUko0e1
	 gjf8zkm2MdV68D3gktNWEFawi/qGRKLl6S3IpYYHYg3j8LBUmvMLG1zaiuH/u7j8FWgzG
	 2/FKyAsYLLHM1IdasMVio0PHSZJ769N5hNtC17DfkcAcej7cCQU5B8Ccn8RCd+PFaJoPP
	 RtGMEelOHYiHpUawILZUp4RepH7/+52pFNPv+wPp54i4NTVXpnexYBAkjtrcAgv+NCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1qZkN2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60311606A31C;
	Wed, 18 Nov 2026 23:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1qZkN2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1C61F000C4;
	Wed, 18 Nov 2026 23:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045854;
	bh=+1FD8Ouz/+2mFrvqcXxCjsqeP2625VydqYq3+gmVhEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1qZkN2ADeCQY0gsuoJndBhNAJEIwygUp91xT16oUPWjLMJnpJA9cRH0M4JOyQW4K
	 GsE0SvSdBzf/LuGAwbob5di1a6vggSrULyoIuHDGMO3g2RBZUEUvkR3J36gxvwOiwF
	 amJSTI0zAqMtN3QvynxEyNwleJNH1F4GKuJxNIKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1070/2857] cpufreq: stats: Fix potential out-of-bounds access in deferred reset
Date: Wed, 18 Nov 2026 15:35:04 +0100
Message-ID: <20261118150240.134174369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

[ Upstream commit 8a702989677216489e471a6f27599da53f753567 ]

cpufreq_stats_create_table() sets stats->last_index to -1 if policy->cur
is not in the frequency table. It then stays at -1, because
cpufreq_stats_record_transition() returns early on old_index == -1 before
it gets to update last_index.

Commit 46a310b80bc2 ("[CPUFREQ] Don't set stat->last_index to -1 if
the pol->cur has incorrect value.") added that check. However, since
commit 40c3bd4cfa6f ("cpufreq: stats: Defer stats update to
cpufreq_stats_record_transition()"), the stats reset is deferred to the
beginning of cpufreq_stats_record_transition(), before that check, and
cpufreq_stats_reset_table() ends with an unconditional
cpufreq_stats_update(). So if the "reset" attribute is written while
last_index is -1, the next frequency transition accesses
time_in_state[-1].

Fix it by also returning early on last_index == -1 in
cpufreq_stats_reset_table().

Fixes: 40c3bd4cfa6f ("cpufreq: stats: Defer stats update to cpufreq_stats_record_transition()")
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027133332.377546-1-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_stats.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 6e57df7a2249f..35a3bf4b6ee13 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -52,6 +52,10 @@ static void cpufreq_stats_reset_table(struct cpufreq_stats *stats)
 	 * reset_pending accesses in cpufreq_stats_record_transition().
 	 */
 	smp_rmb();
+
+	if (stats->last_index == -1)
+		return;
+
 	cpufreq_stats_update(stats, READ_ONCE(stats->reset_time));
 }
 
-- 
2.53.0



