Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8094FE2D7;
	Thu, 17 Sep 2026 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666234; cv=none; b=Hu/jUVGfKvn73O+odGjTck7GNJ7MRjXmLzOd94cDJwVqr0bIj306m2gx5XfMN3rlSct5nKwVSciSSox6pWHtIWmr88Mv+7UHfnmD2A3GfY5zxMDqS5zM+H9cb7LLKg2XJLk1OFaV2oEmGK8K9RfL539fE77mKjykiSHhOFzJM2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666234; c=relaxed/simple;
	bh=MeYLkA5Llk4SMO8UkOfzWswQbOIpooh7SqIlgekCasY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IqA2BY+YKFKkiS+sLDrjxVm2LqgIOg8crtzLnTC2LDKQg/qk7/1au9/yyKNaS5JpwinJq/pYiiklqkNzAtLQnQfiNWBomLjz1U5yiaBuhDNewo8tfHYRxp1F2spU9gFat7zEaip/+f08xghuwImzjLZHhaykL6lqmkaTXvSldgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=av0OR44X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="av0OR44X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F1E1F000FF;
	Thu, 17 Sep 2026 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666233;
	bh=HcquNPtrvASf69gyj6V/O4EC1EO3GAGpsNICXKP+muE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=av0OR44X4COdFwWRycENjeaGp/MxfaX3O7jFgzVk50whDdPTg5v4ejrOcEOvCEaXB
	 00me94aX8HE8dkEazCh3f34iLEoAJHBvlr6aVYuSL0O1//N5xDN9eCGB1wSIqf8Epq
	 aqN0E5O5F9uLy0GWmMRKdJCYROrwuzm0+d0jUXK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 0968/1250] tracing: Restore :mod: trailer after parsing in ftrace_set_clr_event()
Date: Thu, 17 Sep 2026 16:12:43 +0100
Message-ID: <20260917151618.255237815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1442,6 +1442,8 @@ int ftrace_set_clr_event(struct trace_ar
 	/* Put back the colon to allow this to be called again */
 	if (buf)
 		*(buf - 1) = ':';
+	if (mod)
+		*(mod - 5) = ':';
 
 	return ret;
 }


