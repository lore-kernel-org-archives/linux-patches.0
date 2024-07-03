Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C867F16F8FA;
	Wed,  3 Jul 2024 11:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005547; cv=none; b=JIR9H0fEMPXnbcX3rauOzA+qGcFfdWED74mQTytSESXPwogdLdo+Uz6JIQ/L86rWrOLnWWR4xhZUTaFSqCfVG0dwWIEODOxnT3UpMQsVmc5mGmdLxYmIdQtrXqJSqymGZrnVgYLBP81RiL44jlz/jWvU/qV4nwtZaagNDSlIMz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005547; c=relaxed/simple;
	bh=BGMUyjeO72SXx6hscmlUkANDvo2lSGXy43s7nRt8fcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMN0Gg7dQuHHhyaGT4pjhOAGbVajb3A36ampdZmikjjvyn/XQh5HguJTShXSauF4seDbMsij+GiHb6De7InO3hYCPaYgSfCh1/XPaMSyqgcJbF0Xj8NyQCU9zOReUZrCWqFhY9f+5OuxWOMNyEjUWss5aB9IT3KiHMpPph4XnZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1PKVYTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1PKVYTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40349C2BD10;
	Wed,  3 Jul 2024 11:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005547;
	bh=BGMUyjeO72SXx6hscmlUkANDvo2lSGXy43s7nRt8fcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1PKVYTvnJgqfVlPixdFzFPDFj4h0+YKpoP/+Yk1iPYTTYYVPdc+khH2i9GHg+RCK
	 YgkuiSRGXbU0PUTw2BXud5cSemq4uuRxbzJdu3F7wLyUdfgEYGrkW45T7oWNanJSST
	 Tf7m42Mhq+mpFS4yp+mCbvKjtCpbk51EEYxQl+aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 118/356] tracing/selftests: Fix kprobe event name test for .isra. functions
Date: Wed,  3 Jul 2024 12:37:34 +0200
Message-ID: <20240703102917.560266529@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 23a4b108accc29a6125ed14de4a044689ffeda78 upstream.

The kprobe_eventname.tc test checks if a function with .isra. can have a
kprobe attached to it. It loops through the kallsyms file for all the
functions that have the .isra. name, and checks if it exists in the
available_filter_functions file, and if it does, it uses it to attach a
kprobe to it.

The issue is that kprobes can not attach to functions that are listed more
than once in available_filter_functions. With the latest kernel, the
function that is found is: rapl_event_update.isra.0

  # grep rapl_event_update.isra.0 /sys/kernel/tracing/available_filter_functions
  rapl_event_update.isra.0
  rapl_event_update.isra.0

It is listed twice. This causes the attached kprobe to it to fail which in
turn fails the test. Instead of just picking the function function that is
found in available_filter_functions, pick the first one that is listed
only once in available_filter_functions.

Cc: stable@vger.kernel.org
Fixes: 604e3548236d ("selftests/ftrace: Select an existing function in kprobe_eventname test")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_eventname.tc |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_eventname.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_eventname.tc
@@ -30,7 +30,8 @@ find_dot_func() {
 	fi
 
 	grep " [tT] .*\.isra\..*" /proc/kallsyms | cut -f 3 -d " " | while read f; do
-		if grep -s $f available_filter_functions; then
+		cnt=`grep -s $f available_filter_functions | wc -l`;
+		if [ $cnt -eq 1 ]; then
 			echo $f
 			break
 		fi


