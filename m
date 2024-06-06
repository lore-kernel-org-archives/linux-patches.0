Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6109619B5AC;
	Thu,  6 Jun 2024 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683432; cv=none; b=dU9vDoO09fm8e1kkL5uh/SYmcEFr5DVsIGiaLVokNrZcVgVSxEiYedakGbtsaBTp8riyCW2lAX/xJygedx15R+13MfLmRYVD8xW8z6zPpk2ylwjm7pBwQ9dXj9SXl61qhZyHRHeSkOtJr7tumzOCcUcTIh+XY39gf7PYw+I0vws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683432; c=relaxed/simple;
	bh=1yV3Ev/nUyKCxHLd86PeJrcsulAylbtkd/psgjoMx2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttwhjsMu5au1Ig8rsGgkqlSAnBD869JUbiuFl75frSQnlMqtvUryFGBCuiUsKOqUIoC6XmyE+MpmAdDlRv52gHwfXJfy4W7kJgPZibpX/lCarY6SLEDrJv2H+0x8BqR9NBOmFr9lm801w1SoUHHQjWT+RG30y+3ldIMZLUQHaz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRJUeyBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRJUeyBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36932C32781;
	Thu,  6 Jun 2024 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683432;
	bh=1yV3Ev/nUyKCxHLd86PeJrcsulAylbtkd/psgjoMx2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRJUeyBx07+LVyzPtfhcjHtpo7h1MwO20mL0polnqsTzEz3NqvukJe0OuckMIgQtZ
	 Zos2lovP4Q8QxN58HQhudaHrzykcQi+anykq2C0pkHFb/Umnh5DmpQIaQciXup/Ujr
	 jkOYEzdnLhaPkDlGRrX3Y/Rv4NLfV0EGOKC/SxYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 377/744] tracing/user_events: Allow events to persist for perfmon_capable users
Date: Thu,  6 Jun 2024 16:00:49 +0200
Message-ID: <20240606131744.566771087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit 5dbd04eddb2c0841d1b3930e0a9944a2343c9cac ]

There are several scenarios that have come up where having a user_event
persist even if the process that registered it exits. The main one is
having a daemon create events on bootup that shouldn't get deleted if
the daemon has to exit or reload. Another is within OpenTelemetry
exporters, they wish to potentially check if a user_event exists on the
system to determine if exporting the data out should occur. The
user_event in this case must exist even in the absence of the owning
process running (such as the above daemon case).

Expose the previously internal flag USER_EVENT_REG_PERSIST to user
processes. Upon register or delete of events with this flag, ensure the
user is perfmon_capable to prevent random user processes with access to
tracefs from creating events that persist after exit.

Link: https://lkml.kernel.org/r/20230912180704.1284-2-beaub@linux.microsoft.com

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: bd125a084091 ("tracing/user_events: Fix non-spaced field matching")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/user_events.h | 11 +++++++++-
 kernel/trace/trace_events_user.c | 36 +++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/user_events.h b/include/uapi/linux/user_events.h
index 2984aae4a2b4f..f74f3aedd49ce 100644
--- a/include/uapi/linux/user_events.h
+++ b/include/uapi/linux/user_events.h
@@ -17,6 +17,15 @@
 /* Create dynamic location entry within a 32-bit value */
 #define DYN_LOC(offset, size) ((size) << 16 | (offset))
 
+/* List of supported registration flags */
+enum user_reg_flag {
+	/* Event will not delete upon last reference closing */
+	USER_EVENT_REG_PERSIST		= 1U << 0,
+
+	/* This value or above is currently non-ABI */
+	USER_EVENT_REG_MAX		= 1U << 1,
+};
+
 /*
  * Describes an event registration and stores the results of the registration.
  * This structure is passed to the DIAG_IOCSREG ioctl, callers at a minimum
@@ -33,7 +42,7 @@ struct user_reg {
 	/* Input: Enable size in bytes at address */
 	__u8	enable_size;
 
-	/* Input: Flags for future use, set to 0 */
+	/* Input: Flags to use, if any */
 	__u16	flags;
 
 	/* Input: Address to update when enabled */
diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index b87f41187c6a9..9365ce4074263 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -49,18 +49,6 @@
 #define EVENT_STATUS_PERF BIT(1)
 #define EVENT_STATUS_OTHER BIT(7)
 
-/*
- * User register flags are not allowed yet, keep them here until we are
- * ready to expose them out to the user ABI.
- */
-enum user_reg_flag {
-	/* Event will not delete upon last reference closing */
-	USER_EVENT_REG_PERSIST		= 1U << 0,
-
-	/* This value or above is currently non-ABI */
-	USER_EVENT_REG_MAX		= 1U << 1,
-};
-
 /*
  * Stores the system name, tables, and locks for a group of events. This
  * allows isolation for events by various means.
@@ -220,6 +208,17 @@ static u32 user_event_key(char *name)
 	return jhash(name, strlen(name), 0);
 }
 
+static bool user_event_capable(u16 reg_flags)
+{
+	/* Persistent events require CAP_PERFMON / CAP_SYS_ADMIN */
+	if (reg_flags & USER_EVENT_REG_PERSIST) {
+		if (!perfmon_capable())
+			return false;
+	}
+
+	return true;
+}
+
 static struct user_event *user_event_get(struct user_event *user)
 {
 	refcount_inc(&user->refcnt);
@@ -1811,6 +1810,9 @@ static int user_event_free(struct dyn_event *ev)
 	if (!user_event_last_ref(user))
 		return -EBUSY;
 
+	if (!user_event_capable(user->reg_flags))
+		return -EPERM;
+
 	return destroy_user_event(user);
 }
 
@@ -1926,10 +1928,13 @@ static int user_event_parse(struct user_event_group *group, char *name,
 	int argc = 0;
 	char **argv;
 
-	/* User register flags are not ready yet */
-	if (reg_flags != 0 || flags != NULL)
+	/* Currently don't support any text based flags */
+	if (flags != NULL)
 		return -EINVAL;
 
+	if (!user_event_capable(reg_flags))
+		return -EPERM;
+
 	/* Prevent dyn_event from racing */
 	mutex_lock(&event_mutex);
 	user = find_user_event(group, name, &key);
@@ -2062,6 +2067,9 @@ static int delete_user_event(struct user_event_group *group, char *name)
 	if (!user_event_last_ref(user))
 		return -EBUSY;
 
+	if (!user_event_capable(user->reg_flags))
+		return -EPERM;
+
 	return destroy_user_event(user);
 }
 
-- 
2.43.0



