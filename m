Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F9613D525;
	Wed, 19 Jun 2024 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802432; cv=none; b=qh+HOaXqa4V/8Fqq3yyTl+kybqlJ4oKjuMWx+6c/bPNvnYUN83YHsElE0nzxAgOlplM5xycetgtTiKzGT+c2TvIpTuK7QT1l4zD1Lsx2GQViOzUUVCJwy7Ac2fTX0MUGNhnfRGV+bx13P3rvdGjG3yUl3wr+rz5lZ9k3u16BSII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802432; c=relaxed/simple;
	bh=ZsjqtGCcUWl6iCJxE/UY+MG/EwnDyCbZiDupIwdjOxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd9ddUxHQomyLEsKypso7Z+Q5O2rFSueZQWKemskljyQKQu1pBEjRP4ziBMFu0VgFIc0cqtt3olLjpoKiEgXz/ZZmN+/ioK3J4nRYeHqY5dMp9R7XJoZnIj8gXmQin1KjAJnMXqNyJbS4ZtKVqS8876CVUqbGKBQkF0DyQpfrJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jv/bKfDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jv/bKfDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC65C32786;
	Wed, 19 Jun 2024 13:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802432;
	bh=ZsjqtGCcUWl6iCJxE/UY+MG/EwnDyCbZiDupIwdjOxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jv/bKfDe0Oetu+58N0fFbGkgkLe4f2IGKOseMM8A05QCrsIi+lXOIbQcTyUT8kRT3
	 U0NkAuTRgJZC4V6VcgzBzW0tBLWsn916G8PAkonNChqsxaA1D9EAWAB6DYm82LznxB
	 BXH5AinLhKupcDSgnAbZLDWS7vU7G2Fz1BlU711M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 195/267] tracing/selftests: Fix kprobe event name test for .isra. functions
Date: Wed, 19 Jun 2024 14:55:46 +0200
Message-ID: <20240619125613.819755521@linuxfoundation.org>
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


