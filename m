Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589FB226888;
	Mon, 23 Jun 2025 22:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716505; cv=none; b=X5HXkRCeA5/rOts6NufVoeoCQsPRpdh4V6qCF3APd3DM2pAlUdnQ2AsOAYy3eAHwH6axWOGyfbIEynHn2WWX4WNFtVBbr3vJNE0Ouaf+qQ3Gft7UGipLmXj2giUh/jJivWl1GGASr80LkEam9oFWFVkx2NUts17Wva5dYzUfiM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716505; c=relaxed/simple;
	bh=E7gdCf5ui8AxWDX87PVCiMab+sy5vaaf8jv3z5rPN8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lno8uEIJnNoDc60scEqKkiqrs6PQDy2AnUNI0sjky4bLjFCUYSVOJ6U6AWDvune9T6DExB8svGHoXO8aLAPRQVFm4UD/H1nBtFaFawgME2Qrw+TF2Jj0Y1V4O6Pm7JVUrSimVLu0JZ5tsTh2AMWW0WyUOJBJcVzHDgLm5xqc0fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/G6CKIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/G6CKIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F18C4CEED;
	Mon, 23 Jun 2025 22:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716505;
	bh=E7gdCf5ui8AxWDX87PVCiMab+sy5vaaf8jv3z5rPN8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/G6CKIlyG2OyplXx7/YVmoCoEvmcxedxT3+6tGt4+JHNrQszovYyb4PXcIhsQZrE
	 fc95R0iEkj0IMSapbf2chnmOYU3UIEHXbx0ds7IKqVn0lIw2npRHVwkiPXVmcg0Sg1
	 mvBCASSR0gRjKyVLMs2HuEgNa2fA55Y82+ukN7Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jiawei <zhongjiawei1@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 330/508] cgroup,freezer: fix incomplete freezing when attaching tasks
Date: Mon, 23 Jun 2025 15:06:15 +0200
Message-ID: <20250623130653.445925333@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

commit 37fb58a7273726e59f9429c89ade5116083a213d upstream.

An issue was found:

	# cd /sys/fs/cgroup/freezer/
	# mkdir test
	# echo FROZEN > test/freezer.state
	# cat test/freezer.state
	FROZEN
	# sleep 1000 &
	[1] 863
	# echo 863 > test/cgroup.procs
	# cat test/freezer.state
	FREEZING

When tasks are migrated to a frozen cgroup, the freezer fails to
immediately freeze the tasks, causing the cgroup to remain in the
"FREEZING".

The freeze_task() function is called before clearing the CGROUP_FROZEN
flag. This causes the freezing() check to incorrectly return false,
preventing __freeze_task() from being invoked for the migrated task.

To fix this issue, clear the CGROUP_FROZEN state before calling
freeze_task().

Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Cc: stable@vger.kernel.org # v6.1+
Reported-by: Zhong Jiawei <zhongjiawei1@huawei.com>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/legacy_freezer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -189,13 +189,12 @@ static void freezer_attach(struct cgroup
 		if (!(freezer->state & CGROUP_FREEZING)) {
 			__thaw_task(task);
 		} else {
-			freeze_task(task);
-
 			/* clear FROZEN and propagate upwards */
 			while (freezer && (freezer->state & CGROUP_FROZEN)) {
 				freezer->state &= ~CGROUP_FROZEN;
 				freezer = parent_freezer(freezer);
 			}
+			freeze_task(task);
 		}
 	}
 


