Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B84982871;
	Wed, 19 Jun 2024 13:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802308; cv=none; b=tBoq5cFdeQVIFfa2hLA1/ksfW1O71Ev/d3hTmb382vlpN9/1IJ0b/GoLh4Q/ahnA8R8+oa7EFfo0aP15ksjmhKMVWuGiLUxxLZtz+tETKMPdjO2xcaLv9tDSfwPT2CVQuD6v5fRFwgMdeKMQXJqC87DwSTVlWySpykFFDY2iIyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802308; c=relaxed/simple;
	bh=DAH2ASoU94eaL2iV9YT+SQblAbhoMq+0WlNYKE/Er9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMRV49WczBJOW6mONoondy3/+hgF5r8XvRzI/yxVs8Q2Yp+fmRDoSQO6VXzMbqYvv15uPPRttZkgOUPlHr4NS0ZOMwk5uWeQJmsQAKUbSi30R74EPWuUee3M5RNJEEaXlKMcXSF2ondWHsWRncnyStYNd2yAB4s2fzKF+9Fvt9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qi0sHPZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qi0sHPZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADB6C32786;
	Wed, 19 Jun 2024 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802308;
	bh=DAH2ASoU94eaL2iV9YT+SQblAbhoMq+0WlNYKE/Er9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi0sHPZ3N+zVA3gy2PPWs7l7EtOTgbIN+YiyIPzObtc/YHHtubGe5D55XgSGO+m3q
	 wb14QZGU6nk2Gaw0R4QVjd7K2pvtCCMVRGaUn6Xx0017GDMvmYBhCNybU2eM0cUiQv
	 f1C1YasjK9AoRsx3KsFjod1eHWGw1BxqyppvK71A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/267] selftests/tracing: Fix event filter test to retry up to 10 times
Date: Wed, 19 Jun 2024 14:54:32 +0200
Message-ID: <20240619125610.992867606@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 0f42bdf59b4e428485aa922bef871bfa6cc505e0 ]

Commit eb50d0f250e9 ("selftests/ftrace: Choose target function for filter
test from samples") choose the target function from samples, but sometimes
this test failes randomly because the target function does not hit at the
next time. So retry getting samples up to 10 times.

Fixes: eb50d0f250e9 ("selftests/ftrace: Choose target function for filter test from samples")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../test.d/filter/event-filter-function.tc    | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc b/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
index 3f74c09c56b62..118247b8dd84d 100644
--- a/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
+++ b/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
@@ -10,7 +10,6 @@ fail() { #msg
 }
 
 sample_events() {
-    echo > trace
     echo 1 > events/kmem/kmem_cache_free/enable
     echo 1 > tracing_on
     ls > /dev/null
@@ -22,6 +21,7 @@ echo 0 > tracing_on
 echo 0 > events/enable
 
 echo "Get the most frequently calling function"
+echo > trace
 sample_events
 
 target_func=`cat trace | grep -o 'call_site=\([^+]*\)' | sed 's/call_site=//' | sort | uniq -c | sort | tail -n 1 | sed 's/^[ 0-9]*//'`
@@ -32,7 +32,16 @@ echo > trace
 
 echo "Test event filter function name"
 echo "call_site.function == $target_func" > events/kmem/kmem_cache_free/filter
+
+sample_events
+max_retry=10
+while [ `grep kmem_cache_free trace| wc -l` -eq 0 ]; do
 sample_events
+max_retry=$((max_retry - 1))
+if [ $max_retry -eq 0 ]; then
+	exit_fail
+fi
+done
 
 hitcnt=`grep kmem_cache_free trace| grep $target_func | wc -l`
 misscnt=`grep kmem_cache_free trace| grep -v $target_func | wc -l`
@@ -49,7 +58,16 @@ address=`grep " ${target_func}\$" /proc/kallsyms | cut -d' ' -f1`
 
 echo "Test event filter function address"
 echo "call_site.function == 0x$address" > events/kmem/kmem_cache_free/filter
+echo > trace
+sample_events
+max_retry=10
+while [ `grep kmem_cache_free trace| wc -l` -eq 0 ]; do
 sample_events
+max_retry=$((max_retry - 1))
+if [ $max_retry -eq 0 ]; then
+	exit_fail
+fi
+done
 
 hitcnt=`grep kmem_cache_free trace| grep $target_func | wc -l`
 misscnt=`grep kmem_cache_free trace| grep -v $target_func | wc -l`
-- 
2.43.0



