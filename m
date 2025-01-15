Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56AF248BA1;
	Wed, 15 Jan 2025 10:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938174; cv=none; b=buAj4+OZzM+yJ+Sc338uI7dQKSsllGgLyXflVJZzMWqVbo+ZQd/DAK8v3JXK0iI5foMFR9h6LCvZdFWX36TfNjwu8yJcCd2qXUrACFbOlMRHYq6A08uVl4PxT9Ib8J8XU7/4IKgWqsBwyMkF7O/3c9lmhhOdVd8b+/f139mOr/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938174; c=relaxed/simple;
	bh=LL6G4yCqeJ7Z55shYK0thCXdg+1TrAxK0o2VOoci3qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPSJ1QpLPHhdpl5xQA2UapF7yLcekavCOASN8mDVyU0K6JM5pFbsJdcWxGbd6rOulIvbIo+iMmo1LLqaWNjKILaOLITmbCdoQMQvDKhDaNeAvvwjLBxNG7VZaqU9pEDM02Jap8YLBhNLSRln6ZrGgo0Brbyav9B6Rguj735BayI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKvf6IKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKvf6IKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB8EC4CEDF;
	Wed, 15 Jan 2025 10:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938174;
	bh=LL6G4yCqeJ7Z55shYK0thCXdg+1TrAxK0o2VOoci3qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKvf6IKKF5UJPods7HaJBD2gRHSQiGtLVzC5U/c5XPwxuhegrG5VJ+Ahfcxcd8amH
	 +SV35YzfhC9M7whaPNCjO515SX1hxTNBk05u93s6j7qFweGwgYDVba+MgxUPckrPQp
	 1GhmIHIYV4VRitVJfVyEK0099s9bmWd9rcsY6pT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/189] cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains
Date: Wed, 15 Jan 2025 11:36:42 +0100
Message-ID: <20250115103610.684207139@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 9b496a8bbed9cc292b0dfd796f38ec58b6d0375f ]

Isolated CPUs are not allowed to be used in a non-isolated partition.
The only exception is the top cpuset which is allowed to contain boot
time isolated CPUs.

Commit ccac8e8de99c ("cgroup/cpuset: Fix remote root partition creation
problem") introduces a simplified scheme of including only partition
roots in sched domain generation. However, it does not properly account
for this exception case. This can result in leakage of isolated CPUs
into a sched domain.

Fix it by making sure that isolated CPUs are excluded from the top
cpuset before generating sched domains.

Also update the way the boot time isolated CPUs are handled in
test_cpuset_prs.sh to make sure that those isolated CPUs are really
isolated instead of just skipping them in the tests.

Fixes: ccac8e8de99c ("cgroup/cpuset: Fix remote root partition creation problem")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                        | 10 +++++-
 .../selftests/cgroup/test_cpuset_prs.sh       | 33 +++++++++++--------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a4dd285cdf39..c431c50512bd 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -862,7 +862,15 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	 */
 	if (cgrpv2) {
 		for (i = 0; i < ndoms; i++) {
-			cpumask_copy(doms[i], csa[i]->effective_cpus);
+			/*
+			 * The top cpuset may contain some boot time isolated
+			 * CPUs that need to be excluded from the sched domain.
+			 */
+			if (csa[i] == &top_cpuset)
+				cpumask_and(doms[i], csa[i]->effective_cpus,
+					    housekeeping_cpumask(HK_TYPE_DOMAIN));
+			else
+				cpumask_copy(doms[i], csa[i]->effective_cpus);
 			if (dattr)
 				dattr[i] = SD_ATTR_INIT;
 		}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 03c1bdaed2c3..400a696a0d21 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -86,15 +86,15 @@ echo "" > test/cpuset.cpus
 
 #
 # If isolated CPUs have been reserved at boot time (as shown in
-# cpuset.cpus.isolated), these isolated CPUs should be outside of CPUs 0-7
+# cpuset.cpus.isolated), these isolated CPUs should be outside of CPUs 0-8
 # that will be used by this script for testing purpose. If not, some of
-# the tests may fail incorrectly. These isolated CPUs will also be removed
-# before being compared with the expected results.
+# the tests may fail incorrectly. These pre-isolated CPUs should stay in
+# an isolated state throughout the testing process for now.
 #
 BOOT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
 if [[ -n "$BOOT_ISOLCPUS" ]]
 then
-	[[ $(echo $BOOT_ISOLCPUS | sed -e "s/[,-].*//") -le 7 ]] &&
+	[[ $(echo $BOOT_ISOLCPUS | sed -e "s/[,-].*//") -le 8 ]] &&
 		skip_test "Pre-isolated CPUs ($BOOT_ISOLCPUS) overlap CPUs to be tested"
 	echo "Pre-isolated CPUs: $BOOT_ISOLCPUS"
 fi
@@ -683,15 +683,19 @@ check_isolcpus()
 		EXPECT_VAL2=$EXPECT_VAL
 	fi
 
+	#
+	# Appending pre-isolated CPUs
+	# Even though CPU #8 isn't used for testing, it can't be pre-isolated
+	# to make appending those CPUs easier.
+	#
+	[[ -n "$BOOT_ISOLCPUS" ]] && {
+		EXPECT_VAL=${EXPECT_VAL:+${EXPECT_VAL},}${BOOT_ISOLCPUS}
+		EXPECT_VAL2=${EXPECT_VAL2:+${EXPECT_VAL2},}${BOOT_ISOLCPUS}
+	}
+
 	#
 	# Check cpuset.cpus.isolated cpumask
 	#
-	if [[ -z "$BOOT_ISOLCPUS" ]]
-	then
-		ISOLCPUS=$(cat $ISCPUS)
-	else
-		ISOLCPUS=$(cat $ISCPUS | sed -e "s/,*$BOOT_ISOLCPUS//")
-	fi
 	[[ "$EXPECT_VAL2" != "$ISOLCPUS" ]] && {
 		# Take a 50ms pause and try again
 		pause 0.05
@@ -731,8 +735,6 @@ check_isolcpus()
 		fi
 	done
 	[[ "$ISOLCPUS" = *- ]] && ISOLCPUS=${ISOLCPUS}$LASTISOLCPU
-	[[ -n "BOOT_ISOLCPUS" ]] &&
-		ISOLCPUS=$(echo $ISOLCPUS | sed -e "s/,*$BOOT_ISOLCPUS//")
 
 	[[ "$EXPECT_VAL" = "$ISOLCPUS" ]]
 }
@@ -836,8 +838,11 @@ run_state_test()
 		# if available
 		[[ -n "$ICPUS" ]] && {
 			check_isolcpus $ICPUS
-			[[ $? -ne 0 ]] && test_fail $I "isolated CPU" \
-				"Expect $ICPUS, get $ISOLCPUS instead"
+			[[ $? -ne 0 ]] && {
+				[[ -n "$BOOT_ISOLCPUS" ]] && ICPUS=${ICPUS},${BOOT_ISOLCPUS}
+				test_fail $I "isolated CPU" \
+					"Expect $ICPUS, get $ISOLCPUS instead"
+			}
 		}
 		reset_cgroup_states
 		#
-- 
2.39.5



