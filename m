Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1732127FD7A;
	Wed, 23 Apr 2025 15:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420456; cv=none; b=uQJC7SmwQJK6wvlZ5ZOTuF8MNOdPz58mzV/wu5JB2lnPS/hJM/Ccd80Jo+1HwtcopNjUghPXcY4QMf1w/IbQ/2BMt1MNGg1uhi91LD/MkRYspILjSWBpcY2TZLzhqkE7lBjm8dKpUWCF359Qc69+NQQSQ0u/kqLMBzZFPfj0cL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420456; c=relaxed/simple;
	bh=18xYFtwhXwqYSje0wMT4he8NIMPtPWldlsJh0E+U3wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg4nIGcsX1nkQi4A0od88yH/+5oArD8F5wCaLZQpY2QxLE9A9uXu2V469aatoafP1Alp3glOI+t2BF5U9WNgBHWzEINPGg6vkobIYeymEYcwWHscHkxEmejTDiXJYsYHr7SLCr+Q/d6qEpc2QanEdLWQt77wlXnzG2MQI+V41kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEsRyPaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEsRyPaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9788FC4CEE2;
	Wed, 23 Apr 2025 15:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420455;
	bh=18xYFtwhXwqYSje0wMT4he8NIMPtPWldlsJh0E+U3wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEsRyPaW+eGPkSU/RFZIcWIUcaLMWcXLuTEi0ZeYm7uQYduDd4+SaTXfjy2sM0JBF
	 wN75Dn/DkU99iKxdPs8QmK/gJauVZz2pGGlzJhnjF+k43PO6O6G93jGsw4jSAKSS/N
	 GCaXA2+niu5qSqIbsKd0+5jFq+y5btJLyi0QXcis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 133/223] tracing: Fix filter string testing
Date: Wed, 23 Apr 2025 16:43:25 +0200
Message-ID: <20250423142622.509138169@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit a8c5b0ed89a3f2c81c6ae0b041394e6eea0e7024 upstream.

The filter string testing uses strncpy_from_kernel/user_nofault() to
retrieve the string to test the filter against. The if() statement was
incorrect as it considered 0 as a fault, when it is only negative that it
faulted.

Running the following commands:

  # cd /sys/kernel/tracing
  # echo "filename.ustring ~ \"/proc*\"" > events/syscalls/sys_enter_openat/filter
  # echo 1 > events/syscalls/sys_enter_openat/enable
  # ls /proc/$$/maps
  # cat trace

Would produce nothing, but with the fix it will produce something like:

      ls-1192    [007] .....  8169.828333: sys_openat(dfd: ffffffffffffff9c, filename: 7efc18359904, flags: 80000, mode: 0)

Link: https://lore.kernel.org/all/CAEf4BzbVPQ=BjWztmEwBPRKHUwNfKBkS3kce-Rzka6zvbQeVpg@mail.gmail.com/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/20250417183003.505835fb@gandalf.local.home
Fixes: 77360f9bbc7e5 ("tracing: Add test for user space strings when filtering on string pointers")
Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Reported-by: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_filter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -808,7 +808,7 @@ static __always_inline char *test_string
 	kstr = ubuf->buffer;
 
 	/* For safety, do not trust the string pointer */
-	if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
+	if (strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE) < 0)
 		return NULL;
 	return kstr;
 }
@@ -827,7 +827,7 @@ static __always_inline char *test_ustrin
 
 	/* user space address? */
 	ustr = (char __user *)str;
-	if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
+	if (strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE) < 0)
 		return NULL;
 
 	return kstr;


