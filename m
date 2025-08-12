Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C91626FA77;
	Tue, 12 Aug 2025 19:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025631; cv=none; b=YzsVr3/NEoCVOWMFl/3EpVS8s4JVrRGQb+vQgOUomIvV6TwaJzdGZJUhoeqIiR55BaohpdaWQz9lssbpcDyLUHBNdz4726ETFlyzdr9xUwbouFVSizHraV3DprRpIHYUvp2t8Z0cWt8OwZHPO+aRENI3bPXwFVvYf6mhh+ufnFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025631; c=relaxed/simple;
	bh=on0qBTCUzYiia6V3n2ZA/k5AGXR2eEbzIIVjWWQNRms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB9nYRI2yKwE9Hnj6L/Jr3CdIDkxTLyIOwbhUXzriV3QfoFiKppJqZONGUz1YsEmIX4ZwtIU4hxvckfCo1j97rIP++jhO3EPxOiE2N9qM0fFLcuSzsr3PoCUw424FOTuoy0T6z0uCYHTTzb2dFrssA1zkYtFaK9r6Q+OYdBhIDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2HJkZKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2HJkZKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099F8C4CEF1;
	Tue, 12 Aug 2025 19:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025631;
	bh=on0qBTCUzYiia6V3n2ZA/k5AGXR2eEbzIIVjWWQNRms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2HJkZKxyncCmTK5VJwA7+VPlTPS92zgnO8iFfY0yXNczaU3IP2ArGUaBbuzU5VLf
	 JGkE9pdd1q5BWUUQM2K0mR/5gJEq0/ouxBGdtiDgQMhdx5/Vn0F9Yi6pTJ62am1ppW
	 QltAqw56trEdw+RZn2vIY4MaHD4LCpEPUC3EYUhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 098/480] selftests/tracing: Fix false failure of subsystem event test
Date: Tue, 12 Aug 2025 19:45:06 +0200
Message-ID: <20250812174401.505242262@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



