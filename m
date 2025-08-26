Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49482264B8;
	Tue, 26 Aug 2025 13:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215783; cv=none; b=noJGuhGRpB0v2gL8Z3GRTfv0f/m5k03OtcAYZzy+EIoEPfHC8u3rVmI1pIX8J7ujZeGkjOSoiuH5cAQkvRJATJT2r+4iOXI9rP1Njr/Her5VOCeHqnI/mH9gsst6pjs0y52L2a/52qB7syThw7JNKi8Z6BYYH6ENsTHnIT2mqUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215783; c=relaxed/simple;
	bh=eAt1xIP/+IeezbEa+wVYFAm9EF+AXp8N3fMIhIE5xKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/nKL3abLjkLaieUU/zy+5QddCT3slmdExVdJKwcAEvzCbJyA6T59apksy6/MFbGu7Bp0ImvRkBAhOluiISObzU1K3A55q/V6K/zs9vglLORNunAIdqW9RJNpTrE2bmkXbcoNHoa/goYBSq12vUGoiO8Eo+x3AUVIZQ/aNeC+ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ne04aN/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ne04aN/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5956BC113CF;
	Tue, 26 Aug 2025 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215783;
	bh=eAt1xIP/+IeezbEa+wVYFAm9EF+AXp8N3fMIhIE5xKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ne04aN/D0cGfoZzfeFsBPJNBMS/Hs3hv16e7ma3vQSov4y5MIycrZNbBmjtlbTj/T
	 TJC7EA/XDXHkBKb8iqZVb4xcf7Gv+9Npkrs0BVoeSHbEo6xEZqaPkp5DB6WrPlpRtM
	 UmV9IrV+2tdWrP5jXMdBRyI9mzLTZFYH4XPUWwVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/644] selftests/tracing: Fix false failure of subsystem event test
Date: Tue, 26 Aug 2025 13:03:45 +0200
Message-ID: <20250826110949.826864115@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 213879061a9c60200ba971330dbefec6df3b4a30 ]

The subsystem event test enables all "sched" events and makes sure there's
at least 3 different events in the output. It used to cat the entire trace
file to | wc -l, but on slow machines, that could last a very long time.
To solve that, it was changed to just read the first 100 lines of the
trace file. This can cause false failures as some events repeat so often,
that the 100 lines that are examined could possibly be of only one event.

Instead, create an awk script that looks for 3 different events and will
exit out after it finds them. This will find the 3 events the test looks
for (eventually if it works), and still exit out after the test is
satisfied and not cause slower machines to run forever.

Link: https://lore.kernel.org/r/20250721134212.53c3e140@batman.local.home
Reported-by: Tengda Wu <wutengda@huaweicloud.com>
Closes: https://lore.kernel.org/all/20250710130134.591066-1-wutengda@huaweicloud.com/
Fixes: 1a4ea83a6e67 ("selftests/ftrace: Limit length in subsystem-enable tests")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ftrace/test.d/event/subsystem-enable.tc   | 28 +++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
index b7c8f29c09a9..65916bb55dfb 100644
--- a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
+++ b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
@@ -14,11 +14,35 @@ fail() { #msg
     exit_fail
 }
 
+# As reading trace can last forever, simply look for 3 different
+# events then exit out of reading the file. If there's not 3 different
+# events, then the test has failed.
+check_unique() {
+    cat trace | grep -v '^#' | awk '
+	BEGIN { cnt = 0; }
+	{
+	    for (i = 0; i < cnt; i++) {
+		if (event[i] == $5) {
+		    break;
+		}
+	    }
+	    if (i == cnt) {
+		event[cnt++] = $5;
+		if (cnt > 2) {
+		    exit;
+		}
+	    }
+	}
+	END {
+	    printf "%d", cnt;
+	}'
+}
+
 echo 'sched:*' > set_event
 
 yield
 
-count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`check_unique`
 if [ $count -lt 3 ]; then
     fail "at least fork, exec and exit events should be recorded"
 fi
@@ -29,7 +53,7 @@ echo 1 > events/sched/enable
 
 yield
 
-count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`check_unique`
 if [ $count -lt 3 ]; then
     fail "at least fork, exec and exit events should be recorded"
 fi
-- 
2.39.5



