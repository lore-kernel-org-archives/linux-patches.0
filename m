Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F031A9B46;
	Thu, 28 May 2026 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001558; cv=none; b=ugmzzVCCkdm3YFPyo3TRMbzsFY3sl0JuABdNO3EC1IMeovfbuM+TQ19VDLRH+R0QhBVdxl+mjDlvQw5ey6lDVey81hG6x5/8tBkLLVd95wRNVjbQirDudqQRrFtLlLemkAq919bKbhFUWmoop82DRNPWGqmhT4q9O9z0aTY81ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001558; c=relaxed/simple;
	bh=J3xvSYRBnWNxM4AG5Ho81dNPa0N6ra72l+BYX/S9pM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh1vCoO+o+MgJ/C22p3D+2BDBSdY53n8e0dBla4RHqMtIk8mC/Cqs6KTx8bPNeIMYRUcTINeUlm7bBZmDBZbldKxCBLx+8V514HrKJb8bKC9PpAn3d/dtTBj9Ru2UD9VByUExTE56q7ODIUP3bDuNEnmIfPYWbfYCFqSVvGTndo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDLO+g6v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDLO+g6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C011F000E9;
	Thu, 28 May 2026 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001557;
	bh=iv5PFxoYEjljJfCcsx/Xv7rE8HsVpASZFCSL0eeo3+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDLO+g6vHs7XLsEH3XaMVoff+BZKMUlKMIUauZsvx8Ix7rCyJEWYtMLR7Qj77B2s5
	 9Y0QtmSpAuoXR0MldoKmVtr2ctuWEuniNAmgUTAI13fj/mnaE6achqJ6HeiLUtDYDN
	 5WmbJsJCl3a8IYf3Lobh4uXKGIHc//z5RYYmsug8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/186] tracing: Avoid NULL return from hist_field_name() on truncation
Date: Thu, 28 May 2026 21:50:50 +0200
Message-ID: <20260528194933.557720884@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
index 597f47397c726..59115079c7982 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1354,10 +1354,8 @@ static const char *hist_field_name(struct hist_field *field,
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



