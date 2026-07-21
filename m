Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BD346D2D2;
	Tue, 21 Jul 2026 19:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661757; cv=none; b=IepwLEr1lpIMvIptszz3Bi4WeIfuqgZkDRqW+XsGd4EbDZ548pc0USJWK+3pUqck7k3V10oRuKa1bmlkuAyifVGlrIN+lfsJZZyi4QaHbyYVlzI0tsg/jh08bEZPZn7BGYVBthMHgeMaCzUczMQTJ0Xw+T7nXfyGCCnNoWKz+go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661757; c=relaxed/simple;
	bh=d1Vje5y8qSK+l2SWc4aQVEaofZqz6EXsaKD7BbtkcLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2Bb77ceriE8+QzFy/BRyL0C4HDLMjyQvhhacinSI/cbK4rYZQRvecfXwykeFRDBRB7jn5N6H/DeDoZ30R+hYY+ACkixxnwETzsNS5IaSfk2RV/fcfppmzd5OQkCPvY0bPiTgMXCUcbBpfwKYC/5BOPspER3cW+83aR0FClVT7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOsTqmtV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOsTqmtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08551F000E9;
	Tue, 21 Jul 2026 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661755;
	bh=LevQjvdTaJtlHVRLMd3r4nD6onAzpFrWHt46kgOsw3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOsTqmtVwzNTO+QX1Vamt21YQhTE4HiWV2S2otZQHuGotK9WGpptQuuz8Gy3VLA0k
	 78kDMSrm6peG8ewKLzj9dmGDcGQV9lLhvQwIcSKzWiwa6pMZs0hBOhnea2/SCDtzGn
	 UxMEUwkswLTrXi6+AlhNKWgzdYKOsGrgp4mUWQM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Tom Zanussi <zanussi@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0143/1276] tracing: Bound synthetic-field strings with seq_buf
Date: Tue, 21 Jul 2026 17:09:46 +0200
Message-ID: <20260721152449.301374154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f07883450eb14d1cf020b55d9f3a7ec5683bcd26 ]

The synthetic field helpers build a prefixed synthetic variable name and
a generated hist command in fixed MAX_FILTER_STR_VAL buffers. The
current code appends those strings with raw strcat(), so long key lists,
field names, or saved filters can run past the end of the staging
buffers.

Build both strings with seq_buf and propagate -E2BIG if either the
synthetic variable name or the generated command exceeds
MAX_FILTER_STR_VAL. This keeps the existing tracing-side limit while
using the helper intended for bounded command construction.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: https://patch.msgid.link/20260430043350.57928-1-pengpeng@iscas.ac.cn
Fixes: 02205a6752f2 ("tracing: Add support for 'field variables'")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
[ sdr: Moved struct seq_buf *s for upside-down x-mas tree formatting ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 41 ++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 2a1e3537332d5d..145070bbcda7d5 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/security.h>
+#include <linux/seq_buf.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/stacktrace.h>
@@ -2936,13 +2937,22 @@ find_synthetic_field_var(struct hist_trigger_data *target_hist_data,
 {
 	struct hist_field *event_var;
 	char *synthetic_name;
+	struct seq_buf s;
 
 	synthetic_name = kzalloc(MAX_FILTER_STR_VAL, GFP_KERNEL);
 	if (!synthetic_name)
 		return ERR_PTR(-ENOMEM);
 
-	strcpy(synthetic_name, "synthetic_");
-	strcat(synthetic_name, field_name);
+	seq_buf_init(&s, synthetic_name, MAX_FILTER_STR_VAL);
+	seq_buf_printf(&s, "synthetic_%s", field_name);
+
+	/* Terminate synthetic_name with a NUL. */
+	seq_buf_str(&s);
+
+	if (seq_buf_has_overflowed(&s)) {
+		kfree(synthetic_name);
+		return ERR_PTR(-E2BIG);
+	}
 
 	event_var = find_event_var(target_hist_data, system, event_name, synthetic_name);
 
@@ -2988,6 +2998,7 @@ create_field_var_hist(struct hist_trigger_data *target_hist_data,
 	struct hist_field *key_field;
 	struct hist_field *event_var;
 	char *saved_filter;
+	struct seq_buf s;
 	char *cmd;
 	int ret;
 
@@ -3032,28 +3043,34 @@ create_field_var_hist(struct hist_trigger_data *target_hist_data,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	seq_buf_init(&s, cmd, MAX_FILTER_STR_VAL);
+
 	/* Use the same keys as the compatible histogram */
-	strcat(cmd, "keys=");
+	seq_buf_puts(&s, "keys=");
 
 	for_each_hist_key_field(i, hist_data) {
 		key_field = hist_data->fields[i];
 		if (!first)
-			strcat(cmd, ",");
-		strcat(cmd, key_field->field->name);
+			seq_buf_putc(&s, ',');
+		seq_buf_puts(&s, key_field->field->name);
 		first = false;
 	}
 
 	/* Create the synthetic field variable specification */
-	strcat(cmd, ":synthetic_");
-	strcat(cmd, field_name);
-	strcat(cmd, "=");
-	strcat(cmd, field_name);
+	seq_buf_printf(&s, ":synthetic_%s=%s", field_name, field_name);
 
 	/* Use the same filter as the compatible histogram */
 	saved_filter = find_trigger_filter(hist_data, file);
-	if (saved_filter) {
-		strcat(cmd, " if ");
-		strcat(cmd, saved_filter);
+	if (saved_filter)
+		seq_buf_printf(&s, " if %s", saved_filter);
+
+	/* Terminate cmd with a NUL. */
+	seq_buf_str(&s);
+
+	if (seq_buf_has_overflowed(&s)) {
+		kfree(cmd);
+		kfree(var_hist);
+		return ERR_PTR(-E2BIG);
 	}
 
 	var_hist->cmd = kstrdup(cmd, GFP_KERNEL);
-- 
2.53.0



