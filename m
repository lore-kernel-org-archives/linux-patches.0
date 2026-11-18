Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052913;
	b=FwQvTKTNEVIKkrjGNrcuzrIJ/MvER8ncGoYMC7OfmU7bLBkPUlCXVLyJ2zOZ6cyFvO3M
	 zeZ5IK8wDcOqXFu9WOA5iZm2zl7cMcm1LvMvhjnoG2PcJfsxJq1QyKQtenc/A57YbiHHJ
	 Pd8xTX1nxhK5/1bkGxgyhmVt/blTku05bvpyt19/iI6gwOjzbhUaFa/WbRetU1YjW9MJs
	 jgqepfcNc7djZTBIBQg1vyP+FmGciUuxYZGSYEgPEdlEV/vuHnGfH/lUjyt/K0LB3+4nv
	 rO5kWk9rvzeycai4jXcjntnlNL0AX6EmSc73hUI4DYZuruLsWd+OHa5CXpPNCEY+sMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lDTojMAVL82FpjP8hMWNS9pI8C3kEFxBdgH5MIGo8kQ=;
	b=hEWXiznaMo3Y8jDmZxLIU7GQbblLxTRshdqMmF4JQynedoukhkuqm21n/ydInkce4Qmg
	 gEQje8NLJ8rT1GJ1fEFNqEJVNJtOTY+pAIkCdnX5+mBpv9h1owXkGTEB5AbUSFMHmOr6l
	 MEIpX7Y5vJ9MGwy4h7yjkSugkI2ZPnCVw4PCa9+pygQiDaE0HatnIQZwsexSu8AXw5HYw
	 +O8kJMSVteJlpElGgZF1XNdyXBgAXWmX138nGVW14VU0Q5ioVrhKP439tctJcTP6gFUwW
	 p34cRTAQ77e8tJT6rVTwgCmX3TEAWvZAN8ueW6ZNHiDerEsPGvmu1IbezhggobAuSlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlGk9oho;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8441606A31C;
	Thu, 19 Nov 2026 01:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlGk9oho
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423631F000C5;
	Thu, 19 Nov 2026 01:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052912;
	bh=lDTojMAVL82FpjP8hMWNS9pI8C3kEFxBdgH5MIGo8kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlGk9ohop/Uil1WqkUJzKYb7aZ7ZWWva8nxzqmAuDNjdd5TXu0iT+JQ+racjcbQAC
	 a964AMj+DFVjLoEkT8FE1UJeya4rz3SjpDD9JhczEsnxpN1tNBzPe+Eu/7Fre60GX0
	 BWDm+T00Sc9ZSQsnBgZCtbBeeuGxIaYsJdbM7xcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0729/2214] cpufreq: stats: Fix potential out-of-bounds access in deferred reset
Date: Wed, 18 Nov 2026 15:40:05 +0100
Message-ID: <20261118150041.006153689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



