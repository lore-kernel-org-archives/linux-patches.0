Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5341DC148;
	Tue, 29 Apr 2025 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948945; cv=none; b=g3MIDdzXXy55n3CFsfaA+v+VesZLOVoVTuoc5DVk0StNc7oeX8+YqJ5Sd0cXt6owzF2MLChqi+gfELOEuSa7qyWclOt4ujjbmW7K78BsJB2NhnmQMUrlVC1Y5K6AdZY+5SSZxD6TNk0Q7/MIwTZ+b994nL1sj0oUCaqF9yfKSFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948945; c=relaxed/simple;
	bh=yiPk8fX33KCZT/9BmXKkaHRQ64uPbqhcf2nBqt0IAAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPsEyZstHuwg51aJLJg1Li330Pwb6sN2RG19rznlaGDIfCg6+pjv83Hzxxuz2/aT5B+AyZFWwguIj45YzDue1Q3HunMd0Wic7F2dnTCG3KigBR8wsyNkMgIlnrvPN5PXDytliUnws/WKpL7bEaaljJrr6ZFB4yI0LtNER7y4TbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ip34pW+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ip34pW+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF371C4CEE3;
	Tue, 29 Apr 2025 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948945;
	bh=yiPk8fX33KCZT/9BmXKkaHRQ64uPbqhcf2nBqt0IAAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ip34pW+q5i4PQXDl2iYs07P8jNqMgFTNmYPZ8N1poALyjq1paR9qlMrWurl/dBRhn
	 pIInjTGHDjvCO3HmloP7Mk5rY/TFZKFJ4qt1yRD44/I4IbXPIMFuLbDQJqoCUncz5q
	 IVtcVAZpQO9IfIqWXp3Uah9hWkNXuKt9Xc5tecmU=
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
Subject: [PATCH 5.15 171/373] tracing: Fix filter string testing
Date: Tue, 29 Apr 2025 18:40:48 +0200
Message-ID: <20250429161130.207325507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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
@@ -676,7 +676,7 @@ static __always_inline char *test_string
 	kstr = ubuf->buffer;
 
 	/* For safety, do not trust the string pointer */
-	if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
+	if (strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE) < 0)
 		return NULL;
 	return kstr;
 }
@@ -695,7 +695,7 @@ static __always_inline char *test_ustrin
 
 	/* user space address? */
 	ustr = (char __user *)str;
-	if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
+	if (strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE) < 0)
 		return NULL;
 
 	return kstr;


