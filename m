Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705267;
	b=B/sGsuils/bKdzcUVAuXFQaBXUL0vBKtylW9QAcSGgevpnBmG9q8cclU3JQ3SUN52y1G
	 1TAkSyFlX7qdHwLDjdozL8454LAlLQmtRmQPbXq9frZONKpxPOPK7HnYps5rcVUHVS605
	 +gKj5s5EmBQ9IXbwo5xJEceHiH3qKD4R1hKaG9gQkQbv1efwgmbTBWMNFKrad6eletkJX
	 AVDGrmYzdWtw9EgPYI5s74CsT73tBetcwiy+hOYWxrTdsRitPTRBHsBV2Z28rMalZPTfy
	 T84SXTxUPoN+09tFkIkf/K54+ukIr+uAzBzk29BOCPJE4OcQ2e/QyCEiaS9FZsiSMwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dHosfMd+vTCV0AqtMgcG9mukhsSBHDYJYoINaLafFTQ=;
	b=btJ+sJBUvQ82ZAHKgtFd3hzt+R9gcrqyKV8VQVmuPH+ERkhQh2dV3mMzkXBKY4xWTiQi
	 5BKMneQMN+nBOtXHGgg2yDF2qsVl7QkFR3dvcWT14GAdJktBK79oNNKYkF/Scj77+jbWA
	 g+jdi4+6kNzgcPA99tN0bCgGRosgsM4ss2fM+j4r3VFvlbKouD6Tj7Z4YXc7GFNQiZY6j
	 iRFZJh9ECQz1jbP+3IvgQM5x+FE1kly/s+xBWLVY0AI4ZsqCUxdz6R29CImmcxZm3L7ig
	 4pXkgrOOyRE7QpaVKPhy8ERRVI6vX6SgsUxXUyu5K/CV89hZI5L6TXMB2TTt9SQA6KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlNyu4la;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7247606A31E;
	Thu, 26 Nov 2026 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlNyu4la
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8201F000CF;
	Thu, 26 Nov 2026 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705267;
	bh=dHosfMd+vTCV0AqtMgcG9mukhsSBHDYJYoINaLafFTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlNyu4la3DNQ2wHkherDh+O7paRkVgHZDy8b0tNJyPPoYNh299egHPIp4o51Zzvfp
	 YDgcdCFRy0BGeyhL4YUGHkG9WTq9BVnnU7u2tt8cb8xfGEnx+Vr4sEq7kob6MizPJK
	 CBQBLaGvURP1bMVcEYDfT+ZYK4DWy04xtcDt03tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/319] cpufreq: Serialize global boost updates
Date: Thu, 26 Nov 2026 15:38:12 +0100
Message-ID: <20261126144009.543485695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 3d5720dff09f3b90d9ab2a6707e4bb8d69542f4a ]

Concurrent global boost sysfs writes can interleave their global flag
and per-policy updates. An enabling write can set the global flag, then
a disabling write can clear it and finish before the enabling write
updates the policies. Both writes succeed, leaving boost enabled on
the policies while the global flag is disabled.

Serialize the complete global boost update, including rollback on
failure, with a mutex.

Fixes: 6f19efc0a1ca ("cpufreq: Add boost frequency support in core")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20261105215223.1263415-3-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2697,6 +2697,8 @@ static int cpufreq_boost_set_sw(struct c
 	return 0;
 }
 
+static DEFINE_MUTEX(cpufreq_boost_mutex);
+
 int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
@@ -2704,6 +2706,8 @@ int cpufreq_boost_trigger_state(int stat
 	bool boost_enabled;
 	int ret = -EOPNOTSUPP;
 
+	guard(mutex)(&cpufreq_boost_mutex);
+
 	/*
 	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
 	 * make sure all policies are in sync with global boost flag.


