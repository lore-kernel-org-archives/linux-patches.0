Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7002E2FF155;
	Tue, 12 Aug 2025 18:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024975; cv=none; b=qDnpJpQH8t00rONe4QIfXp2xDfv7Up5A7Cf2Et63CXwVpWhlPqUG6oxfu7rUEY9wfNDGaqW2LVDj8iFDq7tD9VpulnDNsK05HkrAUqO4cVhag8U/EtWkrxh3hcF4A19SNaixczKFYgmB+eDtrfJM1V9olKC+Xd+G+IiBZVxKUqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024975; c=relaxed/simple;
	bh=AOuIgPWgdVhwTYv/Lp2NYmOrOpxj7dRhmekGd4rytao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWaFn7o1EyYCRcRv+InHBrwwB8IoypIpIKsf9AWOGN/h3OM3R85QGt+PEG2REip24HWs6qSlQk+NIie/CAVNB3kyXPo/Bi0FBdXrstvnWZo3g4Ae51l4UGC3uaFdrHxmd+WQvvolW4ukR9fGsQw/9dNK1VF5IKcc4FE02os3h5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZVsqneV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZVsqneV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9202C4CEF0;
	Tue, 12 Aug 2025 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024975;
	bh=AOuIgPWgdVhwTYv/Lp2NYmOrOpxj7dRhmekGd4rytao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZVsqneVDHvk6Mmq7bMrJ9wuUCZ2wFZTNoV7p2wmwV6z6WEgbVu8WliwWWb0LiVHs
	 GQwwsYOVw7TEdJ8Ohk8sGKyUkoYTWlC8KB6XpFgASWCNzvlu/9o97Fob+NVkcZsTcZ
	 S33V3tnA3VtezMhlKM0a12ieHTUa92/bDS6erE4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 525/627] block: Fix default IO priority if there is no IO context
Date: Tue, 12 Aug 2025 19:33:40 +0200
Message-ID: <20250812173451.866397153@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit e2ba58ccc9099514380c3300cbc0750b5055fc1c ]

Upstream commit 53889bcaf536 ("block: make __get_task_ioprio() easier to
read") changes the IO priority returned to the caller if no IO context
is defined for the task. Prior to this commit, the returned IO priority
was determined by task_nice_ioclass() and task_nice_ioprio(). Now it is
always IOPRIO_DEFAULT, which translates to IOPRIO_CLASS_NONE with priority
0. However, task_nice_ioclass() returns IOPRIO_CLASS_IDLE, IOPRIO_CLASS_RT,
or IOPRIO_CLASS_BE depending on the task scheduling policy, and
task_nice_ioprio() returns a value determined by task_nice(). This causes
regressions in test code checking the IO priority and class of IO
operations on tasks with no IO context.

Fix the problem by returning the IO priority calculated from
task_nice_ioclass() and task_nice_ioprio() if no IO context is defined
to match earlier behavior.

Fixes: 53889bcaf536 ("block: make __get_task_ioprio() easier to read")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250731044953.1852690-1-linux@roeck-us.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ioprio.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index b25377b6ea98..5210e8371238 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -60,7 +60,8 @@ static inline int __get_task_ioprio(struct task_struct *p)
 	int prio;
 
 	if (!ioc)
-		return IOPRIO_DEFAULT;
+		return IOPRIO_PRIO_VALUE(task_nice_ioclass(p),
+					 task_nice_ioprio(p));
 
 	if (p != current)
 		lockdep_assert_held(&p->alloc_lock);
-- 
2.39.5



