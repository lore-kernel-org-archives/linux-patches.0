Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A16A4C10E1;
	Thu, 17 Sep 2026 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660077; cv=none; b=RdQjoZlJY0Yrnr1A4qLJZYG1rQ1d+BQWROUKsKLVrYg6be2V/fre6yMOuIEAZDUL0gFhSci1NfIUeJDVgegbXz4o9lmIFl6W+tQaYce2jKD32fiq9Es/OsYE9FRN34a507w2aLS4PyzTKLIX0Thq0f8zqGrWWiOMxcJMwlLSogw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660077; c=relaxed/simple;
	bh=P9efC/1Wa8Nj9JutGfUeVcHoTa+Vt5Tw3qD4gtUeYJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kqrFhTWY+82sR9Xz8b+vA1+Ie+h0mVV9JWK+slSv1kQG4+LVyb08Vikn6iFXz81GfqzquHbfwL6w1YPOIwCPeoYHdDKDKxAWHjsrZXJ7AzTyVjYGu/YTKf/xkMn5bbjJd4x797GhpB8gUs1CSbHAgEHvwHvmAwPqaIb5tzlVq6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNiLVN6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNiLVN6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470BB1F00893;
	Thu, 17 Sep 2026 15:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660070;
	bh=eYPk3LZiDM9WaLRcuQabEU592fgPxCAIToHmgZnrzFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNiLVN6b6Ai/PLC7QYtdpxuB2XkSikj7esJoqoJv390Q2tV8gPXfwRbkWPToajQ9n
	 zeyu7j8h1IKYcw29UbVwkiMBc/A4OJxcYxq1Xl7Je8Wfag/0a6D9ExfEj777x+AWpV
	 s8pivbO5HmveTUuL+vJ0DLEmyFGESAxEnFOFI6z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 470/733] tracing: Restore :mod: trailer after parsing in ftrace_set_clr_event()
Date: Thu, 17 Sep 2026 16:12:58 +0100
Message-ID: <20260917151403.697317503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 911002e99e15f640f1fdc6d276206beaef59e790 upstream.

While ftrace_set_clr_event() modifies its input buffer during parsing,
before returning to the caller the buffer is supposed to be restored
to its original state.

This works correctly for the colon between the subsystem and event
but not the colon at the beginning of :mod:.

Restore the colon, so the :mod: trailer is not stripped after
ftrace_set_clr_event().

Cc: stable@vger.kernel.org
Fixes: 4c86bc531e60 ("tracing: Add :mod: command to enabled module events")
Link: https://patch.msgid.link/20260908-tracing-cli-event-filter-v2-1-05396a3fb663@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1462,6 +1462,8 @@ int ftrace_set_clr_event(struct trace_ar
 	/* Put back the colon to allow this to be called again */
 	if (buf)
 		*(buf - 1) = ':';
+	if (mod)
+		*(mod - 5) = ':';
 
 	return ret;
 }


