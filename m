Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56571863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656A1C433EF;
	Wed, 28 Dec 2022 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240523;
	bh=nM8GguaSRbiVaEzUdFooTn59i6CLzLiozzPgY4OEJDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR5igsaq0H4kNYllDkbOHG/Tk4ziJjVoXRgULlP97KBNRfxDZbVDSJWTDNgNHJLjD
	 GAJcv9OYHwQn3uuSN8Q/3N2z8cI9WiBp2r6GpyhZEE0vMvjUBWCKBQdIX8cQqxzz5V
	 JRDanBD1N/LW3dpJsxAxaJrro1O/vkB33iV6QaMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yipeng Zou <zouyipeng@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0123/1146] selftests/ftrace: event_triggers: wait longer for test_event_enable
Date: Wed, 28 Dec 2022 15:27:42 +0100
Message-Id: <20221228144333.496195760@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yipeng Zou <zouyipeng@huawei.com>

[ Upstream commit a1d6cd88c8973cfb08ee85722488b1d6d5d16327 ]

In some platform, the schedule event may came slowly, delay 100ms can't
cover it.

I was notice that on my board which running in low cpu_freq,and this
selftests allways gose fail.

So maybe we can check more times here to wait longer.

Fixes: 43bb45da82f9 ("selftests: ftrace: Add a selftest to test event enable/disable func trigger")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ftrace/test.d/ftrace/func_event_triggers.tc   | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
index 8d26d5505808..3eea2abf68f9 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
@@ -38,11 +38,18 @@ cnt_trace() {
 
 test_event_enabled() {
     val=$1
+    check_times=10		# wait for 10 * SLEEP_TIME at most
 
-    e=`cat $EVENT_ENABLE`
-    if [ "$e" != $val ]; then
-	fail "Expected $val but found $e"
-    fi
+    while [ $check_times -ne 0 ]; do
+	e=`cat $EVENT_ENABLE`
+	if [ "$e" == $val ]; then
+	    return 0
+	fi
+	sleep $SLEEP_TIME
+	check_times=$((check_times - 1))
+    done
+
+    fail "Expected $val but found $e"
 }
 
 run_enable_disable() {
-- 
2.35.1



