Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49CE15FA91;
	Mon, 27 May 2024 19:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837415; cv=none; b=cYtZjuAorHkvMe0OgBi3UTYR3eT03Rw+r+nHHx8AcWzmFPL0/xelZfIFCGeBTGNJi90FznQB3BxXsPVyCk9S1sRkzm1J9IjhWHCWnLTWKjDJ1laqjSNueOry7fiExHsnZXqc1VUThFmYX8cbw1m5tQeG0/qD6gMOKneIGK8MvW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837415; c=relaxed/simple;
	bh=n5aYAvZ+vrAPR4ywMo+im/UXGlOxhdRlKD5Jna+ZZho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V99e6BOriuTNMINarqcMyUieJUIAYHfznf6f144RMj8R14tWZmgHX0VTCnQc6qPyzdi2X2KNhp1RYWD+SULRFKW4a8CK/w239EwCs/kpKQ+0uc/dyTvA5ir+X78JrNeFpmOXT01rzWXOGuPea+Qb+td2mTsToOxu/dYT+BFE0RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5Frm0dZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5Frm0dZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4FFC2BBFC;
	Mon, 27 May 2024 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837415;
	bh=n5aYAvZ+vrAPR4ywMo+im/UXGlOxhdRlKD5Jna+ZZho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5Frm0dZpfQWZOmJ30XDlHuTDnfyl9GRkRLZqUWlMbqmAk/mcTSLPmdwYibRgQgnR
	 D/NaPMGlR+Vp04w//2TJEUybupznmmCmzKz19cKbNGlHm8mbGV/YI3MMvHk+si1bOh
	 8M7IJmv1P0LDU3KK60rXqOo9D4UfCH74k+P2i7XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 409/427] tracing/user_events: Fix non-spaced field matching
Date: Mon, 27 May 2024 20:57:36 +0200
Message-ID: <20240527185635.371056912@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit bd125a084091396f3e796bb3dc009940d9771811 ]

When the ABI was updated to prevent same name w/different args, it
missed an important corner case when fields don't end with a space.
Typically, space is used for fields to help separate them, like
"u8 field1; u8 field2". If no spaces are used, like
"u8 field1;u8 field2", then the parsing works for the first time.
However, the match check fails on a subsequent register, leading to
confusion.

This is because the match check uses argv_split() and assumes that all
fields will be split upon the space. When spaces are used, we get back
{ "u8", "field1;" }, without spaces we get back { "u8", "field1;u8" }.
This causes a mismatch, and the user program gets back -EADDRINUSE.

Add a method to detect this case before calling argv_split(). If found
force a space after the field separator character ';'. This ensures all
cases work properly for matching.

With this fix, the following are all treated as matching:
u8 field1;u8 field2
u8 field1; u8 field2
u8 field1;\tu8 field2
u8 field1;\nu8 field2

Link: https://lore.kernel.org/linux-trace-kernel/20240423162338.292-2-beaub@linux.microsoft.com

Fixes: ba470eebc2f6 ("tracing/user_events: Prevent same name but different args event")
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_user.c | 76 +++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 70d428c394b68..82b191f33a28f 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1989,6 +1989,80 @@ static int user_event_set_tp_name(struct user_event *user)
 	return 0;
 }
 
+/*
+ * Counts how many ';' without a trailing space are in the args.
+ */
+static int count_semis_no_space(char *args)
+{
+	int count = 0;
+
+	while ((args = strchr(args, ';'))) {
+		args++;
+
+		if (!isspace(*args))
+			count++;
+	}
+
+	return count;
+}
+
+/*
+ * Copies the arguments while ensuring all ';' have a trailing space.
+ */
+static char *insert_space_after_semis(char *args, int count)
+{
+	char *fixed, *pos;
+	int len;
+
+	len = strlen(args) + count;
+	fixed = kmalloc(len + 1, GFP_KERNEL);
+
+	if (!fixed)
+		return NULL;
+
+	pos = fixed;
+
+	/* Insert a space after ';' if there is no trailing space. */
+	while (*args) {
+		*pos = *args++;
+
+		if (*pos++ == ';' && !isspace(*args))
+			*pos++ = ' ';
+	}
+
+	*pos = '\0';
+
+	return fixed;
+}
+
+static char **user_event_argv_split(char *args, int *argc)
+{
+	char **split;
+	char *fixed;
+	int count;
+
+	/* Count how many ';' without a trailing space */
+	count = count_semis_no_space(args);
+
+	/* No fixup is required */
+	if (!count)
+		return argv_split(GFP_KERNEL, args, argc);
+
+	/* We must fixup 'field;field' to 'field; field' */
+	fixed = insert_space_after_semis(args, count);
+
+	if (!fixed)
+		return NULL;
+
+	/* We do a normal split afterwards */
+	split = argv_split(GFP_KERNEL, fixed, argc);
+
+	/* We can free since argv_split makes a copy */
+	kfree(fixed);
+
+	return split;
+}
+
 /*
  * Parses the event name, arguments and flags then registers if successful.
  * The name buffer lifetime is owned by this method for success cases only.
@@ -2012,7 +2086,7 @@ static int user_event_parse(struct user_event_group *group, char *name,
 		return -EPERM;
 
 	if (args) {
-		argv = argv_split(GFP_KERNEL, args, &argc);
+		argv = user_event_argv_split(args, &argc);
 
 		if (!argv)
 			return -ENOMEM;
-- 
2.43.0



