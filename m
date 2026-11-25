Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619042;
	b=OsuegJ3Ei32VUqb5B311yLzvrmarR4K6d1d75JpA5vCbBiNzx62leR/GO1FBRgyMtmOI
	 HKsUWy4tEbcCTZaTZDTSrSg5hBdbUHzmGNS8ocpY6lEcH9W3137a9XbAgadXn+vv0bOGM
	 7TYp3d/XwPjxGFOflCLaOfrai71UXHPbPOFTF/Gh5FKUWMdNpvmlIpkAYMm7xzBY+qu9e
	 MM78JaDVJNlXrPmCjq+r6c/Amt3cCHinDbagKmFILF0XW3CQBZdpuLbUJ77RxiaeOaaLb
	 jvDmEw/pFX8IZDjKzYaDoYAcAn6XrLeaq7YKsKezVS8DWZIXuhyso4TVodNUYbMWBnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lpkLgQgmRpE7uPP+y1sG1N2QMKZ+6k6mgbsxD7zC6UE=;
	b=GlodM9VSZqbEvsD1V2FJWDBHMY8sHCEBmtZcFSS3fv7+3rnE2FccCzkve4rWO5PQjkNM
	 D5mC3pcJPThXVSKe+pgI/HKazgMgP5cSwzj67XxxVAMFkqq44kzHaXbqTfMWSKUbRQVFG
	 0OdllaUNCMzLuVKddvcGqBjrtI8T1XIBew54sa2GnT/dHyNb59PXEpDuHRa3pyWAZ5D9j
	 RDZlR3F+SpP+8By28P8PRZGssdzNyAD7/rm+GCwRyoKY+CciSzCogeiF6+7kcGKQTsfzN
	 neJBJOgji6J2M3/1CJqs2BTFMlzKN/lMyUlFx/h7NMZxLuRGYHeUn152cr5GJTLTgqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITJEKqBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F0C606A31E;
	Wed, 25 Nov 2026 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITJEKqBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98581F000CA;
	Wed, 25 Nov 2026 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619042;
	bh=lpkLgQgmRpE7uPP+y1sG1N2QMKZ+6k6mgbsxD7zC6UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITJEKqBlyRY4Ee0Y9RAHspa8/9+bZuXzffk0sHKpujpgdSSTOj82AZCp5WReqTxow
	 ncIq+qREJoZax6kYcH4CfZSB3uaHKtt2x3z/tPnR4Zc3HR7TMoAvYLIVF5K8vPveIs
	 YawJYweRSee5mPRe7TFH22LtrpkniZNywp+13FTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qiao <zhangqiao22@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0471/1005] sched_ext: Fix partial-SMT core counting in calc_shard_layout()
Date: Wed, 25 Nov 2026 15:30:09 +0100
Message-ID: <20261125143832.779553195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Zhang Qiao <zhangqiao22@huawei.com>

[ Upstream commit 3b1ce3e0ccba4aadbf6330a5ed8bda78f0c9353a ]

calc_shard_layout() counts the cores of an LLC to spread them evenly
across shards. A core is counted when its cpu is the first cpu of
topology_sibling_cpumask(), but the cores scx_cid_init() builds are
the siblings intersected with @llc_cpus.

The sibling mask may contain cpus outside @llc_cpus - siblings which
landed in another node or LLC unit, or offlined siblings on archs
that keep them in the mask (mips, sparc64). A core whose first
sibling is such a cpu is never counted, so cores_per_shard and
nr_large come out too small and the shards end up uneven.

Count a core at its first sibling in @llc_cpus, matching the cores the
build loop constructs.

Fixes: e2c841b91bf9 ("sched_ext: Add CID sharding")
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/cid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext/cid.c b/kernel/sched/ext/cid.c
index 3d0687184b448..17c86f25a59cd 100644
--- a/kernel/sched/ext/cid.c
+++ b/kernel/sched/ext/cid.c
@@ -63,7 +63,13 @@ static void calc_shard_layout(const struct cpumask *llc_cpus, u32 shard_size,
 
 	for_each_cpu(cpu, llc_cpus) {
 		nr_cpus++;
-		if (cpumask_first(topology_sibling_cpumask(cpu)) == cpu)
+		/*
+		 * scx_cid_init() forms each core from the siblings in
+		 * @llc_cpus. The sibling mask may include cpus outside
+		 * @llc_cpus, so count a core at its first sibling in @llc_cpus.
+		 */
+		if (cpumask_first_and(topology_sibling_cpumask(cpu),
+				      llc_cpus) == cpu)
 			nr_cores++;
 	}
 
-- 
2.53.0



