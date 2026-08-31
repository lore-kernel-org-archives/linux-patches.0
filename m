Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E664347ACC3;
	Mon, 31 Aug 2026 13:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184498; cv=none; b=qr/TUEjCjs6E7LQGS4qJAG/HQV3bU5+kbDuRrenPMmATK9fNsDyXx0PWaZ9smznNcdiqYeDoX9KNDcjd1fWVHQHGHybIQOISxQpZknIWl6ujISYu2isS+KPiIKFdm10V99Jg/DcNIHt5ClLaS3MWu2vBOrR/OWHHYKek4fodavw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184498; c=relaxed/simple;
	bh=jiN9qM2y0zoXefmmjPq95J2LCG4r/UGiECxMtBJ47wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxnEQUxHYlPePUmd8SFFr2Nr3V66aoSJ5K03CkM5YYelJXgrjBl0WbkqEDufbgQWPKxGtL90IzqTzgY+K0R6Dok13QrlPWfS6JoRr9MmtcXcKmM/Z8ACp2phVKE+les0G3sUzUhO56LD328u3cHybaMbaHc+7jYii+WNF5VJ1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZEvRlL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZEvRlL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D13E1F00A3D;
	Mon, 31 Aug 2026 13:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184496;
	bh=BHN22svFb8r5jQpulQMbWEEA/mkvRwoczlqRtI0B4fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZEvRlL4Jw+7HXXP7OwyNCXFJiBf1UVTMYLrKTQFGI04V78+pfQzCwHKk0oOL4ISS
	 kDXCkMUm7/UoFMWGs1xENwOiYIAFRtz7vbc1mOKZeEFEnYLQnvG9Wjao6ZIKrY4rui
	 5KqplCTzbyBzPXfagsBOtHpK+7KtbyxJjIKk5pEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/91] perf: Reject exited events as group leaders
Date: Mon, 31 Aug 2026 15:33:55 +0200
Message-ID: <20260831133359.892598129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/events/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3f86104eb4c5a..95743e6c5b0cb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12692,6 +12692,10 @@ SYSCALL_DEFINE5(perf_event_open,
 		if (err)
 			goto err_fd;
 		group_leader = group.file->private_data;
+		if (group_leader->state <= PERF_EVENT_STATE_EXIT) {
+			err = -ENODEV;
+			goto err_group_fd;
+		}
 		if (flags & PERF_FLAG_FD_OUTPUT)
 			output_event = group_leader;
 		if (flags & PERF_FLAG_FD_NO_GROUP)
@@ -12819,6 +12823,12 @@ SYSCALL_DEFINE5(perf_event_open,
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



