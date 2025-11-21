Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD9434165F;
	Fri, 21 Nov 2025 13:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733445; cv=none; b=fFIwabmBhfAqNPVvk4TwB2VqFX2SbwM+0K0KayQHKZMxmOIK8uj8PMZLx/KRYE/mDiAwwm+EKfGxEpgOEifqC+sIWB1uDjaH65jrQ1CY4Ed6OH8oYpwFpF17A7nFjW3tw0vcOcTkyLsazy2RUbWotKJd3q1v0kFbjJmxZD8Wddo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733445; c=relaxed/simple;
	bh=uZFhnuvvrCBMN+0j7dDl2dLQtwnRKuindQvUb+la8vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GX7x+qsg90x+XZJbpZicgYdkhrwwDz1m7C/xDMQzAMNo2VZKCaaF+IGc+tZ86hjNbWKRrKvlGLuRZGYTVNuxrWv5jFge6qwiyJVlwhCHZ2ynKZlcLcdHt955JcpkyM4Ky6lcqJKMKrVF1MD9SkPtYLlp6nTenNPo6/sActYd6tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxrlDWtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxrlDWtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5E7C16AAE;
	Fri, 21 Nov 2025 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733445;
	bh=uZFhnuvvrCBMN+0j7dDl2dLQtwnRKuindQvUb+la8vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxrlDWtbghz2619UBNvHLGf2W9p6SwXMkTL2Q4kqoWfGiqBmuc46PwWfdlDz1Oyxc
	 HzRvCCokjHhmNg8m+kMNu8/ppfTW4RkY6Alz5kVgPT0iF4eafd3yZU4p16sxg28vTE
	 5nnNFRf0F57rGOfFWRzRtj5Ed1HOXnRz+5aCADJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 471/529] selftests/tracing: Run sample events to clear page cache events
Date: Fri, 21 Nov 2025 14:12:50 +0100
Message-ID: <20251121130247.768286138@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


