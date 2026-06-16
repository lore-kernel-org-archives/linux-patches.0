Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6266044B69C;
	Tue, 16 Jun 2026 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625206; cv=none; b=u1mq79kc7lS8Gtn6zAc0C1r2XD6ePMxmS8HZljcPegSdvMTybdeTTveg/e3S0ldmHRUHPe7Nv2z2I/nBC5b5GS+cyi8lbLS31JZzDo+Z/uBEbMiMx6FMxC0He7VU1oGVdWBn0rxFrgnhVnXYGPz69zysZuor2FZrf4DyexgRaUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625206; c=relaxed/simple;
	bh=moFNeglWY3cZBjNVMCPayV7Kgz10kP8OVsmoH27JgFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1M1yeRxowRoAmjKkDt6Gzon2qrz7iuLFi90Hp0ukeF1kyYZxFBcqeWkNl0uBcnsAtviBIdxE1yr7aBkvdb/ZmLq01PdaKuralaRBjIzBKjW30OkPB9LWOR+M0odk/qH2Cr3omcxfCf41EWUxBvuR+mT5PjlUT61g5vDxfJkM7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DWzKm9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DWzKm9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A531F000E9;
	Tue, 16 Jun 2026 15:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625205;
	bh=zsQVQ4KwuONMlE8Byc+4rqcWmkqXWpoBbqVJJvms9l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2DWzKm9I/30+AHV+aRu6X4ZIzDu+gAgZxLl3FWLygTlTdwKewJj4GrLT/0SkrMOvs
	 vm4en3a8SiyhdrAN5UTH/OB0vrWRZEXcuuMnwjIKYVmPjDzf3gFZY8jAb8nLgTDS+T
	 1fIJNagyWhldIqlTYQQr+rjDXqoCu6dG+spESb7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/325] tools/rv: Fix substring match bug in monitor name search
Date: Tue, 16 Jun 2026 20:27:56 +0530
Message-ID: <20260616145101.711728433@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit a963fbf3166f2e178ac38b6c3c186a0c98092fb9 ]

__ikm_find_monitor_name() relies on strstr() to find a monitor by name,
which fails if the target monitor is a substring of a previously listed
monitor.

Fix it by tokenizing the available_monitors file and matching full
tokens instead.

Fixes: eba321a16fc6 ("tools/rv: Add support for nested monitors")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20260514152055.229162-2-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rv/src/in_kernel.c | 48 ++++++++++++++-------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv/src/in_kernel.c
index d324538249d3ab..95eac9ab148468 100644
--- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -58,38 +58,40 @@ static int __ikm_read_enable(char *monitor_name)
  */
 static int __ikm_find_monitor_name(char *monitor_name, char *out_name)
 {
-	char *available_monitors, container[MAX_DA_NAME_LEN+1], *cursor, *end;
-	int retval = 1;
+	char *available_monitors, *cursor, *line;
+	int len = strlen(monitor_name);
+	int found = 0;
 
 	available_monitors = tracefs_instance_file_read(NULL, "rv/available_monitors", NULL);
 	if (!available_monitors)
 		return -1;
 
-	cursor = strstr(available_monitors, monitor_name);
-	if (!cursor) {
-		retval = 0;
-		goto out_free;
-	}
+	config_is_container = 0;
+	cursor = available_monitors;
+	while ((line = strsep(&cursor, "\n"))) {
+		char *colon = strchr(line, ':');
 
-	for (; cursor > available_monitors; cursor--)
-		if (*(cursor-1) == '\n')
-			break;
-	end = strstr(cursor, "\n");
-	memcpy(out_name, cursor, end-cursor);
-	out_name[end-cursor] = '\0';
-
-	cursor = strstr(out_name, ":");
-	if (cursor)
-		*cursor = '/';
-	else {
-		sprintf(container, "%s:", monitor_name);
-		if (strstr(available_monitors, container))
-			config_is_container = 1;
+		if (strcmp(line, monitor_name) && (!colon || strcmp(colon + 1, monitor_name)))
+			continue;
+
+		strncpy(out_name, line, 2 * MAX_DA_NAME_LEN);
+		out_name[2 * MAX_DA_NAME_LEN - 1] = '\0';
+
+		if (colon) {
+			out_name[colon - line] = '/';
+		} else {
+			/* If there are children, they are on the next line. */
+			line = strsep(&cursor, "\n");
+			if (line && !strncmp(line, monitor_name, len) && line[len] == ':')
+				config_is_container = 1;
+		}
+
+		found = 1;
+		break;
 	}
 
-out_free:
 	free(available_monitors);
-	return retval;
+	return found;
 }
 
 /*
-- 
2.53.0



