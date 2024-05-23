Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D94913D2BD;
	Thu, 23 May 2024 13:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470067; cv=none; b=WXvC1vxd7sIhxXmQfRNCGn9JW3RpcvNTaCRuB/rRGnf59MYnWQfMIF+XsJcs0ZXcTN1ew4qWZTbtykbAYlVZjUnVGZDRR9rheYEWO9eExMH04zSAjGfcMH57WtwoDv/pIJKeWUTTE2YyYQ40cv2ICnWPH2+WK/7ScXc8l9F6+ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470067; c=relaxed/simple;
	bh=BJtu1QWnKxmIdNysMfOoxseP/D/N6IJxHo5IPQ1wbL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkGBCVGi8QRJgzRdPBNp5jDmdHc/OR/IQRmmUKhWMdpxOJuRWWaUfb1QE+2zPD7bqpqtYAs0MGEIgKlRCmhsx0d5/fUstjSKoYl76pP62sDgqFqZaHQaRNDYW+cu4kjPKOtG7Ofkec/7nfULkVFfHzx7aWp0+pjzjiDN//VbZ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJguPe94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJguPe94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495A2C3277B;
	Thu, 23 May 2024 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470066;
	bh=BJtu1QWnKxmIdNysMfOoxseP/D/N6IJxHo5IPQ1wbL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJguPe94b/26CDJj6vaEGtqXbSCYGXIGmkMaRdxPBh8xi0m0Wi1DM76DbLvr4v9hB
	 IyOfOOwSm830vuyviFLpTt6OBc2aYQTVUhNs1Njq2KWNXgu7abFOlqa9aWDNmzpzAp
	 S7XHJwBuItbWA2mtXIk8Vv1v4nCqp54hLQRJYpHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 10/18] tracing: Use str_has_prefix() helper for histogram code
Date: Thu, 23 May 2024 15:12:33 +0200
Message-ID: <20240523130326.126788514@linuxfoundation.org>
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

commit 754481e6954cbef53f8bc4412ad48dde611e21d3 upstream.

The tracing histogram code contains a lot of instances of the construct:

 strncmp(str, "const", sizeof("const") - 1)

This can be prone to bugs due to typos or bad cut and paste. Use the
str_has_prefix() helper macro instead that removes the need for having two
copies of the constant string.

Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1878,8 +1878,8 @@ static int parse_action(char *str, struc
 	if (attrs->n_actions >= HIST_ACTIONS_MAX)
 		return ret;
 
-	if ((strncmp(str, "onmatch(", strlen("onmatch(")) == 0) ||
-	    (strncmp(str, "onmax(", strlen("onmax(")) == 0)) {
+	if ((str_has_prefix(str, "onmatch(")) ||
+	    (str_has_prefix(str, "onmax("))) {
 		attrs->action_str[attrs->n_actions] = kstrdup(str, GFP_KERNEL);
 		if (!attrs->action_str[attrs->n_actions]) {
 			ret = -ENOMEM;
@@ -1896,34 +1896,34 @@ static int parse_assignment(char *str, s
 {
 	int ret = 0;
 
-	if ((strncmp(str, "key=", strlen("key=")) == 0) ||
-	    (strncmp(str, "keys=", strlen("keys=")) == 0)) {
+	if ((str_has_prefix(str, "key=")) ||
+	    (str_has_prefix(str, "keys="))) {
 		attrs->keys_str = kstrdup(str, GFP_KERNEL);
 		if (!attrs->keys_str) {
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if ((strncmp(str, "val=", strlen("val=")) == 0) ||
-		 (strncmp(str, "vals=", strlen("vals=")) == 0) ||
-		 (strncmp(str, "values=", strlen("values=")) == 0)) {
+	} else if ((str_has_prefix(str, "val=")) ||
+		   (str_has_prefix(str, "vals=")) ||
+		   (str_has_prefix(str, "values="))) {
 		attrs->vals_str = kstrdup(str, GFP_KERNEL);
 		if (!attrs->vals_str) {
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if (strncmp(str, "sort=", strlen("sort=")) == 0) {
+	} else if (str_has_prefix(str, "sort=")) {
 		attrs->sort_key_str = kstrdup(str, GFP_KERNEL);
 		if (!attrs->sort_key_str) {
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if (strncmp(str, "name=", strlen("name=")) == 0) {
+	} else if (str_has_prefix(str, "name=")) {
 		attrs->name = kstrdup(str, GFP_KERNEL);
 		if (!attrs->name) {
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if (strncmp(str, "clock=", strlen("clock=")) == 0) {
+	} else if (str_has_prefix(str, "clock=")) {
 		strsep(&str, "=");
 		if (!str) {
 			ret = -EINVAL;
@@ -1936,7 +1936,7 @@ static int parse_assignment(char *str, s
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if (strncmp(str, "size=", strlen("size=")) == 0) {
+	} else if (str_has_prefix(str, "size=")) {
 		int map_bits = parse_map_size(str);
 
 		if (map_bits < 0) {
@@ -3623,7 +3623,7 @@ static struct action_data *onmax_parse(c
 	if (!onmax_fn_name || !str)
 		goto free;
 
-	if (strncmp(onmax_fn_name, "save", strlen("save")) == 0) {
+	if (str_has_prefix(onmax_fn_name, "save")) {
 		char *params = strsep(&str, ")");
 
 		if (!params) {
@@ -4414,8 +4414,8 @@ static int parse_actions(struct hist_tri
 	for (i = 0; i < hist_data->attrs->n_actions; i++) {
 		str = hist_data->attrs->action_str[i];
 
-		if (strncmp(str, "onmatch(", strlen("onmatch(")) == 0) {
-			char *action_str = str + strlen("onmatch(");
+		if (str_has_prefix(str, "onmatch(")) {
+			char *action_str = str + sizeof("onmatch(") - 1;
 
 			data = onmatch_parse(tr, action_str);
 			if (IS_ERR(data)) {
@@ -4423,8 +4423,8 @@ static int parse_actions(struct hist_tri
 				break;
 			}
 			data->fn = action_trace;
-		} else if (strncmp(str, "onmax(", strlen("onmax(")) == 0) {
-			char *action_str = str + strlen("onmax(");
+		} else if (str_has_prefix(str, "onmax(")) {
+			char *action_str = str + sizeof("onmax(") - 1;
 
 			data = onmax_parse(action_str);
 			if (IS_ERR(data)) {


