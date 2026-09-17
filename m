Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803FD48488B;
	Thu, 17 Sep 2026 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658778; cv=none; b=InrQB8WvOSU6XmCTCFDQfRKy+BLRKlCQ5ChIsUrDd64xMOQDboXm3HZjIi1kIy4gSuhSR2TnOa/X6csW6uk8x4/JOXVXGZR0KwK5DeLwtvUjGZrScIc3+V7yktmhLN6MTcKqAB8/CaWTTIWuExSS8pdbxUAaL1B2hAB8vmU7Q5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658778; c=relaxed/simple;
	bh=nZQO9urTrfSh0UrQoEY1bn4iYJxhdz9+PGvEXLaoyeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTTAi/iO4UHW0aPFUyQt+oL1w26zwyUzZ7bEFah/eSDpPuKPMXgjkN89WMzp/0QDoy+8bLJZqMHewYvHPvT/2bMevQCAoJXBEfswRFZ2J7QdoT2OArG88qSy5T83m3+4GfRfpuBvnxdALb8IG+HmzB14j3R+Rp63OVaFPiKLGYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mR9HfBGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mR9HfBGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F151F00898;
	Thu, 17 Sep 2026 15:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658766;
	bh=Zwm7l+bg7bG8HCBpVRmBRluPfWl3oXF+esS2fdkcL2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mR9HfBGF6YliBkZ9SIYe0RLqzJw94sxAeECb5Er9evAoSD25quwNVSIPt1kYUJwRo
	 1itkKEyoChVLw3069kxqFNLohfyPYR6JpPZugZViDXwEICZldCZgt5jple943U1oBn
	 817szdkCiFeXcTzXYA5IpTOaOSMvqDiwBO/m4Tzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 032/733] selftests/cgroup: Drop invalid boot isolation comparison
Date: Thu, 17 Sep 2026 16:05:40 +0100
Message-ID: <20260917151351.533178458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 2bf404b1bd94f50747443234c0a4a5e18e2569bf ]

check_isolcpus() clears ISOLCPUS before rebuilding it from sched domain
data. Comparing that empty value with
/sys/devices/system/cpu/isolated makes the test fail whenever
isolcpus=domain is present.

That sysfs file is generated from HK_TYPE_DOMAIN_BOOT and does not change
when cpuset updates HK_TYPE_DOMAIN. Re-reading it cannot validate dynamic
housekeeping updates. The cpuset.cpus.isolated and sched domain checks
already cover the two dynamic interfaces, so remove the invalid comparison.

This can be reproduced on a kernel booted with isolcpus=domain,15:

    # tools/testing/selftests/cgroup/test_cpuset_prs.sh

The test fails its first state-matrix isolation check before the change and
continues past that check afterward.

Fixes: 6df415aa46ec ("cgroup/cpuset: Defer housekeeping_update() calls from CPU hotplug to workqueue")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index b2e60671273ec..ebbc5b4def243 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -791,7 +791,6 @@ check_isolcpus()
 	EXPECTED_ISOLCPUS=$1
 	ISCPUS=${CGROUP2}/cpuset.cpus.isolated
 	ISOLCPUS=$(cat $ISCPUS)
-	HKICPUS=$(cat /sys/devices/system/cpu/isolated)
 	LASTISOLCPU=
 	SCHED_DOMAINS=/sys/kernel/debug/sched/domains
 	if [[ $EXPECTED_ISOLCPUS = . ]]
@@ -829,11 +828,6 @@ check_isolcpus()
 	ISOLCPUS=
 	EXPECTED_ISOLCPUS=$EXPECTED_SDOMAIN
 
-	#
-	# The inverse of HK_TYPE_DOMAIN cpumask in $HKICPUS should match $ISOLCPUS
-	#
-	[[ "$ISOLCPUS" != "$HKICPUS" ]] && return 1
-
 	#
 	# Use the sched domain in debugfs to check isolated CPUs, if available
 	#
-- 
2.53.0



