Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6E93815DD;
	Thu, 20 Aug 2026 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239172; cv=none; b=PpP5cREI0WmrowjiSB/WZI0PnolyqosGagQ0YbyiU/ObCog8+9SWfD4XKSGG4YdPB8NG9iZWwRtsw7wIHrlxbGeRL4zyXm1TBU2sbj0jtYbyXYqyhD1m8zgqs1YUeTNN8l7MtPmsVs6JwlqyNxv1j9OVfdK2N0KIPDxePiOmM/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239172; c=relaxed/simple;
	bh=jb9JGTPsAB3uZ42MIsEgbZepLcaQuTEosJOsXGgFpCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHZYxPWTbBFmFJkT4KrY7J97AAPnnzMU8ned0SvD4f26Sjd1mY0KhV+iPTP6H3X/C2gTjQf6War7zqztlaOoLucJRh9okYAl0ulEE0unLOxAVLytMgBuN35BfwshOoxfQyti8SY8utQuZA3VlLUU+Ekov63duN0OIUAzRZ7IK+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neN85JLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neN85JLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A151F00A3A;
	Thu, 20 Aug 2026 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239171;
	bh=kDzGErAJxKDk0sj/Qiy/Fx5fbthioa4mm/L3zH7A3Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=neN85JLMVNMDSdbVQZpiOJENYRfNna/rjluMTv4P6tcOEmQi7ZySYaY3Hp81Nqqq7
	 uIb2XxicMZ/M8hgBSnHu+3alZ2juskvBmtWk0GCF7B1RKwV4N8XnZMyddPFs0xQHx0
	 wvhOXSu6BgIeb+aEuR+uJn2OTwpfW9IyNGSmvLew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/217] perf: Reject exited events as group leaders
Date: Thu, 20 Aug 2026 16:55:43 +0200
Message-ID: <20260820145243.002999088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d64f8edeaf8b8..04c9d49150931 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13549,7 +13549,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_fd;
 		}
 		group_leader = fd_file(group)->private_data;
-		if (group_leader->state <= PERF_EVENT_STATE_REVOKED) {
+		if (group_leader->state <= PERF_EVENT_STATE_EXIT) {
 			err = -ENODEV;
 			goto err_fd;
 		}
@@ -13680,6 +13680,12 @@ SYSCALL_DEFINE5(perf_event_open,
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



