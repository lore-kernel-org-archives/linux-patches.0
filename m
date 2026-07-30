Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D1234D385;
	Thu, 30 Jul 2026 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422908; cv=none; b=Bt5zMEdXiCrT0H8Olsi7NQw7QNu8Dx6gmQb4yH1btV9oMmP3jSY9yf026Pswf3cHn02E8Ms6ei+DpkO3xRGZqF5XEAzy4iqRi1JsPQFs0CaQkRZXzQFQJpZ1ajzKGBD/CKwMNzzllfi0tnXK6Sghd1rHYUv6KF/X4PaSudmcROs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422908; c=relaxed/simple;
	bh=gxGSFkHG0x7yKIHIpZlFEDsf6ExF8WMfVIftHzudNZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAdwwr/wnA+7q9687M21xvQDo9NE+R0Rcd6XfKRm4424Jnc0Aqjcny9nT5VveDd8KyeOuRLd7/q9a2K09bYcnFpD4+xeh1eIzvpB7dj2zYXwxXZM7euu/T1poeWfHfGRXFUAPQDHz2PbdrwCrjiqnd5S5HU4ZnTGlKYn6teVBvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QX/QIYwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QX/QIYwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DF41F000E9;
	Thu, 30 Jul 2026 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422907;
	bh=m6gqa2WqapNciqiPBsJ8qq8jrGvOiQg+g5tI8gTm1Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QX/QIYwu8qae16ipEFqFnd1ydcQj8axZ6PHqBTKa/LvM3sCoYgRHoLnFx0iHFoXfj
	 ImQHU+nVuXBksyJImQe7gwk4NLvpIYZ+8A+lnv3GCHZ+zdprIeQUhXDPKU0/iv2UBb
	 EKrpjq4twAOGXUZ3bFJIRtXr21a0VynbVccQNM3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 596/744] tracing: Propagate errors from remote event bulk updates
Date: Thu, 30 Jul 2026 16:14:29 +0200
Message-ID: <20260730141456.946982419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Liu <liuyun01@kylinos.cn>

commit 655111f878a455f724e20122929cf2afa52b76e4 upstream.

remote_events_dir_enable_write() ignores the return value from
trace_remote_enable_event(). If a remote rejects an event state change,
the write therefore reports success even though the affected event remains
in its previous state.

Keep trying all events, but retain and return the first error. This matches
__ftrace_set_clr_event_nolock(), which permits partial updates while
notifying userspace when an operation fails.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260715074455.3897-1-liu.yun@linux.dev
Fixes: 775cb093bc50 ("tracing: Add events/ root files to trace remotes")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_remote.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -1150,10 +1150,21 @@ static ssize_t remote_events_dir_enable_
 
 	for (i = 0; i < remote->nr_events; i++) {
 		struct remote_event *evt = &remote->events[i];
+		int eret;
 
-		trace_remote_enable_event(remote, evt, enable);
+		eret = trace_remote_enable_event(remote, evt, enable);
+		/*
+		 * Save the first error and return that. Some events
+		 * may still have been enabled, but let the user
+		 * know that something went wrong.
+		 */
+		if (!ret && eret)
+			ret = eret;
 	}
 
+	if (ret)
+		return ret;
+
 	return count;
 }
 


