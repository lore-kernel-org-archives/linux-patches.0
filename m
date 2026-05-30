Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDDF2E7389;
	Sat, 30 May 2026 18:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167213; cv=none; b=NAtVDi1wAEGNjO0ypV4z6W9OwUA9daMJqyU4gJbM3iuKAj6JItI/dEPbGTJezqGKRP5MOMk9Wj2L7XhEqWENREgER5xp815/uasV0aPNyG1Glq2cehEHqNuE6RzcNzbGduzdIcKA3QJaUOzK3eucOFfevpCLnRM0F1U7/Vj/b0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167213; c=relaxed/simple;
	bh=y87eI5IvivvqkTX3EGCHgGanuiI8pdObzkiVc11H7h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsMJPwm4FOLpa77f1B0lc2xNfd+30F2s0M+gDLT9ocg8MwxZw4m7MhDIIo8yjUk0R9ffL4/4vzfnry0on2WqhvRud8mbf0cm38z7ylAtD5Ug705oxPEml/zfrGvQGRrxAAXoPUy4pACjAyirNND/zoWBjapd/eFekj7A7qZeGDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6T4moYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6T4moYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F821F00898;
	Sat, 30 May 2026 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167212;
	bh=Bsd+xnVDahaK334acQfjAWBtxPmHA40KCucpcvP8HrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6T4moYi/R0JjGszVo0PagIOv04KzxNRnlmRP4c6dNlE8aupL68COPjT5oX37dPRD
	 PuIIiHy3A9xFrZ+7K9IdywDcmEprWpBr1zWOBJVQ2wwUGsjgepV0hksCbAR+XfPKCs
	 BBIpBNqezQnWra6xu0QZstAcgzsOOSf9t9riSc+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 584/589] tracing: Avoid NULL return from hist_field_name() on truncation
Date: Sat, 30 May 2026 18:07:45 +0200
Message-ID: <20260530160239.941734158@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 576ec047d20b368b43c4d5db98c4f2e0f3c101ec ]

hist_field_name() returns "" everywhere except the fully-qualified
VAR_REF/EXPR case, where snprintf() truncation returns NULL early
and bypasses the bottom NULL->"" guard. Callers don't expect NULL:
strcat(expr, hist_field_name(field, 0)) at trace_events_hist.c:1758
and the strcmp() in the sort-key match loop at :4804 both deref it.

system and event_name are bounded by MAX_EVENT_NAME_LEN, but the
field name on a VAR_REF is kstrdup'd from a histogram variable
name parsed out of the trigger string and has no length cap, so
a long enough var name in a fully qualified reference can reach
the truncation path.

Keep the length check but leave field_name as "" on overflow.

Link: https://patch.msgid.link/20260508195747.25492-1-devnexen@gmail.com
Fixes: 5ec1d1e97de1 ("tracing: Rebuild full_name on each hist_field_name() call")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 381d7e3989ada..32f9ab82a8810 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1105,10 +1105,8 @@ static const char *hist_field_name(struct hist_field *field,
 			len = snprintf(full_name, sizeof(full_name), "%s.%s.%s",
 				       field->system, field->event_name,
 				       field->name);
-			if (len >= sizeof(full_name))
-				return NULL;
-
-			field_name = full_name;
+			if (len < sizeof(full_name))
+				field_name = full_name;
 		} else
 			field_name = field->name;
 	} else if (field->flags & HIST_FIELD_FL_TIMESTAMP)
-- 
2.53.0



