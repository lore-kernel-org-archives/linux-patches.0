Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8802446B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEC0C433EF;
	Mon, 16 Jan 2023 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885446;
	bh=u2R+UMgisf/Kl63bbnac0io1YNMiLxcjofL4Dd11Hg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bm+voi9iGOuKnwJ6nxlrxUAsJc+2QOo219NKXPwI5o4XkpDemGd8sPPfzzwxdT4YW
	 7+I4u+uSLdN2QQe5h/U9wvS6+trqECLu/C1VgWpZVXUUO5BBW/a5PnF2RzjdcQ10bP
	 3d9Tme8MyF8baA6OPKn8dpLNYEMpdX0e5dtfgQo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yipeng Zou <zouyipeng@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/658] selftests/ftrace: event_triggers: wait longer for test_event_enable
Date: Mon, 16 Jan 2023 16:42:22 +0100
Message-Id: <20230116154912.132907051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index ca2ffd7957f9..f261eeccfaf6 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
@@ -42,11 +42,18 @@ cnt_trace() {
 
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



