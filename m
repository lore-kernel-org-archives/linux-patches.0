Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062621;
	b=rR4a41t9/1KOXL8VJ35AZTzdnvSsFBAC4BKFDisQ0YrhShpVLAqm5WZ25Xg66s85KMGb
	 AJQtvBgD7L8hnpc+vkO9TPnbem+rPNfmhkobLuR4lV2AhZBUNA1N/BJGX47lkmRRHCZIF
	 PIJua8LC7DHVefEWxzRYbeqyLueKDonRXTMAJRxwjdEmxiFXzBkdHJt6Ad2lKf3VcPuH8
	 vDDxaF0ceo11xIG1liASvRCIAG/IL4aGti3qv1XPdJVN2/9v0IP5+ViKzTJQcIDKQ7mJC
	 esVvVKuUTUBQLCUHHcjGUllss1HSagO39n9vMG3+SZHm1S4nyAUG/cUVQNGm9QjX8VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S7EUK97+OUGrHrSDOt4Otn2PHn1w9AT31IdFxL8B3qo=;
	b=zMC2Tf++bhVvmHxMeDHu7XdSc/EndSAv4cS2LUvLVGmCaDt6Bd9FvdMDv4vtUzNTr1bp
	 YkkO9p6oQg5+gpHGwCX24GuYdPjdEIVSwUOUols57u4QCJZYP7UuZc/8cEAEZ5bTlgMA6
	 77m+imWUNWtiFDqTLUK5fD+6f40hnkdT2peYJe6HAfoj+45LoKSFuoZfqUpjq4HTQU+Ho
	 Aq0p1N+jiK4gH7VwxsbBgjNW6s/TLW19u4a01e0FbDgVlkqM6BQ3WJqHO2tE679iKOqhh
	 2yIkIjeoyl3c/4gXynFi7/aszoyUAd1dyeoDUkVerEdUqh1L1aQWur7YbvUwlotx5Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ke7kRMJ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B02606A655;
	Sat,  7 Nov 2026 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ke7kRMJ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5FA1F0089F;
	Sat,  7 Nov 2026 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062621;
	bh=S7EUK97+OUGrHrSDOt4Otn2PHn1w9AT31IdFxL8B3qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ke7kRMJ7LWwHnc3vpXgvC9jqjyoUdNm6k0bSvxYIP6IfifAm20M5RsrAEs9xa34Wo
	 VyxtSpNOFX1WHjwHD1E/ABOAohd3k23Urw5bephPq5t9EGJqiSyMdAJGM6LBcLfH3q
	 xGAOMaiuq729Tdf86nvgFhoV5X05hOR+CbXEj08E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1493/1536] cpufreq: stats: Fix potential out-of-bounds access in deferred reset
Date: Sat,  7 Nov 2026 08:58:29 -0500
Message-ID: <20261107135039.792774640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



