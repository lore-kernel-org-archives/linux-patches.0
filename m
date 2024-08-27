Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9881A072D;
	Tue, 27 Aug 2024 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771623; cv=none; b=A/VcZwowK5wfz4iz9Y0asP68sxyLIyT6rgygSND1ch8M5pwniKv7iKHEqcaZ1qvti2n/bNcyS8PBobEpsn6Cwn3fI9BkAdcwQ63zQFQQnKRrKGZJNouZrwD6CgsoFbpmA/M1tiKR/QFAlwNLlWAXGUzz4xjsaOWvs7PYoA+011A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771623; c=relaxed/simple;
	bh=rxfhOWx1NWaVkZwHrk+0fQes72/CrAtaVMVHeoVYXOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm08lgPEbVZv4FBKkSOExEKoUuGXnSNnTTw5aEImVWEBffU8jAkOi3hc7zv3IcF2vDqVK94Od1mbLkFfWWNsfeRRIth0dIeDgrgpCC5g8pnLLSkyN3xRQJy+U5694C/v/ZtSlrzB5WhBwIaGe8xq7lE1TG7rPU2V+brBh6JtYUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmM3NS/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmM3NS/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5A9C6105F;
	Tue, 27 Aug 2024 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771622;
	bh=rxfhOWx1NWaVkZwHrk+0fQes72/CrAtaVMVHeoVYXOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmM3NS/QS8g6MY+Hiy2I2pEBGRF67iQXXLopIS7dgguBWyoNtmGGbZL8d3lEc7wGn
	 a+1vEOu7aATrl/Yr2xH81efIcXD2p5d7SMyNMqkVzKdA+c8tjPYm2wGFsei5fvRRpW
	 GnrzfbFMR+CGf8V11Tk8Y9L5DReWguHi20L8d1no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.10 245/273] cgroup/cpuset: Clear effective_xcpus on cpus_allowed clearing only if cpus.exclusive not set
Date: Tue, 27 Aug 2024 16:39:29 +0200
Message-ID: <20240827143842.726795656@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit 311a1bdc44a8e06024df4fd3392be0dfc8298655 upstream.

Commit e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for
v2") adds a user writable cpuset.cpus.exclusive file for setting
exclusive CPUs to be used for the creation of partitions. Since then
effective_xcpus depends on both the cpuset.cpus and cpuset.cpus.exclusive
setting. If cpuset.cpus.exclusive is set, effective_xcpus will depend
only on cpuset.cpus.exclusive.  When it is not set, effective_xcpus
will be set according to the cpuset.cpus value when the cpuset becomes
a valid partition root.

When cpuset.cpus is being cleared by the user, effective_xcpus should
only be cleared when cpuset.cpus.exclusive is not set. However, that
is not currently the case.

  # cd /sys/fs/cgroup/
  # mkdir test
  # echo +cpuset > cgroup.subtree_control
  # cd test
  # echo 3 > cpuset.cpus.exclusive
  # cat cpuset.cpus.exclusive.effective
  3
  # echo > cpuset.cpus
  # cat cpuset.cpus.exclusive.effective // was cleared

Fix it by clearing effective_xcpus only if cpuset.cpus.exclusive is
not set.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Cc: stable@vger.kernel.org # v6.7+
Reported-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2474,7 +2474,8 @@ static int update_cpumask(struct cpuset
 	 */
 	if (!*buf) {
 		cpumask_clear(trialcs->cpus_allowed);
-		cpumask_clear(trialcs->effective_xcpus);
+		if (cpumask_empty(trialcs->exclusive_cpus))
+			cpumask_clear(trialcs->effective_xcpus);
 	} else {
 		retval = cpulist_parse(buf, trialcs->cpus_allowed);
 		if (retval < 0)


