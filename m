Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF20F30FC27;
	Wed, 30 Sep 2026 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787634; cv=none; b=bI12UwCcFNfNZN1e8rk4jmuEYyeLo/0VqY70rrpO4xbHS9O1IX31RfwDU+Vjeknh1yVnGDd6NIEA2yY3eJt26S/MEvRtsAwNKjRxgTb7eKlD7scMA+085cKqdEY6jOPPUPJuE2UqdpSxZHSTUPcE96Xoj9X9aKQ0Bms1GnhbSjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787634; c=relaxed/simple;
	bh=cF6nOJlmzHYk+djFOPiV+DZwVy3uWeZII9j6US8xtCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ1JDAkjdowt5nHtucHgVZM8hY9a8WB9G0DxlRytlxnKE1NfDXJFrqn2lco89PKLMBUigk0zDD6K55T51Ar+bcOm2bnKTCwTpOjEJG50xed0SZfyXtXZfUZoAOgcY9stwREYaIhimQbIiMkW4nkqi0t1ZW5Hn4BHePUudN3QH3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkIY6WX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkIY6WX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D19D1F00898;
	Wed, 30 Sep 2026 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787633;
	bh=w5RiXtx01PWY6UGh/18yPZIj1odPPndi8DPSDbDSbJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkIY6WX7Q6SYTYL9JxUfzlgzhMtPFtyK42fQbe+6vb8wvz/ZQg4Y6rfifFMyGDrz4
	 IERREQWlr4Li1znuPsHyaYkAAB6h/OwoQzGhQ3R6mW+I8pjnYctDZxQVBb4NId/MuW
	 OdEqJi2D02IZdx4pVA61eSejwuQyrlYEHvUoEAKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Hui Peng <benquike@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 254/457] cgroup/cpuset: Return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict
Date: Wed, 30 Sep 2026 17:25:59 +0200
Message-ID: <20260930152351.529625101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

commit 31c88350b7dd1522792f726f79607f31bb55c50f upstream.

When a remote partition is created underneath an existing local partition
via a non-partition (PRS_MEMBER) intermediate cgroup, update_prstate() sees
parent->partition_root_state == PRS_MEMBER and calls
remote_partition_enable().

Commit 86888c7bd117 ("cgroup/cpuset: Add warnings to catch inconsistency
in exclusive CPUs") replaced the cpumask_intersects(tmp->new_cpus,
subpartitions_cpus) error check in remote_partition_enable() with
WARN_ON_ONCE(). As a result, remote_partition_enable() emits a warning
and proceeds to enable the remote partition on CPUs that are already
owned by the ancestor local partition in subpartitions_cpus.

This can be reproduced on Linux 7.3.0-rc3 with:

  mkdir -p /tmp/cg1
  mount -t cgroup2 none /tmp/cg1
  echo "+cpuset" > /tmp/cg1/cgroup.subtree_control

  mkdir /tmp/cg1/A
  echo 1 > /tmp/cg1/A/cpuset.cpus
  echo 1 > /tmp/cg1/A/cpuset.cpus.exclusive
  echo root > /tmp/cg1/A/cpuset.cpus.partition
  echo "+cpuset" > /tmp/cg1/A/cgroup.subtree_control

  mkdir /tmp/cg1/A/B
  echo 1 > /tmp/cg1/A/B/cpuset.cpus
  echo 1 > /tmp/cg1/A/B/cpuset.cpus.exclusive
  echo "+cpuset" > /tmp/cg1/A/B/cgroup.subtree_control

  mkdir /tmp/cg1/A/B/D
  echo 1 > /tmp/cg1/A/B/D/cpuset.cpus
  echo 1 > /tmp/cg1/A/B/D/cpuset.cpus.exclusive
  echo root > /tmp/cg1/A/B/D/cpuset.cpus.partition

which triggers:

  WARNING: kernel/cgroup/cpuset.c:1594 at remote_partition_enable+0x1c1/0x300

and leaves both /tmp/cg1/A and /tmp/cg1/A/B/D as active root partitions
claiming exclusive CPU 1.

Fix this by returning PERR_NOCPUS when tmp->new_cpus intersects
subpartitions_cpus in remote_partition_enable(), matching the error code
used by remote_cpus_update() for the same subpartitions_cpus conflict, and
add a regression test case to
tools/testing/selftests/cgroup/test_cpuset_prs.sh.

Tested in QEMU on Linux 7.3.0-rc3 using the reproducer above and
tools/testing/selftests/cgroup/test_cpuset_prs.sh.

Fixes: 86888c7bd117 ("cgroup/cpuset: Add warnings to catch inconsistency in exclusive CPUs")
Suggested-by: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c                            |    3 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1552,10 +1552,11 @@ static int remote_partition_enable(struc
 	 * above it or remote partition root underneath it is not allowed.
 	 */
 	compute_excpus(cs, tmp->new_cpus);
-	WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
 	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
 	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
 		return PERR_INVCPUS;
+	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
+		return PERR_NOCPUS;
 	if (((new_prs == PRS_ISOLATED) &&
 	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
 	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -298,6 +298,8 @@ TEST_MATRIX=(
 	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
 				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
 								       A1:P0|A2:P2|A3:P-1 2-4"
+	" CX1-3:P1 CX1-3  CX1-3    .      .      .      P1      .    0 A1:1-3|A2:1-3|A3:1-3 \
+								       A1:P1|A2:P0|A3:P-1"
 
 	# Remote partition offline tests
 	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 .   0 A1:0-1|A2:1|A3:3 A1:P0|A3:P2 2-3"


