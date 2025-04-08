Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7E626A08A;
	Tue,  8 Apr 2025 12:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114805; cv=none; b=DQyJpzKGHXwqIHAWBhHN/bgiXj5vvMH34kRB1yFtqBexd1H7PHHft99uRKDYUhOrYLlaoIyjjhdiWXGKH5zUGAdt7lTKIrq/bLGAfLYIBhkdrLg6DygnUgkCmhWZDeQw+NmK/uWkIjd0rBNLAu87pCJoxpv1HsR5bquanSx586A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114805; c=relaxed/simple;
	bh=BOzkViWY6HicS6LT258cIFDcpVesjhv+PdwlhwgHFUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkEE9XAKdyxXhZVgx7gA2YxQV9v5iZfNJAEdQuLqst7dH+XNCLF8myfaJXEdmeFmi+Bxnk6rGHrl6Md2ENoYe4DGgPvp4F39tlszt4iAFbddj/lD7ACB5g8IjCPAUhLxMyksCjjYRPHUQizfTi4bCTORkii1Bux8Fhwq9BTY/78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jku5xUOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jku5xUOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85922C4CEE5;
	Tue,  8 Apr 2025 12:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114805;
	bh=BOzkViWY6HicS6LT258cIFDcpVesjhv+PdwlhwgHFUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jku5xUOTA8eNGa+30fMl9W24FHnZYphH9HbbqdfchG1r0ro3r12oPxz3b190Cm/Mc
	 tw/1RP4l7ZMDTc4W5W2wcuWBBsunGK527/gY10RmLFykN5OtR4wX/1Jpo89kC2OkkS
	 Km11fnhnxbt8TCkXHDR3HkICYE7ncxbykYvYPTOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Qiao Zhao <qzhao@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 240/499] perf test stat_all_pmu.sh: Correctly check perf stat result
Date: Tue,  8 Apr 2025 12:47:32 +0200
Message-ID: <20250408104857.201066132@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veronika Molnarova <vmolnaro@redhat.com>

[ Upstream commit 02ba09c8ab9406f30c5c63b7cfd4b300c3c2c32c ]

Test case "stat_all_pmu.sh" is not correctly checking 'perf stat' output
due to a poor design. Firstly, having the 'set -e' option with a trap
catching the sigexit causes the shell to exit immediately if 'perf stat' ends
with any non-zero value, which is then caught by the trap reporting an
unexpected signal. This causes events that should be parsed by the if-else
statement to be caught by the trap handler and are reported as errors:

    $ perf test -vv "perf all pmu"
    Testing i915/actual-frequency/
    Unexpected signal in main
    Error:
    Access to performance monitoring and observability operations is limited.

Secondly, the if-else branches are not exclusive as the checking if the
event is present in the output log covers also the "<not supported>"
events, which should be accepted, and also the "Bad name events", which
should be rejected.

Remove the "set -e" option from the test case, correctly parse the
"perf stat" output log and check its return value. Add the missing
outputs for the 'perf stat' result and also add logs messages to
report the branch that parsed the event for more info.

Fixes: 7e73ea40295620e7 ("perf test: Ignore security failures in all PMU test")
Signed-off-by: Veronika Molnarova <vmolnaro@redhat.com>
Tested-by: Qiao Zhao <qzhao@redhat.com>
Link: https://lore.kernel.org/r/20241122231233.79509-1-vmolnaro@redhat.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_pmu.sh | 48 ++++++++++++++++++--------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/tools/perf/tests/shell/stat_all_pmu.sh b/tools/perf/tests/shell/stat_all_pmu.sh
index 8b148b300be11..9c466c0efa857 100755
--- a/tools/perf/tests/shell/stat_all_pmu.sh
+++ b/tools/perf/tests/shell/stat_all_pmu.sh
@@ -2,7 +2,6 @@
 # perf all PMU test (exclusive)
 # SPDX-License-Identifier: GPL-2.0
 
-set -e
 err=0
 result=""
 
@@ -16,34 +15,55 @@ trap trap_cleanup EXIT TERM INT
 # Test all PMU events; however exclude parameterized ones (name contains '?')
 for p in $(perf list --raw-dump pmu | sed 's/[[:graph:]]\+?[[:graph:]]\+[[:space:]]//g')
 do
-  echo "Testing $p"
-  result=$(perf stat -e "$p" true 2>&1)
-  if echo "$result" | grep -q "$p"
+  echo -n "Testing $p -- "
+  output=$(perf stat -e "$p" true 2>&1)
+  stat_result=$?
+  if echo "$output" | grep -q "$p"
   then
     # Event seen in output.
-    continue
-  fi
-  if echo "$result" | grep -q "<not supported>"
-  then
-    # Event not supported, so ignore.
-    continue
+    if [ $stat_result -eq 0 ] && ! echo "$output" | grep -q "<not supported>"
+    then
+      # Event supported.
+      echo "supported"
+      continue
+    elif echo "$output" | grep -q "<not supported>"
+    then
+      # Event not supported, so ignore.
+      echo "not supported"
+      continue
+    elif echo "$output" | grep -q "No permission to enable"
+    then
+      # No permissions, so ignore.
+      echo "no permission to enable"
+      continue
+    elif echo "$output" | grep -q "Bad event name"
+    then
+      # Non-existent event.
+      echo "Error: Bad event name"
+      echo "$output"
+      err=1
+      continue
+    fi
   fi
-  if echo "$result" | grep -q "Access to performance monitoring and observability operations is limited."
+
+  if echo "$output" | grep -q "Access to performance monitoring and observability operations is limited."
   then
     # Access is limited, so ignore.
+    echo "access limited"
     continue
   fi
 
   # We failed to see the event and it is supported. Possibly the workload was
   # too small so retry with something longer.
-  result=$(perf stat -e "$p" perf bench internals synthesize 2>&1)
-  if echo "$result" | grep -q "$p"
+  output=$(perf stat -e "$p" perf bench internals synthesize 2>&1)
+  if echo "$output" | grep -q "$p"
   then
     # Event seen in output.
+    echo "supported"
     continue
   fi
   echo "Error: event '$p' not printed in:"
-  echo "$result"
+  echo "$output"
   err=1
 done
 
-- 
2.39.5



