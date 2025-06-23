Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1B813B58B;
	Mon, 23 Jun 2025 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684540; cv=none; b=KB1z/cq9TohAwkBL0Q7V5suMLLMVI2GvKdhbL+Sf/aeEtSf7sm7KXwgnedA70uA0lNc8d/wjCjMS47zK1RqIKR1miWsFi5b7UhUfaMrfgex5ZkmzP7UtTyACk2G9OyQZlkrJHqfP2XrCUBX6oKPol1W1UVT4W172SD0n0KJZuJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684540; c=relaxed/simple;
	bh=DAHTnrpzw2XHh5Wryws3WXm9gTGwjNPuqw0/mbsmvj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ro8huvU2o8ylhgJugEnBCFHiKpI8VVcNLTvkQjfb5cn0HG30I2tS/WawHzu2fM/GhDseo6XvGQvuIEzR27fwlRgX+FpcjfzUzR5g6yyl9C7PUJJT6JU+yBK8b1BC/EAaJod3uQDlhhIxWTJut0Zu/gvkoqjGVGpvIAmbONwmUOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW2CTRJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW2CTRJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C16C4CEEA;
	Mon, 23 Jun 2025 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684540;
	bh=DAHTnrpzw2XHh5Wryws3WXm9gTGwjNPuqw0/mbsmvj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW2CTRJkFOWqe8I6JY7frjpApSNjFpTzA5BxN9JhqSiFcjU+FqmyqsJpviG2CmueY
	 7co78FyoeUUtrMVhxihAFmI3riicklrjuBFvx0wPVYLTz+AEhaxNlppVt3dY2aKfCp
	 g4xj3soTJMBB0JtDcfKytStg/8KyiCng/c5OUTgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jiawei <zhongjiawei1@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.15 105/592] cgroup,freezer: fix incomplete freezing when attaching tasks
Date: Mon, 23 Jun 2025 15:01:03 +0200
Message-ID: <20250623130702.774926558@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,13 +188,12 @@ static void freezer_attach(struct cgroup
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
 


