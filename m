Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010D436B92A;
	Thu, 20 Aug 2026 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238526; cv=none; b=SNffLHuGQV4Evh5sn7xGmwChH8kVOfplhDRNXtuWj3dkLUp7Ex/U3hKhzop2Y+CM/LJza8yh9/M+Km/VVIZcTNo03HSGGyshNdfJ/A7/zcwOn34PfUciYvLcsjSMMCqleIhfL41mwq1pQEl/DYKLr6D1QYJtalyHNbe9CvTa7LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238526; c=relaxed/simple;
	bh=picoEkhZmyiVbn+1zDVB/g9q06Tj6XvkrLbrJGSyZoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmvx5Tmj473UFHJZhEyhDWI5aX7Yxf+4RA6eB2E6jesMf3Vy3qKf4ojTi+zVZxvmYRqjF8UNdyrUja61YmtnyKjVmo/l4adW8oD1GWhNDRmE/jsZk0Nfy7VtNFqe0tF0tYIeKAXHnPU/gBbP2M1F3T7SXYD7/Tr6AQS0hHt8lfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRndUIa9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRndUIa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE881F000E9;
	Thu, 20 Aug 2026 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238524;
	bh=FiWtSxhVwwBC5qGbKgsb03xWHpVAgEz4snMQ4MAnge4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRndUIa9W1qI6MNBI05mpD9dk9HoHCeLkhXqxSqa3uago7tVpeZH/w1Ukd2a/ONUU
	 E9xvIfxiUJ+TR4Mx84FwQOJbpPXrm2g0ZaK8qX8CCUicjmCC8dlFz3TMu9xUq1STm0
	 vBnHJk0SFjRLa93xY1wy4nKxCzqSStwMRR+EoWOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 177/228] perf: Reject exited events as group leaders
Date: Thu, 20 Aug 2026 16:55:19 +0200
Message-ID: <20260820145250.067224327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit fa091f46c3833fb22384f10eade2b4e1e1d0b278 ]

perf_event_remove_on_exec() sets remove-on-exec events to the EXIT state
and detaches their group relationships.  The event's file descriptor can
remain open, however, and perf_event_open() currently accepts that event
as a group leader because its early validation rejects only REVOKED and
DEAD events.

A new sibling can consequently be linked to the detached leader.  When
the leader is closed, perf_group_detach() observes that its
PERF_ATTACH_GROUP bit is already clear and skips the new sibling.  The
sibling then retains a group_leader pointer to the freed event.

Reject group leaders in the EXIT state.  Perform the check while holding
the shared context mutex so that an exec in the target task cannot detach
the leader between validation and group attachment.

[peterz: make the earlier test fully consistent]
Fixes: 037a3c43edfb ("perf/core: Detach event groups during remove_on_exec")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260806205655.75722-1-kylebot@openai.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3b4c43203210d..1a23ae67c3cc8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13942,7 +13942,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_fd;
 		}
 		group_leader = fd_file(group)->private_data;
-		if (group_leader->state <= PERF_EVENT_STATE_REVOKED) {
+		if (group_leader->state <= PERF_EVENT_STATE_EXIT) {
 			err = -ENODEV;
 			goto err_fd;
 		}
@@ -14073,6 +14073,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		if (group_leader->ctx != ctx)
 			goto err_locked;
 
+		/* Recheck under ctx::mutex to serialize against remove-on-exec. */
+		if (group_leader->state <= PERF_EVENT_STATE_EXIT) {
+			err = -ENODEV;
+			goto err_locked;
+		}
+
 		/*
 		 * Only a group leader can be exclusive or pinned
 		 */
-- 
2.53.0



