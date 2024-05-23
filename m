Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E66613D2BD;
	Thu, 23 May 2024 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470070; cv=none; b=YD/fNVy4bqmCG/oQCkO4LgAsUHNhBZEYJwJA3TXSY8zmHxMebazhNP8tg9QtH3b5O872wd9HSMQZSBm4nV0kXCBkxvauk8tpawgZPKrLWyjSTLkcETMpKJ+AhnESQY7+z08QHjVurF/tGVzeDWPrgQPbAcrPK0DCMIj9lbsP2aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470070; c=relaxed/simple;
	bh=b0hTXFhplrfoBHoVtx+NNwrXQ5eMkptGiQ+CzFPL3c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUiNPAyh3UT3uZxI1m03CgxVI2/o5uEJYdLD0rr7dz/9Vh5VMV7rwHV3YaVnhu2J0GzQ2Jb7u6CBTShxtIbPXtpsPUAbUbCPN6+R/AicYzmEpKk3VOS4m3yg6e7uv9qxEserqX0bierWpytEestnlqeaxFQ1AQ2JjpfWNgj78S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqGdwLai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqGdwLai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5796EC2BD10;
	Thu, 23 May 2024 13:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470069;
	bh=b0hTXFhplrfoBHoVtx+NNwrXQ5eMkptGiQ+CzFPL3c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqGdwLaiyDTp88BUfxx0krw6U6WWu2GvhJD+yfMBdBLTyTtr1sLmZPpR5RzXq8kGk
	 LdPmqom1zzbfIRPi9W+wfZXt22t3kaj5zvma1NaJYs4CJ2NbhZHQKAxqf8ASh3+DLd
	 HS4gv0JbJJON+T7JzbPSEY4RApeNvkkABqdSE1/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 11/18] tracing: Use str_has_prefix() instead of using fixed sizes
Date: Thu, 23 May 2024 15:12:34 +0200
Message-ID: <20240523130326.165095627@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit b6b2735514bcd70ad1556a33892a636b20ece671 upstream.

There are several instances of strncmp(str, "const", 123), where 123 is the
strlen of the const string to check if "const" is the prefix of str. But
this can be error prone. Use str_has_prefix() instead.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c             |    2 +-
 kernel/trace/trace_events.c      |    2 +-
 kernel/trace/trace_events_hist.c |    2 +-
 kernel/trace/trace_probe.c       |    2 +-
 kernel/trace/trace_stack.c       |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4470,7 +4470,7 @@ static int trace_set_options(struct trac
 
 	cmp = strstrip(option);
 
-	if (strncmp(cmp, "no", 2) == 0) {
+	if (str_has_prefix(cmp, "no")) {
 		neg = 1;
 		cmp += 2;
 	}
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1249,7 +1249,7 @@ static int f_show(struct seq_file *m, vo
 	 */
 	array_descriptor = strchr(field->type, '[');
 
-	if (!strncmp(field->type, "__data_loc", 10))
+	if (str_has_prefix(field->type, "__data_loc"))
 		array_descriptor = NULL;
 
 	if (!array_descriptor)
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -484,7 +484,7 @@ static int synth_event_define_fields(str
 
 static bool synth_field_signed(char *type)
 {
-	if (strncmp(type, "u", 1) == 0)
+	if (str_has_prefix(type, "u"))
 		return false;
 	if (strcmp(type, "gfp_t") == 0)
 		return false;
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -342,7 +342,7 @@ static int parse_probe_vars(char *arg, c
 			f->fn = t->fetch[FETCH_MTD_retval];
 		else
 			ret = -EINVAL;
-	} else if (strncmp(arg, "stack", 5) == 0) {
+	} else if (str_has_prefix(arg, "stack")) {
 		if (arg[5] == '\0') {
 			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR))
 				return -EINVAL;
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -453,7 +453,7 @@ static char stack_trace_filter_buf[COMMA
 
 static __init int enable_stacktrace(char *str)
 {
-	if (strncmp(str, "_filter=", 8) == 0)
+	if (str_has_prefix(str, "_filter="))
 		strncpy(stack_trace_filter_buf, str+8, COMMAND_LINE_SIZE);
 
 	stack_tracer_enabled = 1;


