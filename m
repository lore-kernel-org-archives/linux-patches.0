Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF3A2F7477;
	Tue, 12 Aug 2025 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020993; cv=none; b=X0iXEg8oW7vgfcT9lBghUI2SRl34U2MymWOhyzEATEc9aMvtCZDf1O3sLp030jlPCnbvlBLKRWyscYWgpnaiy5JyRURwspuclbcAKrtoOuD/7eieBeaeD6naOYabtzIB006vN2EWy5FM1zRWz9sCXcwrzcumXGFC2rdJWRDWGu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020993; c=relaxed/simple;
	bh=LFMbrwAhs86RvXcsvQFdtWJ/OaalH4zfUJGwsGPY2Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeIJ8Q+/e39wtmWQazX2zQkhTgXa5yKvK7ml03XKRiHsWnykGkBozEY4H3Ls/VVQnZFOzRNxZ1Nf63sVESCTQqglpXToXEMdwxeVqmXM21lMpyyHbbGeSWlx3FJ4U/SVvi3wEhDC82dckA1JbLiUIC6Fq9SULqTJv3CDKwajtnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7+23moj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7+23moj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E900C4CEF0;
	Tue, 12 Aug 2025 17:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020992;
	bh=LFMbrwAhs86RvXcsvQFdtWJ/OaalH4zfUJGwsGPY2Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7+23mojvd77q/1CwXshB7qI6gntid1g7jiNvdOL4h2w0Gc6Q5cgVwKEQygx+kV58
	 2C193m7LDrQX/MY1lr1Cx+JzLfnurfVmHtxxTXo2TmvrP12Ix/HwDocgX7Dp33LdhE
	 yrz7TufnUEJyY1b7k7KtwrMaD7EM68tezwRIkmBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/262] selftests/tracing: Fix false failure of subsystem event test
Date: Tue, 12 Aug 2025 19:27:15 +0200
Message-ID: <20250812172954.974895643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



