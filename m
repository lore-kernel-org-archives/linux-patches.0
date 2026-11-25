Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622749;
	b=RTPCg/ZvS90o2yVNGbj0GgWy+SedAzdPjj01OC/2ZpSlPOWeivLCu2C5HP7BxdaYlMyW
	 I0iEmh8dvV9LYAOwgIU8Dhmu/uKqVAU+Ty4Ga9wghWAPYjGLsTgCCwiihz4pe4LjJt3wq
	 1UecvVs0ycp6kSifAKZrSEPkURHRmCuq5CFABdAnbQYotj1bBTeF04+KF3ml0v/2XzvFX
	 oavhiwrSlAi7aGHUdRY25Ml+hhlCHB7qFHPuj9ME1PVVLFZmMMSR7Nd4iigYqk980GkSH
	 QuVgVaIX0a36IfTsNJ0PKf3ouhuIcHhCKndrz+aASD9+jphXFdlJMrT/qn9GNWOdgTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQ0boDYWF9Q805URnFrtW07TM6A6NKvmZMQtUxpWOEw=;
	b=cgDYTZlp3S3KxKQPevRXIviZhotd1GKXPp4as7rCW/WRV5IqU5+/cK4NCUNfB1FELzKN
	 VER8CsUJjrr3jDg1pBBCHZJWubmVn1b7+OADw4Rxo4HebFzDxRsXPwg/KkzrWulM154uW
	 /fFAGzleM0+SaAloleSJSVuLpL5tpv98I/WpCXgQEZ04+p2NU/zjhn4wZKt/gIzrSe1sw
	 UNss1DtmPohcFnRnFA/veS/ICKXdmnBtidqTOJ1yBOf3ueYfOQ1Zjon8idR4dGbAfNskF
	 Qp+YA73tZ+90NxNQE8r5c7fwIvjKLJrtZKnmr8no8S/cnFhb+A5z07TtGCoIxUf04SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vPp/ggKk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47992606A31E;
	Wed, 25 Nov 2026 16:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vPp/ggKk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068D91F000C6;
	Wed, 25 Nov 2026 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622748;
	bh=IQ0boDYWF9Q805URnFrtW07TM6A6NKvmZMQtUxpWOEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPp/ggKkb3S18jsuASYRjHIJw0sU4VgCsYor7O06pMVhah2O91jbENT4hOieKDvZe
	 Jq63rYSFJnAcUEuc2MYxCRX2xVvkFvOOn3wRKPhfv8ajWSCpxmT7VNDR5vRXNcIwo0
	 QBAxRVPl1V+mMsNnkKNAaUYCzg2uQJ+aIbYtWEeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 633/990] cgroup/cpuset: Release invalid isolated CPUs with a shrunk root partition parent
Date: Wed, 25 Nov 2026 15:33:20 +0100
Message-ID: <20261125143836.924514281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit ec0254b9eb49ebc9383dc3ae5cb69c8606f88499 ]

It is also reported by sashiko that there may be leakages of isolated
CPUs when a root partition parent shrinks its effective_xcpus with
isolated partition children. Leakage here means that isolated_cpus may
contain extra CPUs that are not in any isolated partitions and not boot
time isolated. Those CPUs cannot be used in any isolated partitions
anymore.

There are 2 different cases here. The effective_xcpus becomes empty and
the isolated partition should be invalidated in this case. Alternatively
some of its effective_xcpus are not in parent's effective xcpus but
still have some valid effective_xcpus left. The isolated partition can
remain valid. In both cases, the invalid isolated CPUs will have to be
released from isolated_cpus if appropriate.

Fix that by calling isolated_cpus_release() to release those isolated
CPUs from isolated_cpus.

New test cases are added to test_cpuset_prs.sh to test this.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Test-matrix rows use this tree's explicit :S+ syntax, and a stray # comment line was added by conflict resolution; the cpuset.c change itself matches upstream apart from line offsets. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                           | 16 +++++++++++++++-
 .../testing/selftests/cgroup/test_cpuset_prs.sh  |  7 +++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 084cee4e789d5..91a3fa0cf801a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2072,8 +2072,22 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 *
 		 * A partition error happens when parent has tasks and all
 		 * its effective CPUs will have to be distributed out.
+		 *
+		 * For an isolated partition with a shrunk root partition parent
+		 * we may need to return some or all of its isolated CPUs.
 		 */
-		if (nocpu || cpumask_empty(tmp->delmask)) {
+		nocpu |= cpumask_empty(tmp->delmask);
+		if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED)) {
+			cpumask_clear(tmp->addmask);
+			if (nocpu)
+				cpumask_copy(tmp->addmask, cs->effective_xcpus);
+			else if (!cpumask_subset(cs->effective_xcpus, parent->effective_xcpus))
+				cpumask_andnot(tmp->addmask, cs->effective_xcpus,
+							     parent->effective_xcpus);
+			if (!cpumask_empty(tmp->addmask))
+				isolated_cpus_release(cs, tmp->addmask);
+		}
+		if (nocpu) {
 			part_error = PERR_NOCPUS;
 			if (is_partition_valid(cs))
 				adding = cpumask_and(tmp->addmask,
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 9a1590e630e6b..25eef20c17466 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -435,6 +435,13 @@ TEST_MATRIX=(
 	# its effective xcpus will be removed from isolated_cpus.
 	"C1-4:P1:S+ C3-4:P2 .      .    T:C3-4   .      .      .     0 A1:3-4|A2:3-4 A1:P1|A2:P-2 ."
 
+	# When a root partition parent with an isolated partition child is shrunk
+	# so that its effective xcpus is no longer a superset of its child effective
+	# xcpus, the invalid isolated CPUs should be removed from cpuset.cpus.isolated.
+	"C1-4:P1:S+ C3-4:P2 .      .    T:C4-6   .      .      .     0 A1:5-6|A2:4 A1:P1|A2:P2 4"
+	"C1-4:P1:S+ C1-2:P2 .      .    T:C4-6   .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
+
+	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
 	# Failure cases:
-- 
2.53.0



