Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D571214A635;
	Thu, 23 May 2024 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470090; cv=none; b=j4LU4dZGtfwpBvzz00FNekDbbCNcJU98Zrp86g5s46PgPO0pt1sIX8Y3EaolhatrFZZBoO4/XhHokCm+PiV82ZvJhcxqpZ+HoQ6FIkDBLGfTfUQL72KjJEVAX0F0RnR3IMhWjDrukhBpteOBqOEql7nSy+4H9rFqU1XkbcKd9Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470090; c=relaxed/simple;
	bh=LHjN11KINyzryf4nyMaoIN+RboFjp4WPgXHkSCr8VAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgT8ElQsMiXxwhFLXSitcDFjTZ9nVUlb0YgkOuxKVFzXSm/8r3Ky8wv7PQzJcgI1dLLEGZd0GCkgTLK6h0mKolj7bAz0zuONbtIOVX0U82U0AjkBZs7ckldOWXgf1YEtz8nCuVzIobF005M8vRFB9fHRuPCL/Z3nWGZqkt78XE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3OIftlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3OIftlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCE2C32782;
	Thu, 23 May 2024 13:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470090;
	bh=LHjN11KINyzryf4nyMaoIN+RboFjp4WPgXHkSCr8VAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3OIftlQJ2eIuO8/6JSElK6EUNVA1F0hV3C9bK+pss+nNZyHk+PPORCXRpw4s1Hiz
	 gRqkrCu00zfwEEuqS6ORuRpilMDPa2nq8REMOCjs34pWpSG98w1cDWcCMFCrlxsraw
	 JReMoy+RqMPlWdi2zAJyJrRDiAyA8cBQZ5t+WuZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, George Guo" <guodongtai@kylinos.cn>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 04/18] tracing: Simplify creation and deletion of synthetic events
Date: Thu, 23 May 2024 15:12:27 +0200
Message-ID: <20240523130325.898254176@linuxfoundation.org>
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

From: Masami Hiramatsu <mhiramat@kernel.org>

commit faacb361f271be4baf2d807e2eeaba87e059225f upstream.

Since the event_mutex and synth_event_mutex ordering issue
is gone, we can skip existing event check when adding or
deleting events, and some redundant code in error path.

This changes release_all_synth_events() to abort the process
when it hits any error and returns the error code. It succeeds
only if it has no error.

Link: http://lkml.kernel.org/r/154140847194.17322.17960275728005067803.stgit@devbox

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   53 +++++++++++++--------------------------
 1 file changed, 18 insertions(+), 35 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1028,18 +1028,6 @@ struct hist_var_data {
 	struct hist_trigger_data *hist_data;
 };
 
-static void add_or_delete_synth_event(struct synth_event *event, int delete)
-{
-	if (delete)
-		free_synth_event(event);
-	else {
-		if (!find_synth_event(event->name))
-			list_add(&event->list, &synth_event_list);
-		else
-			free_synth_event(event);
-	}
-}
-
 static int create_synth_event(int argc, char **argv)
 {
 	struct synth_field *field, *fields[SYNTH_FIELDS_MAX];
@@ -1072,15 +1060,16 @@ static int create_synth_event(int argc,
 	if (event) {
 		if (delete_event) {
 			if (event->ref) {
-				event = NULL;
 				ret = -EBUSY;
 				goto out;
 			}
-			list_del(&event->list);
-			goto out;
-		}
-		event = NULL;
-		ret = -EEXIST;
+			ret = unregister_synth_event(event);
+			if (!ret) {
+				list_del(&event->list);
+				free_synth_event(event);
+			}
+		} else
+			ret = -EEXIST;
 		goto out;
 	} else if (delete_event) {
 		ret = -ENOENT;
@@ -1120,29 +1109,21 @@ static int create_synth_event(int argc,
 		event = NULL;
 		goto err;
 	}
+	ret = register_synth_event(event);
+	if (!ret)
+		list_add(&event->list, &synth_event_list);
+	else
+		free_synth_event(event);
  out:
-	if (event) {
-		if (delete_event) {
-			ret = unregister_synth_event(event);
-			add_or_delete_synth_event(event, !ret);
-		} else {
-			ret = register_synth_event(event);
-			add_or_delete_synth_event(event, ret);
-		}
-	}
 	mutex_unlock(&synth_event_mutex);
 	mutex_unlock(&event_mutex);
 
 	return ret;
  err:
-	mutex_unlock(&synth_event_mutex);
-	mutex_unlock(&event_mutex);
-
 	for (i = 0; i < n_fields; i++)
 		free_synth_field(fields[i]);
-	free_synth_event(event);
 
-	return ret;
+	goto out;
 }
 
 static int release_all_synth_events(void)
@@ -1161,10 +1142,12 @@ static int release_all_synth_events(void
 	}
 
 	list_for_each_entry_safe(event, e, &synth_event_list, list) {
-		list_del(&event->list);
-
 		ret = unregister_synth_event(event);
-		add_or_delete_synth_event(event, !ret);
+		if (!ret) {
+			list_del(&event->list);
+			free_synth_event(event);
+		} else
+			break;
 	}
 	mutex_unlock(&synth_event_mutex);
 	mutex_unlock(&event_mutex);


