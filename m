Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BEA2874F6;
	Fri, 21 Nov 2025 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731956; cv=none; b=N4mFyXYPIKi6qhHUuSv3qzjKLQlkc46shGewVPjZjPFWugX0SNrajmO+stzqwT9T5eSb7Wu/IjKnvr7PonV+tMnl1Q3OL/a4U2dljvDIi/tmozvTW7yXoV1muIqOjSLjJwWJRBkyiLoOW/g+jZY9MMQNk3wGW96dd62N6SETCf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731956; c=relaxed/simple;
	bh=qgnWTxE0JdCnHZt9znke5GJjlsIEvKHmf+Z4SxIlNfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5k0gTTQkWkq5kpBsejXTwnJk9qdqBfVDIr2wgVF5ejGrxOpGw7QMGMhHSGaYal6fstUFNeXwXNcwtZl+GrBs+vHXLqgQi81+hDeEd/pS9q6CZR21eetz4HzIjlldNe3KKcm783vHaQTQRNVIMTIQkwExeiybRQHzpYot3Uhlpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wi/1lvUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wi/1lvUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EBCC4CEF1;
	Fri, 21 Nov 2025 13:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731956;
	bh=qgnWTxE0JdCnHZt9znke5GJjlsIEvKHmf+Z4SxIlNfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wi/1lvUp1V8iCmc89YUEG0Ke5dSdz3CjhirHflqDnBG6OJZyJyR+7owPkfL/HYVqK
	 R/OzRMzMCHCiciHxJx5y4Jzr/gU3JBOnjKo3SCecEoNUoJRL4FEuBEnXUPBplU6hJG
	 DANk/rcDcXLbF8kz7TOTzZcN0sqkCcHUw0qq4euY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.12 122/185] selftests/tracing: Run sample events to clear page cache events
Date: Fri, 21 Nov 2025 14:12:29 +0100
Message-ID: <20251121130148.278915387@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit dd4adb986a86727ed8f56c48b6d0695f1e211e65 upstream.

The tracing selftest "event-filter-function.tc" was failing because it
first runs the "sample_events" function that triggers the kmem_cache_free
event and it looks at what function was used during a call to "ls".

But the first time it calls this, it could trigger events that are used to
pull pages into the page cache.

The rest of the test uses the function it finds during that call to see if
it will be called in subsequent "sample_events" calls. But if there's no
need to pull pages into the page cache, it will not trigger that function
and the test will fail.

Call the "sample_events" twice to trigger all the page cache work before
it calls it to find a function to use in subsequent checks.

Cc: stable@vger.kernel.org
Fixes: eb50d0f250e96 ("selftests/ftrace: Choose target function for filter test from samples")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
+++ b/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
@@ -20,6 +20,10 @@ sample_events() {
 echo 0 > tracing_on
 echo 0 > events/enable
 
+# Clear functions caused by page cache; run sample_events twice
+sample_events
+sample_events
+
 echo "Get the most frequently calling function"
 echo > trace
 sample_events


