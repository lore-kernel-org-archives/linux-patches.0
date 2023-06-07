Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD56F10FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E119C433D2;
	Wed,  7 Jun 2023 20:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169721;
	bh=I5dI2m6v8X3HSe8O6A1jV4bxzjVtOYxcB4Ltr92prbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxitamd8VKVVvywh4/qZb5mvdAh0lnvgcoMP56SpFFxXq8OJz0G9HFb6J4DdXZTCs
	 Ubzz9aHIgdFPrqiL4udcCRA1unXa6CPrpRV0IKrTJUVwzZlBg6D3bp+9XznNyGnl8q
	 fLFs0SAW6w5I8Bj+u6OjU/a5zxc7niQrngAAYbgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 188/286] selftests/ftrace: Choose target function for filter test from samples
Date: Wed,  7 Jun 2023 22:14:47 +0200
Message-ID: <20230607200929.413807905@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit eb50d0f250e96ede9192d936d220cd97adc93b89 ]

Since the event-filter-function.tc expects the 'exit_mmap()' directly
calls 'kmem_cache_free()', this is vulnerable to code modifications.

Choose the target function for the filter test from the sample
event data so that it can keep test running correctly even if the caller
function name will be changed.

Link: https://lore.kernel.org/linux-trace-kernel/167919441260.1922645.18355804179347364057.stgit@mhiramat.roam.corp.google.com/

Link: https://lore.kernel.org/all/CA+G9fYtF-XEKi9YNGgR=Kf==7iRb2FrmEC7qtwAeQbfyah-UhA@mail.gmail.com/
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Fixes: 7f09d639b8c4 ("tracing/selftests: Add test for event filtering on function name")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../test.d/filter/event-filter-function.tc    | 45 +++++++++++--------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc b/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
index e2ff3bf4df80f..2de7c61d1ae30 100644
--- a/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
+++ b/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
@@ -9,18 +9,33 @@ fail() { #msg
     exit_fail
 }
 
-echo "Test event filter function name"
+sample_events() {
+    echo > trace
+    echo 1 > events/kmem/kmem_cache_free/enable
+    echo 1 > tracing_on
+    ls > /dev/null
+    echo 0 > tracing_on
+    echo 0 > events/kmem/kmem_cache_free/enable
+}
+
 echo 0 > tracing_on
 echo 0 > events/enable
+
+echo "Get the most frequently calling function"
+sample_events
+
+target_func=`cut -d: -f3 trace | sed 's/call_site=\([^+]*\)+0x.*/\1/' | sort | uniq -c | sort | tail -n 1 | sed 's/^[ 0-9]*//'`
+if [ -z "$target_func" ]; then
+    exit_fail
+fi
 echo > trace
-echo 'call_site.function == exit_mmap' > events/kmem/kmem_cache_free/filter
-echo 1 > events/kmem/kmem_cache_free/enable
-echo 1 > tracing_on
-ls > /dev/null
-echo 0 > events/kmem/kmem_cache_free/enable
 
-hitcnt=`grep kmem_cache_free trace| grep exit_mmap | wc -l`
-misscnt=`grep kmem_cache_free trace| grep -v exit_mmap | wc -l`
+echo "Test event filter function name"
+echo "call_site.function == $target_func" > events/kmem/kmem_cache_free/filter
+sample_events
+
+hitcnt=`grep kmem_cache_free trace| grep $target_func | wc -l`
+misscnt=`grep kmem_cache_free trace| grep -v $target_func | wc -l`
 
 if [ $hitcnt -eq 0 ]; then
 	exit_fail
@@ -30,20 +45,14 @@ if [ $misscnt -gt 0 ]; then
 	exit_fail
 fi
 
-address=`grep ' exit_mmap$' /proc/kallsyms | cut -d' ' -f1`
+address=`grep " ${target_func}\$" /proc/kallsyms | cut -d' ' -f1`
 
 echo "Test event filter function address"
-echo 0 > tracing_on
-echo 0 > events/enable
-echo > trace
 echo "call_site.function == 0x$address" > events/kmem/kmem_cache_free/filter
-echo 1 > events/kmem/kmem_cache_free/enable
-echo 1 > tracing_on
-sleep 1
-echo 0 > events/kmem/kmem_cache_free/enable
+sample_events
 
-hitcnt=`grep kmem_cache_free trace| grep exit_mmap | wc -l`
-misscnt=`grep kmem_cache_free trace| grep -v exit_mmap | wc -l`
+hitcnt=`grep kmem_cache_free trace| grep $target_func | wc -l`
+misscnt=`grep kmem_cache_free trace| grep -v $target_func | wc -l`
 
 if [ $hitcnt -eq 0 ]; then
 	exit_fail
-- 
2.39.2



