Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478483F1AC7;
	Wed, 20 May 2026 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297113; cv=none; b=h3jk1fZcVz3GvM/UcIM0x14W/tadxDrdcn1vwPZKkmkJC6tBdnxPDtUcaAN1v4/ick59Aus+WwO8UngUtGbRUKMdjslC1i/sIh+zzw4l8ARxTzwISRT10lPJhh7IgQPmvl8K+5dkWi5UYLHv2S6bVqgHts//zv915ZOYJVWsSUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297113; c=relaxed/simple;
	bh=RdeTgsSu1oc8LZRTa3hgWApnxw5FhsxAWA9p7P+npk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHNiW69g0vbCNI5Ux6DOCZpGVvJe1CLniWXkvvvcIFg4f1bKPPRwYfICKixTd7HbEMaYShnq4I0GkC9CSErlSo3pkJDZeLfHqszMXZx6mMlFZlBnZq3cMndQCIhPIKxsodlm+dZvYrivk44tx/Mv1s2o+OD3iCJLvucDB/QZD8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfmavVpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfmavVpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC4D1F00896;
	Wed, 20 May 2026 17:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297112;
	bh=etA9w6VtCg4g3PHQf4Zjv5sXvKrvzNhPlKbGrxTt1i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfmavVppH1urWgNhMSwCXqKyPtv8eI8qTm3C66XK8diFBGc9giEWSCrqRXzIUvo+B
	 7DformW4LHhdadar5CjI3BVcHMR198d9xTpLjgbEIiEQXc3Z6Xw6ndDZwfsCd9eC26
	 DWCYuI2GrFG4KXUJu1IIzLcYf7VyFrWTqPhjDyu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sunshaojie <sunshaojie@kylinos.cn>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.0 1056/1146] cgroup/cpuset: Return only actually allocated CPUs during partition invalidation
Date: Wed, 20 May 2026 18:21:46 +0200
Message-ID: <20260520162212.132142809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sunshaojie <sunshaojie@kylinos.cn>

commit 345f40166694e60db6d5cf02233814bb27ac5dec upstream.

In update_parent_effective_cpumask() with partcmd_invalidate, the CPUs
to return to the parent are computed as:

    adding = cpumask_and(tmp->addmask, xcpus, parent->effective_xcpus);

where xcpus = user_xcpus(cs) which returns cs->exclusive_cpus (if set)
or cs->cpus_allowed. When exclusive_cpus is not set, user_xcpus(cs) can
contain CPUs that were never actually granted to the partition due to
sibling exclusion in compute_excpus(). Consequently, the invalidation
may return CPUs to the parent that remain in use by sibling partitions,
causing overlapping effective_cpus and triggering the
WARN_ON_ONCE(1) in generate_sched_domains().

Use cs->effective_xcpus instead, which reflects the CPUs actually
granted to this partition.

Reproducer (on a 4-CPU machine):

    cd /sys/fs/cgroup
    mkdir a1 b1

    # a1 becomes partition root with CPUs 0-1
    echo "0-1" > a1/cpuset.cpus
    echo "root" > a1/cpuset.cpus.partition

    # b1 becomes partition root with CPUs 1-2, but sibling exclusion
    # reduces its effective_xcpus to CPU 2 only
    echo "1-2" > b1/cpuset.cpus
    echo "root" > b1/cpuset.cpus.partition

    # b1 changes cpus_allowed to 0-1 -> partition invalidation
    echo "0-1" > b1/cpuset.cpus

    # Expected: CPUs 2-3  (only CPU 2 returned from b1)
    # Actual:   CPUs 1-3  (CPU 0-1 returned, overlapping with a1)
    cat cpuset.cpus.effective

dmesg will also show a WARNING from generate_sched_domains() reporting
overlapping partition root effective_cpus.

Fixes: 2a3602030d80 ("cgroup/cpuset: Don't invalidate sibling partitions on cpuset.cpus conflict")
Cc: stable@vger.kernel.org # v7.0+
Signed-off-by: sunshaojie <sunshaojie@kylinos.cn>
Tested-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1718,7 +1718,8 @@ static int update_parent_effective_cpuma
 		 */
 		if (is_partition_valid(parent))
 			adding = cpumask_and(tmp->addmask,
-					     xcpus, parent->effective_xcpus);
+					     cs->effective_xcpus,
+					     parent->effective_xcpus);
 		if (old_prs > 0)
 			new_prs = -old_prs;
 


