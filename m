Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625539;
	b=KeEKOS/bNw7dpYGlFoq7nEhDhw34m7LeK2eiEitus/qZPFviAwJqhQfD4k/rYijYUHxr
	 ePkpmQ5oewR6aUUnW4zawX+tM+MfokPb8fWzEEdBFjpiicrbnokfgEhDcoNkwv9l/UvNQ
	 t6Z6t3wAWl9cZryxez+D/ELoAyQ/9HsDQCfqhsLQUlXwIoA5Iz/ESWF3FxKM5zL5NtcEE
	 KBXffaGQ1Lht19Z2mWwZP2YF1yZ/KlNGGu1r5tHtBwvwj3J4q5NSH2i74dEEIc7f4xdej
	 VIK5c4ksXGJO0hTTsFNW8BCrgg+tApD4wOHpgnk4vgX9XCD1w8FhjpcHnfL1H7ryRqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sL8EbnxT1A12JXrcRg31gJmnnarSkvHk58uEAkLGtg0=;
	b=yzTtQwnrp2wk0gZw2WZbFO2dHDQENCrAxQ6XxJifPqxl3pX1ElCkigPXJQRaxBKxtwVp
	 0jHn4yy6E+NxhASMXG7k8wNrUeakkPjqXEkYzXTTYHj5zQxflzD4cVGD/YEIykz0mAhO/
	 mXPCz7EoemaMphIWiBJ4y43hvXgKLRUMSAZnVmiB1hQ5C/+7ic6KtIYCs3k5uNIGrlIf4
	 I2APmdtGIrPFuJw0SY1jelooErJ5jXQgmVN8UEN5cvb7qn40XpC/n0R7TwtAkQVTwUII3
	 YDlt0KBNgNgVSFlfoutw7EnOFRSD9wQM0NmTT4gZ/vgWEzQZ4L9+HzYcEcqoVujBxJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KH8tyfLo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6624F606A321;
	Wed, 25 Nov 2026 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KH8tyfLo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272111F000C6;
	Wed, 25 Nov 2026 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625538;
	bh=sL8EbnxT1A12JXrcRg31gJmnnarSkvHk58uEAkLGtg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KH8tyfLo2HGE1dPgOtLzXBfzCZ6LL/YuZ0+YFRtLeO9cxrrNIwjFCOMqVS5ktWtGQ
	 ZWTOammzYGTQArBVGid2TnOO0ew3oTv0xO3UmKqjyP5ncLOBDTIeziHeQFvGXPto7h
	 D+nVFCDwLEJb5BfYHzxZMK7wLc8dAagwrydIv5Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 549/816] tracing/eprobe: Install the trigger for every instance that enables the eprobe
Date: Wed, 25 Nov 2026 15:34:57 +0100
Message-ID: <20261125143901.892787113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit be94710b1f6ba1bea33e73129c110af80e999b2d upstream.

The eprobe trigger lives in the instance of the enabling file, but it is
only added when the eprobe is first enabled and only removed when the
last file goes away. A second instance then records nothing, and the
first instance's trigger is left behind once the eprobe is disabled
there, so the eprobe can be deleted while that trigger still uses it.

Add and remove the trigger for each file. The file is never NULL here,
so warn if it is and drop the dead perf paths.

Link: https://lore.kernel.org/all/20261107101233.151434-1-devnexen@gmail.com/

Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   58 ++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 39 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -636,37 +636,32 @@ static int enable_trace_eprobe(struct tr
 {
 	struct trace_probe *tp;
 	struct trace_eprobe *ep;
-	bool enabled;
 	int ret = 0;
 	int cnt = 0;
 
+	if (WARN_ON_ONCE(!file))
+		return -EINVAL;
+
 	tp = trace_probe_primary_from_call(call);
 	if (WARN_ON_ONCE(!tp))
 		return -ENODEV;
-	enabled = trace_probe_is_enabled(tp);
 
 	/* This also changes "enabled" state */
-	if (file) {
-		ret = trace_probe_add_file(tp, file);
-		if (ret)
-			return ret;
-	} else
-		trace_probe_set_flag(tp, TP_FLAG_PROFILE);
-
-	if (enabled)
-		return 0;
+	ret = trace_probe_add_file(tp, file);
+	if (ret)
+		return ret;
 
+	/* The trigger lives in the instance of the file, add it for each file */
 	for_each_trace_eprobe_tp(ep, tp) {
 		ret = enable_eprobe(ep, file);
 		if (ret)
 			break;
-		enabled = true;
 		cnt++;
 	}
 
 	if (ret) {
 		/* Failed to enable one of them. Roll back all */
-		if (enabled) {
+		if (cnt) {
 			/*
 			 * It's a bug if one failed for something other than memory
 			 * not being available but another eprobe succeeded.
@@ -679,10 +674,7 @@ static int enable_trace_eprobe(struct tr
 					break;
 			}
 		}
-		if (file)
-			trace_probe_remove_file(tp, file);
-		else
-			trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
+		trace_probe_remove_file(tp, file);
 	}
 
 	return ret;
@@ -694,33 +686,21 @@ static int disable_trace_eprobe(struct t
 	struct trace_probe *tp;
 	struct trace_eprobe *ep;
 
+	if (WARN_ON_ONCE(!file))
+		return -EINVAL;
+
 	tp = trace_probe_primary_from_call(call);
 	if (WARN_ON_ONCE(!tp))
 		return -ENODEV;
 
-	if (file) {
-		if (!trace_probe_get_file_link(tp, file))
-			return -ENOENT;
-		if (!trace_probe_has_single_file(tp))
-			goto out;
-		trace_probe_clear_flag(tp, TP_FLAG_TRACE);
-	} else
-		trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
-
-	if (!trace_probe_is_enabled(tp)) {
-		for_each_trace_eprobe_tp(ep, tp)
-			disable_eprobe(ep, file->tr);
-	}
+	if (!trace_probe_get_file_link(tp, file))
+		return -ENOENT;
 
- out:
-	if (file)
-		/*
-		 * Synchronization is done in below function. For perf event,
-		 * file == NULL and perf_trace_event_unreg() calls
-		 * tracepoint_synchronize_unregister() to ensure synchronize
-		 * event. We don't need to care about it.
-		 */
-		trace_probe_remove_file(tp, file);
+	for_each_trace_eprobe_tp(ep, tp)
+		disable_eprobe(ep, file->tr);
+
+	/* Synchronization is done in below function. */
+	trace_probe_remove_file(tp, file);
 
 	return 0;
 }


