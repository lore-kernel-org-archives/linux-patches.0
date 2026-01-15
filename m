Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C883D5D97;
	Thu, 15 Jan 2026 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499642; cv=none; b=Tu6fq/j0HOfjkBXp1+D6i/DANavQRs82nUJH9SL4LCo+QczsUCU/7zLRHqGUJhopbvdaGY0UKOnlbhmKPsHDwoZG2Sb/WlGj5d9XyvG4GMRM+Hs/zvgqgXCUMUylCMzKERkbHzz4yjWDcQZVaGEoSxE7ryqsNiClTEJwpouDeXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499642; c=relaxed/simple;
	bh=/L7vZP43AEtsAh9Po48Hfd6RWqT4Fr3rizQbFfnIXBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDkwfp79PH4kt2oVj+D4eLC9jPqCEKpTV1/B7acMUHnGqJMntzzOK9aIomU7MQlH96k9j33ULCIJo6X5FvCSy7ngdqkuohiH4PUGwq2YfHX7vPDlLJ0275vg70Fqz/E+rU2oiuVpGNc0F8AkZxo/b/Is8urmuB29/giRPRZoMXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T49EJuLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T49EJuLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757F2C16AAE;
	Thu, 15 Jan 2026 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499641;
	bh=/L7vZP43AEtsAh9Po48Hfd6RWqT4Fr3rizQbFfnIXBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T49EJuLUTNeCtTKAhv/DC+n5tQ0HeHOADWnuG6fFag8UZ8UtJWebm3TKS1Cerkdmq
	 vtfCnh5efBfjhJtpvO0Wc0MlQuKDy9BOcxtraS6jQa1TQg0ol8O6duu+acnMef/dh7
	 sF4dRFsKLg+zNJlTFr5f2lp57Z/C0+/qT0U+O0zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Yipeng Zou <zouyipeng@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/451] selftests/ftrace: traceonoff_triggers: strip off names
Date: Thu, 15 Jan 2026 17:48:18 +0100
Message-ID: <20260115164241.633893924@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yipeng Zou <zouyipeng@huawei.com>

[ Upstream commit b889b4fb4cbea3ca7eb9814075d6a51936394bd9 ]

The func_traceonoff_triggers.tc sometimes goes to fail
on my board, Kunpeng-920.

[root@localhost]# ./ftracetest ./test.d/ftrace/func_traceonoff_triggers.tc -l fail.log
=== Ftrace unit tests ===
[1] ftrace - test for function traceon/off triggers     [FAIL]
[2] (instance)  ftrace - test for function traceon/off triggers [UNSUPPORTED]

I look up the log, and it shows that the md5sum is different between csum1 and csum2.

++ cnt=611
++ sleep .1
+++ cnt_trace
+++ grep -v '^#' trace
+++ wc -l
++ cnt2=611
++ '[' 611 -ne 611 ']'
+++ cat tracing_on
++ on=0
++ '[' 0 '!=' 0 ']'
+++ md5sum trace
++ csum1='76896aa74362fff66a6a5f3cf8a8a500  trace'
++ sleep .1
+++ md5sum trace
++ csum2='ee8625a21c058818fc26e45c1ed3f6de  trace'
++ '[' '76896aa74362fff66a6a5f3cf8a8a500  trace' '!=' 'ee8625a21c058818fc26e45c1ed3f6de  trace' ']'
++ fail 'Tracing file is still changing'
++ echo Tracing file is still changing
Tracing file is still changing
++ exit_fail
++ exit 1

So I directly dump the trace file before md5sum, the diff shows that:

[root@localhost]# diff trace_1.log trace_2.log -y --suppress-common-lines
dockerd-12285   [036] d.... 18385.510290: sched_stat | <...>-12285   [036] d.... 18385.510290: sched_stat
dockerd-12285   [036] d.... 18385.510291: sched_swit | <...>-12285   [036] d.... 18385.510291: sched_swit
<...>-740       [044] d.... 18385.602859: sched_stat | kworker/44:1-740 [044] d.... 18385.602859: sched_stat
<...>-740       [044] d.... 18385.602860: sched_swit | kworker/44:1-740 [044] d.... 18385.602860: sched_swit

And we can see that <...> filed be filled with names.

We can strip off the names there to fix that.

After strip off the names:

kworker/u257:0-12 [019] d..2.  2528.758910: sched_stat | -12 [019] d..2.  2528.758910: sched_stat_runtime: comm=k
kworker/u257:0-12 [019] d..2.  2528.758912: sched_swit | -12 [019] d..2.  2528.758912: sched_switch: prev_comm=kw
<idle>-0          [000] d.s5.  2528.762318: sched_waki | -0  [000] d.s5.  2528.762318: sched_waking: comm=sshd pi
<idle>-0          [037] dNh2.  2528.762326: sched_wake | -0  [037] dNh2.  2528.762326: sched_wakeup: comm=sshd pi
<idle>-0          [037] d..2.  2528.762334: sched_swit | -0  [037] d..2.  2528.762334: sched_switch: prev_comm=sw

Link: https://lore.kernel.org/r/20230818013226.2182299-1-zouyipeng@huawei.com
Fixes: d87b29179aa0 ("selftests: ftrace: Use md5sum to take less time of checking logs")
Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/test.d/ftrace/func_traceonoff_triggers.tc |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_traceonoff_triggers.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_traceonoff_triggers.tc
@@ -90,9 +90,10 @@ if [ $on != "0" ]; then
     fail "Tracing is not off"
 fi
 
-csum1=`md5sum trace`
+# Cannot rely on names being around as they are only cached, strip them
+csum1=`cat trace | sed -e 's/^ *[^ ]*\(-[0-9][0-9]*\)/\1/' | md5sum`
 sleep $SLEEP_TIME
-csum2=`md5sum trace`
+csum2=`cat trace | sed -e 's/^ *[^ ]*\(-[0-9][0-9]*\)/\1/' | md5sum`
 
 if [ "$csum1" != "$csum2" ]; then
     fail "Tracing file is still changing"


