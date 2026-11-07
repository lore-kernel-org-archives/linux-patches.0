Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063755;
	b=JBLGfvpOfvrb1R2cGwKuVrx2yH0Uwll7SGTIQci5ZUfTaReHVKjL7Ruq8DxzTqw/MgMf
	 FOb/BkJbqH5FWv94RC7pa3M6kS3G9E01QOvmCn5piDkbZM0oLcxowyzdkhLoAC3HQ3use
	 FG62AjSmtHESNMu0kUnRDyXfSST4zUACfPk3ID2gVEIkNdnexhKX36vaaXZg1e0So7GNO
	 sjIRiPhHHXZmxSTQjA9GE3lWiC55DQQt5HTsNCez/juW4qTZ4GYlmlH50J52K/NXW/u0T
	 jcGItclGokQf65s/G5Y4DkFUv7VvYWzItD2U0+9n16BmPLzTxIsQgQ5HhqoX2mLE78g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=raSa26pDbYd8w4xQL9UVkTi3Ob0+NS5iM940IHp7Osg=;
	b=LZtgPXA/0SHX56Tum6/IXcxGtxKpGNKP0zAKX/WpKLNBWFYHzDNvCNUqHNNezNedcRc9
	 Vqh4LwYxTPPlyT0JKPy/VNOgAIekO5YQ2FNmHE6QuXgWsorFi9MTET2gDVlbXtoXZW5eq
	 nu3cy82huk762kxsN42W8Q5H+8xZ1nf5/qDvwpZTBlRfC6FL6oXgBd3DEn7XtamX5bJ8o
	 PVOegWMO0aw8vHCsPDB8AeRHIcRMDnLUdkL7J+MVH7nNfds/oGAKaY6GIMJQk3iHtL9+H
	 LZDeKpME+9iDKRPzNuqfebHZuiTgeeJdVvcwM0l/yRtIpVbTo2KU1h1R4oEX3S3laTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKkx3W2y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FC8608362E;
	Sat,  7 Nov 2026 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKkx3W2y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8617A1F0089F;
	Sat,  7 Nov 2026 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063754;
	bh=raSa26pDbYd8w4xQL9UVkTi3Ob0+NS5iM940IHp7Osg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKkx3W2yaGlzYHfDQqk9dF9HFolOtJm3ZweUZ4ImHi1HduVcERlih4LjhFQj+QcgQ
	 8++/YcP07c/NkxkAfOjX10cmWWymWdwkkLok6rIhit/VDCTu+bU4lY49c34BPzckuf
	 aYetzic9lw7RY39zSML4nabyQ5I/IkQrDfCEs/lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 810/869] cpufreq: stats: Fix potential out-of-bounds access in deferred reset
Date: Sat,  7 Nov 2026 08:58:12 -0500
Message-ID: <20261107134920.506682606@linuxfoundation.org>
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



