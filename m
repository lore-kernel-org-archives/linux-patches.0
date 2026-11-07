Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065476;
	b=fquwUuMetJctmiUQK4uKcEhsCcdjnNW+wyI5dPcoBR3eoiLUivkPOqkZNx1xCBcAPkKi
	 chXMcFF17QKrYKSGXIkrabQcU8DNjtr8USJqWokjMVDtxAvIHtMg0YVAuX513DiD6FsHK
	 X93lHiOKaXbzfF1vlitX6YAmauvOcvfsIldtoZg/vKjo0SJuJa5uft6ydXiKuWMvAHcxH
	 OISg3HjD/mOli/PPgGlCsgyW3yYfR/Na9ddlAgNm0WSQD1e2EdQe8o9bHdJUElfuiiL6v
	 5HQ+Q+yCjY0PkIHDFUMh0YZ18LBNlmgYx+n0UUYJOfmqvFEOvM2WzUI5OFzaACOPKPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F3wizEtrRVeKyOMYXuJk4UaAv0/ckEnoiuspwmmf9wU=;
	b=Kr6fJnNxlFKYRl/ylSk7NM75MNxRnfAhl9pfi9tenC0GPC3WeB4ogJV9zYBmfcOxzyN3
	 OnkYd9XA4Ug8NQVoSOwGLjuxN8ppfMXWEffhzk5OHPosl55Jf7ttiCDzPoU7tUmq+MOpo
	 DwfDBxElx+5oPE+HQZ8Ns6A4f5F5ZQqbxJIsnOOzYm5n082vcOzuhO+A1TjCCIt7gfgx+
	 zG//fZK4mUR+f1zmj506SMl6SgNVMpM0+jAvkxiYWRlwpudzMLdhd/7iN0lkKCE3ozDnE
	 8l0B13ioB4Ax4DeOHeX+aHctFS7UR1jy7L1ihb6bt9s26UR//x7vMrBtqmCdzD/l6dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRu4t+pX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71E7606A339;
	Sat,  7 Nov 2026 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRu4t+pX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841731F008A1;
	Sat,  7 Nov 2026 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065475;
	bh=F3wizEtrRVeKyOMYXuJk4UaAv0/ckEnoiuspwmmf9wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRu4t+pXUG12G28HQB1JJuUoJYWw1QO1pJeX3IlvOzCK6o4chXbFK1RBNfYzW4DsK
	 NpyBBBa3z10WeVjaIT4qK6CezgS24Q1nnIqHKiGWgmt39/1G+rFU6yi4qdTK1U3KsJ
	 nKQOV6QIJUJe5PKwPuzM/olbIULss2CcBjbdvbm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1172/1257] cpufreq: stats: Fix potential out-of-bounds access in deferred reset
Date: Sat,  7 Nov 2026 08:57:48 -0500
Message-ID: <20261107135011.548594998@linuxfoundation.org>
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
index 670a10c3ecfad..e7ec16bcb67ea 100644
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



