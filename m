Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A4F2628C;
	Mon, 23 Jun 2025 21:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713825; cv=none; b=Fb0v9dANmBbd3kVfGftmCbQySFliHfDau3MC64y4u7W6Hszb2zFXVbUF9sI3A4b80D+kCuwE1ZosCLFiYv7Sv9TL8h0/lrhu3xURkKAKsnCoRvhHzLAGXGKiUuGbCoUGbT21PtB0FzbygC1H63NQmPDHI+nlZ3kWpIFrB8lU7o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713825; c=relaxed/simple;
	bh=49/os9vUMixhACmvNvg2EyYvSOgoQLQjEKCFG4zPaFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQWW4cH8u9MNLoHB2x/OtM5uunT45IpSmF5+SV2k1gxR5A8YWn3bx5k9pOtOgqgaa+BnAJ+5oKsk+JhiZlY7vjDGMcPNfs7tUAv+PrLX8i/Bx2HpifAiiYEr1uWGlX9PhCePF+NpLYO6GgXY43RPipBVwNJCn2snVazs6ysokwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ak1QIIiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ak1QIIiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108A9C4CEEA;
	Mon, 23 Jun 2025 21:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713825;
	bh=49/os9vUMixhACmvNvg2EyYvSOgoQLQjEKCFG4zPaFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak1QIIiSWgQoMojGHL6ZsPFYRmC0krW5h39JHzsD9/mty2QX1yrFuDhrQER/kyU3w
	 ImEa52QDNvWDhIo3uRo/eZWt1S3dw7BbsfSFQ6YtKtPQgcf8zwylLbga3fsMfMvv4F
	 k31rU3srD5zYTpkMOtbCVeNovGgQ44HxoXNtKMUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jiawei <zhongjiawei1@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 085/414] cgroup,freezer: fix incomplete freezing when attaching tasks
Date: Mon, 23 Jun 2025 15:03:42 +0200
Message-ID: <20250623130644.209593991@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


