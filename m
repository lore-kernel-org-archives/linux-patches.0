Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037008;
	b=3WU9AyIk8FczvlCz5x4dBadtJ8MblUp3TL+P/AZ7dDEp88UauPl4uwH1HMHvJBmImiqY
	 Ed4jBNzhRa1qYnDMHSJDdGFt6EOgtO7FYcMUlT0TwYdsunie5LFKumf6ZbeU/9cGVzQGz
	 omkkuij7VJxyW0cYAOfgPxztDBNkP3aW0lwF22QY5GzcWYjK4oIgdhsSHtjUHv8Q1G39R
	 Yu96DGwNFiqC08JerRa+voQo7uPTQEBytkpdMW1ieiK2Nugv6oXobgOd+nzi212zf6ckk
	 9tZ0LV8Kl7DpTSkYyaImcrk6W7ZkLMuKZSRUnrmL0STLrLWZafQHdYhOojKhkvgX7dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I8anrXEn2rV28D0gICDRc7fKi51kFWqeOqP17w3O0V4=;
	b=azqrIAiRVs3fVpfHIfoc5WX2m0QExyxPM7rGo93LW9VRuVfewZGeo2152/WBPZTYiDlE
	 RpR8j7NrnZxil/rqpyPxWndX+18lDskLTfNPO7j31mcJynOeI94mPbk1Fe35ohRSc0r3K
	 m0NLfw1ssQotsJo6Z8pc8ymvCfD2oe85w0gJy7C4gaWuKcidF6dwwUDYgtEMHndzXuVSh
	 qTophE2sw6qzoILu4qEhaRk/OzxDyUEsm8yRV4bM8rcaUB54oRFJ+wlvC2S9lUagy0mKi
	 /B/hIKqcxe+XaC/ZoN3gXn6S9s2K51fx9lbQJqRMcXmBFk+wSSqZGU6sV0Wu8uaaIGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2Pxh2yX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE9B606A31C;
	Wed, 18 Nov 2026 21:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2Pxh2yX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9701F000C4;
	Wed, 18 Nov 2026 21:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037008;
	bh=I8anrXEn2rV28D0gICDRc7fKi51kFWqeOqP17w3O0V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2Pxh2yXoFdiAjhd3Eq3Jt6uA4sFUJffeR2ucwqSTkrP44axBxjclbbrKEObiEzVB
	 smhjbI1xKY+dsPX47TrwVkvrtW/Q2vnPijsLD/N49La0VHXh8xzDojvspB3fE8JeFW
	 9IOHS7ZmC5/JEC5jwOD8O599R5UhvDOiw9n5k+yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1262/3318] cpufreq: stats: Fix potential out-of-bounds access in deferred reset
Date: Wed, 18 Nov 2026 15:31:24 +0100
Message-ID: <20261118150358.069192836@linuxfoundation.org>
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
index 40a9ff18da068..d457848b3eabd 100644
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



