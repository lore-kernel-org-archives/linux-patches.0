Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065226;
	b=AsXWEzO/O6mro1zW0dJUBW31zpSZbn4+CeaNOOCuaik1vvlYocFwRKSjQXArm5F7FN/O
	 5ocB/7ABonSfeMesuJvDPrsrXikoAaihcz/rAfxkFPs7mBraWc7+rhMvNvvuBArwhjope
	 z7OzmOdmS0BDeDWMvDQKaSUc+dtRdzv3a6xkMDsUN+pJ62CluZV3j+2bzz0QllmqL+TBt
	 /dnAH9NNaVpOEXoaP8cgZRgPtg3j4i/GBrTanASTCad5VgFhPyHBa+XEVoAspXRxYNDSz
	 +eNVYQZ68cJPjOYxdQUbQxcK4GeQG3/WEsZv7gV+3A/kbAAR9P59ta0Kgz+Ceg5Fkxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uUYkIVx428SQ+5HhyT/L1vY5Ko+fBuTgvTvMIx6vN1Q=;
	b=mtZgU5EonH4yLuQb4IGbNkPiR6Px1ppWWDR1B+CJnQ/2Nzuu5ukKM7RjeWlVpMXOi3Km
	 UtwRFqH2g8H/J3/NMj7yfmekU0wof25Qjz0rikh4i7harjX7Y+UQMIadK9v6ToaB+drHo
	 LkxNHJENs00+JyGb9ehxzyZCIf7T3WTHJ6KXvQ5kSKGu2JjmFCLGy1x3oeLaGZEiGOuiw
	 B/7RxZeQY8p2Y4dxRU3IgS+opayTsVOb0BcstDjmF1KNO2QTfNZqerOIUH8IoTWE7ju5C
	 k6etqXYsquBv5V7a0vQ2XHGYak4bWKdKlWU9wtiAUb2L1mURivO836+TrhMRNiagATA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzJDiF4Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB12606A339;
	Sat,  7 Nov 2026 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzJDiF4Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA531F008A3;
	Sat,  7 Nov 2026 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065225;
	bh=uUYkIVx428SQ+5HhyT/L1vY5Ko+fBuTgvTvMIx6vN1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzJDiF4Y/ueWTNpDyHMandImJ8ig3El5obbU4jFvEHGBTU3dr+3sex1RdL/VW0i2i
	 F7vmvKiqJwA3t+PO4B5g+IXfJTEyx1TBP1rAK0gujfE56HkDqQLu77DgxdyoNegwxM
	 aXKENh/31ol9ki4yYa/qynpVX6Lif5LfVFg7v6AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1016/1257] cgroup/cpuset: Fix task checking when enabling a partition
Date: Sat,  7 Nov 2026 08:55:12 -0500
Message-ID: <20261107135007.396517912@linuxfoundation.org>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit f5b5cf2be574df6f25cbf1b000960340bff9a0bb ]

Creating a child partition can fail when tasks are present in its
descendants, even though the parent has no tasks of its own.

On a cgroup v2 system with CPUs 0-7 online:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir A
    echo 1-2 > A/cpuset.cpus
    echo root > A/cpuset.cpus.partition
    echo +cpuset > A/cgroup.subtree_control
    mkdir A/B
    echo 1-2 > A/B/cpuset.cpus
    echo +cpuset > A/B/cgroup.subtree_control
    mkdir A/B/C
    echo 1-2 > A/B/C/cpuset.cpus
    echo $$ > A/B/C/cgroup.procs
    echo root > A/B/cpuset.cpus.partition
    cat A/B/cpuset.cpus.partition
    root invalid (Parent unable to distribute cpu downstream)
    cat A/cpuset.cpus.effective
    1-2

B should be a valid root, leaving A with an empty effective CPU list.
The task in C belongs to B's partition and does not need CPUs in A.

partition_is_populated() is called with B as excluded_child, but
continue only skips B in the pre-order walk. The walk still visits C
and finds the task there, so A is considered populated.

Fix this by skipping the whole excluded subtree with
css_rightmost_descendant(), as is already done for valid child
partitions. Also add a test case to test_cpuset_prs.sh with a task in
a grandchild cpuset.

Fixes: b1bcaed1e39a ("cpuset: Treat cpusets in attaching as populated")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                            | 4 ++--
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8b220e9df91e9..86b5921998afa 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -478,10 +478,10 @@ static inline bool partition_is_populated(struct cpuset *cs,
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
-		if (cp == cs || cp == excluded_child)
+		if (cp == cs)
 			continue;
 
-		if (is_partition_valid(cp)) {
+		if (cp == excluded_child || is_partition_valid(cp)) {
 			pos_css = css_rightmost_descendant(pos_css);
 			continue;
 		}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 7efd5e645767c..f7cc9da57b556 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -385,6 +385,9 @@ TEST_MATRIX=(
 	# Enabling partition with child cpusets is allowed
 	"   C0-1    C1      .    C2-3    P1      .      .      .     0 A1:0-1|A2:1 A1:P1"
 
+	# Tasks below a new partition belong to it, not to its parent.
+	" C1-2:P1 C1-2 C1-2:T    .      .      P1     .      .     0 A1:|A2:1-2|A3:1-2 A1:P1|A2:P1"
+
 	# A partition root with non-partition root parent is invalid| but it
 	# can be made valid if its parent becomes a partition root too.
 	"   C0-1    C1      .    C2-3     .      P2     .      .     0 A1:0-1|A2:1 A1:P0|A2:P-2"
-- 
2.53.0



