Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585628;
	b=fZw/8LYgoE2Zk0xD8ZZOzcod7Ox1+q+X8P3zr8BWHqh7Z/Ezik+qymPdBon1CWGQOavl
	 TVKDXYkYvcSEoWM1S2DUb4QA41OemQ7Q8qEbqO5reDIpHmz4Z6nHCAFYxhIiMhK/3GXcC
	 0975GeuKSmroHFTlH1PvARFpVvPHs0h+AfzQc198giPeSo3t+ud2ldvmlHDS3xfIB+2jG
	 3DJREX1kLskEv+bz6NFhWKVCLu0PhNr6dJOT5C/tkazCtDooppozyUXUttjC9EI4IdKFr
	 6fSg7ic1cxj2GAH3BVHIrkDiG4wE43zkxb+n7wXoHrFD7xYTJx++Szmnu0ippS46kjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9SncXXGEMBzciR/772ppZPkPutsIq/amvqFQV8V/axk=;
	b=Gpwmt/2+PPeC3BowtYUk3/WLpGZ/4F48nDc8U2VfyK9rrwpX5n9Nep60cdB5uEgnd6/E
	 VjrGcnO1ojlrCU7HtIO05Sn6iu6accJrZGHugFWVJvBOJRBd/3xYvyhMKXBPKJLetsS8E
	 7CZmnFsFz8uEtfnSWL87/aTkZM00gS2MDLnU4rHTkVa3q7Gz7jheckAf1mki833pXV2MF
	 ujf+Nef8L9BO87UNkGKFP1PF27wJd0oQxNEzdBaJEdOBSnUec9N0y+wkA62lH450RKm+M
	 PVByCPYkT+SzzwjXQUY0qxPiXi5zpr+wdLoWkhewGvQHe6SXFiJriNrdbXUpJI5Pixg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKoXwDsg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF70F6070FEF;
	Fri, 13 Nov 2026 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKoXwDsg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4571F000C4;
	Fri, 13 Nov 2026 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585628;
	bh=9SncXXGEMBzciR/772ppZPkPutsIq/amvqFQV8V/axk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKoXwDsgURfdbLXBTAOIHOSDjIpw7Is0Z4VQ2QLME5rPcXAnRZhzF8S++HRkcb7Fu
	 /gKrrqCIKbgEBKxTJ+yhZMtMCeXOpJTdogvEdRgx34CaY6KkusplMGAdPC94unVuGU
	 kH5LWYh4s0lu+jXGJzZcBDp/JF2a+VZ2/VYU3i+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 232/507] mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
Date: Fri, 13 Nov 2026 10:48:56 -0500
Message-ID: <20261113153802.355912466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit a76adcace3550b16e5735ba4a5e95a9c2664e113 ]

Patch series "mm/damon: fix three race bugs in sysfs and core", v1.

There are three race condition bugs in DAMON sysfs interface and the
core layer.  User impacts are not critical but better to fix sooner than
later.

Patch 1 fixes a toctou bug in DAMON sysfs interface that can mess up
DAMOS auto-tuning.  Patches 2 and 3 move static variables that can be
wrongly shared with multiple kdamonds and therefore make DAMON
monitoring results be a little more indeterministic.

This patch (of 3):

damon_sysfs_add_quota_score() reads damos_sysfs_quota_goal->metric
twice, once to set damos_quota_goal->metric to the value, and once again
to set the metric-dependent damos_quota_goal unions based on the value.

target_metrics_score() can update damos_sysfs_quota_goal->metric between
the two reads.  This time-of-check to time-of-use (toctou) race can make
the union fields incorrectly set.  The incorrect damos_quota_goal will
be passed to the core layer and make DAMOS incorrectly behave.

Users could reproduce the race by writing a new value to the
target_metric sysfs file while DAMON is starting, or online parameters
update is ongoing.  The issue will only rarely happen in the real use
cases.  It requires sysfs write permission.  The race window is short.
Sane users wouldn't do such writes while DAMON enablement and/or online
parameters update is ongoing.

The user impact is not very critical.  The race is not easy to
unintentionally trigger.  No leak or crash happens.  Nonetheless, DAMOS
could be unexpectedly more or less aggressive and does not achieve the
auto-tune goal.  Because of the nature of races, investigating will be
difficult.  Users can control the impact from unexpected aggressiveness
using additional quotas and resolve the issue in runtime by
re-installing the quota goal, though.

Avoid the race by protecting damos_sysfs_quota_goal->metric write in
target_metric_store() with damon_sysfs_lock.  Because
damon_sysfs_add_quota_score() is called while holding the same lock, the
race is removed.

The issue was discovered as a part of a bug report [1] from Sashiko,
which is partially outdated.  In more detail, the Sashiko report [1] was
mainly for an outdated bug [2].  But it was also mentioning the issue of
this patch as a similar class bug.

Link: https://lore.kernel.org/20261025164808.152048-1-sj@kernel.org
Link: https://lore.kernel.org/20261025164808.152048-2-sj@kernel.org
Link: https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b [1]
Link: https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org [2]
Fixes: 85fcf0ffc460 ("mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 4ffc13ab95e65..20eb8c242f2f8 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1300,7 +1300,10 @@ static ssize_t target_metric_store(struct kobject *kobj,
 
 		metric_name = &damos_sysfs_qgoal_metric_names[i];
 		if (sysfs_streq(buf, metric_name->name)) {
+			if (!mutex_trylock(&damon_sysfs_lock))
+				return -EBUSY;
 			goal->metric = metric_name->metric;
+			mutex_unlock(&damon_sysfs_lock);
 			return count;
 		}
 	}
-- 
2.53.0



