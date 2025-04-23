Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5345328B4E4;
	Wed, 23 Apr 2025 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422396; cv=none; b=E7SkajuE2fp2Q4Bm64wSer8Of9PusEh4Xy5Twa+wn3ab3Xr4l2djqHkUrZ3ALRaXwacN9R2k+L153/YXwRZxqsVJArUtNfUl4/PDy53IwFdma5u4bOYrKZreLfvYE0T5YcG5UdFmZAf87DMz/CS9lovfTJrkRQ6tf3208ZRew0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422396; c=relaxed/simple;
	bh=qFCdy2tDQBg0QOrwlgOGnIC2pDtXzKkTV9VAlNUSu6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvcvOCWVd7Vw0gH+J7WspLahbplCAQF1USflDqJhIfw3UPksNYa/lXDTyqqVqMuqT7j2Q+IRc0eXVNhldHeWeWC43uEE7mxSAwAPT7h2cfG12EqZPBN6xfw4WIApWllesaufnHskgc5nN5PIWRf0LdxEVPlJq/ttOGDIh1lBNFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGfAY2CD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGfAY2CD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75387C4CEE2;
	Wed, 23 Apr 2025 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422393;
	bh=qFCdy2tDQBg0QOrwlgOGnIC2pDtXzKkTV9VAlNUSu6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGfAY2CD3OWejkKgeA8luoUoK9YVQ3pNS3yHYnH89x4utU+K/s2TO6ioq4jJNVsW5
	 CFl+I+ngyTO8JjuJK5O3XKmJCBzr5FYETascWYl+c/w3/KrHAgep9boeTm/aW79W0B
	 3JsT/Uz5AQIu3/cMqLnNENi69Xf6c3YpL4jdSFQ4=
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
Subject: [PATCH 6.6 334/393] tracing: Fix filter string testing
Date: Wed, 23 Apr 2025 16:43:50 +0200
Message-ID: <20250423142657.134025077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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


