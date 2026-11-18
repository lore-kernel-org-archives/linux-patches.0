Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021771;
	b=OO9izECgQa3jzBWebmPZPt/LXamdO3S3/HqtEaiLiHtsty+KM3dPVmfSSejh0loyLWLR
	 vng51+J77mMbcffTXhxUo1yKecL5+iL8bxvvVdgTmzc+Th6rvBwNnmcYRLzmIZQ9jqViJ
	 XARQTI20AlUiZwjyticM5uOlNcch4rgcOX1da/WaH58yUb43gG9dss9xL6G5TAo0C2H09
	 qGQxhgzHoMNx81u0Ougb+v/p4OFlLm7mFZKsFXloMxxC/5Vo0qWzkF+J6CgMsRWlLn3Ts
	 71buCIif/sDKZYlrPmxwYBmAz8PKyWRxOTECEA9UjtRfauGTw3ZQYzwgZRE6JuPADsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwdpg/N45btJouN84nMM+5CSikvaLDTYtkjOcv/ewnE=;
	b=Q40yg1zlpFvHD6EYGICeMp8jguyfODxWhK9qWMBn0D8Hw0RB3T340Nb62nrfVA771dR9
	 89Srdfgro/g2JMd89vTvqdJDjnxI3BM8Y+GimtHtnhx8/nclMqProOpbd5eGA7MGJoiD8
	 IFjyPmEXIBeqrYxNafZldTY93bHZtW1rKcEaPE2HmM5zyZndJLDRLkBEfjZ0GQzDxJK4m
	 P257YEbwbZtCUE3+LNLc1eZy49Fu+nncoL4QkjHifspcCoy/PcDF3SU5hNa0g2dEZ2esW
	 7VsaLunF1cEfpwzB+7OpzzQ3ojXYsS6CE8craY6zs5SDF1fCOIU+wbUu3jWQsxBKi5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lEzCf6hZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA3060A2603;
	Wed, 18 Nov 2026 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lEzCf6hZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6521F000C4;
	Wed, 18 Nov 2026 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021771;
	bh=bwdpg/N45btJouN84nMM+5CSikvaLDTYtkjOcv/ewnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEzCf6hZCRDZUTxB+mHtAmBhL3aNUfd8UW19s6dch3AJN0tJolhF8LPWTbmzyUVV5
	 klFnSjf5WceuMOGUROwBByQgTCEkE9i/i6jgXlqPT6XcRMOrQgeujt64x72gDcMMEb
	 2+ZUkNA7/8ujfcgfX4n11zL77FVhAx6OYAjP9NFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2425/2651] cgroup/cpuset: Fix incorrect effective_cpus bug in update_cpumasks_hier()
Date: Wed, 18 Nov 2026 16:01:05 +0100
Message-ID: <20261118150412.536284352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit d3873b45bea4cc99d135922cdc89841164f33855 ]

With the introduction of cpuset.cpus.exclusive, the computation of
effective_cpus differs depending on if a cpuset is a valid partition
root or not.

In update_cpumasks_hier(), effective_cpus is computed early
to check if the current subtree can be skipped. Later on
update_parent_effective_cpumask() may be called which can change the
partition state from valid to invalid or vice versa. If the partition
state changes, the previously computed effective_cpus may no longer be
valid. Fix that by recomputing effective_cpus again when that happens.

Also add a new test case into test_cpuset_prs.sh to verify this change.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                            | 10 ++++++++--
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |  3 +++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 770956ec1393a..731f96f42574f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2368,10 +2368,16 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		if (update_parent) {
 			update_parent_effective_cpumask(cp, partcmd_update, NULL, tmp);
 			/*
-			 * The cpuset partition_root_state may become
-			 * invalid. Capture it.
+			 * Capture current partition_root_state as it may have
+			 * changed. Recompute effective cpumask if changed.
 			 */
 			new_prs = cp->partition_root_state;
+			if (new_prs != old_prs) {
+				if (new_prs > 0)
+					compute_partition_effective_cpumask(cp, tmp->new_cpus);
+				else
+					compute_effective_cpumask(tmp->new_cpus, cp, parent);
+			}
 		}
 
 		spin_lock_irq(&callback_lock);
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 3b59433ae8be8..644cf0d2a7c48 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -295,6 +295,9 @@ TEST_MATRIX=(
 	" C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
 				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
 								       A1:P0|A2:P-1|A3:P-2 ."
+	" C1-5:X3-5:P2 C3-5:X4-5:P2 C4-5:X5:P2 \
+				   .    X1-4     .       .      .    0 A1:1-3|A2:4|A3:4 \
+								       A1:P2|A2:P2|A3:P-2 1-4"
 	" C1-4:X2-4 C1-4:X3-4:P1 C3-4:X4:P2 \
 				   .      .      .      X1      .    0 A1:1-2|A2:3-4|A3:3-4 \
 								       A1:P0|A2:P1|A3:P-2 ."
-- 
2.53.0



