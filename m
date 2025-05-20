Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC312500DF;
	Tue, 20 May 2025 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750322; cv=none; b=EOCSSVQtXVMwBsmCvJr/5jnPjnOkRC9mDv29sVQAsuocxF08Ns0gvZaz0B0nDEKIYqIcQl0R+b8G080UKe65YcUIH33cYBKg/xuu2+82pV3hwduq89VBWWhzrLZpkcVvr3pQ65441UA1k9NZcaCopL0U1ZxYXi7otOFazzb19Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750322; c=relaxed/simple;
	bh=Dsz78Ddd3rkCRnek972+rfmCEeOTw0txZMDFt7F7tGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fs7qTEz7KHyRALBfKJr0FhmGynFfUAt6p28c4YIekJuK4iHQvqKQHp70rmWnftCm2sm1iu4eW2KYv+1NYIU23N8QV/TNZNrlT6TtsrZ/mMIIeO+93M9cV43VUW0UWOuHCKRYiYgrxBD6jA8Z2ayBbrXW8G7xzpTOS50WoFoy39U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjNgT6QP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjNgT6QP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DB9C4CEE9;
	Tue, 20 May 2025 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750322;
	bh=Dsz78Ddd3rkCRnek972+rfmCEeOTw0txZMDFt7F7tGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjNgT6QPsmh4xhILl2z1kgF3HG7E2ssi+4fNfBKP5kzyUzqGwno9Huh9qb+Jxu5oI
	 fU09RjHSf+3rsN+iky6T5bQTOzjQ8/Bb79qhoPhrRj0KT6Tg8UUsYVQgP0/Vjp/mnI
	 YoVM7x17R8bKck8xkvrSiVbf815i+Ir9sByPKXbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tasos Sahanidis <tasos@tasossah.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 115/143] ring-buffer: Fix persistent buffer when commit page is the reader page
Date: Tue, 20 May 2025 15:51:10 +0200
Message-ID: <20250520125814.557231606@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

commit 1d6c39c89f617c9fec6bbae166e25b16a014f7c8 upstream.

The ring buffer is made up of sub buffers (sometimes called pages as they
are by default PAGE_SIZE). It has the following "pages":

  "tail page" - this is the page that the next write will write to
  "head page" - this is the page that the reader will swap the reader page with.
  "reader page" - This belongs to the reader, where it will swap the head
                  page from the ring buffer so that the reader does not
                  race with the writer.

The writer may end up on the "reader page" if the ring buffer hasn't
written more than one page, where the "tail page" and the "head page" are
the same.

The persistent ring buffer has meta data that points to where these pages
exist so on reboot it can re-create the pointers to the cpu_buffer
descriptor. But when the commit page is on the reader page, the logic is
incorrect.

The check to see if the commit page is on the reader page checked if the
head page was the reader page, which would never happen, as the head page
is always in the ring buffer. The correct check would be to test if the
commit page is on the reader page. If that's the case, then it can exit
out early as the commit page is only on the reader page when there's only
one page of data in the buffer. There's no reason to iterate the ring
buffer pages to find the "commit page" as it is already found.

To trigger this bug:

  # echo 1 > /sys/kernel/tracing/instances/boot_mapped/events/syscalls/sys_enter_fchownat/enable
  # touch /tmp/x
  # chown sshd /tmp/x
  # reboot

On boot up, the dmesg will have:
 Ring buffer meta [0] is from previous boot!
 Ring buffer meta [1] is from previous boot!
 Ring buffer meta [2] is from previous boot!
 Ring buffer meta [3] is from previous boot!
 Ring buffer meta [4] commit page not found
 Ring buffer meta [5] is from previous boot!
 Ring buffer meta [6] is from previous boot!
 Ring buffer meta [7] is from previous boot!

Where the buffer on CPU 4 had a "commit page not found" error and that
buffer is cleared and reset causing the output to be empty and the data lost.

When it works correctly, it has:

  # cat /sys/kernel/tracing/instances/boot_mapped/trace_pipe
        <...>-1137    [004] .....   998.205323: sys_enter_fchownat: __syscall_nr=0x104 (260) dfd=0xffffff9c (4294967196) filename=(0xffffc90000a0002c) user=0x3e8 (1000) group=0xffffffff (4294967295) flag=0x0 (0

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250513115032.3e0b97f7@gandalf.local.home
Fixes: 5f3b6e839f3ce ("ring-buffer: Validate boot range memory events")
Reported-by: Tasos Sahanidis <tasos@tasossah.com>
Tested-by: Tasos Sahanidis <tasos@tasossah.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1832,10 +1832,12 @@ static void rb_meta_validate_events(stru
 
 	head_page = cpu_buffer->head_page;
 
-	/* If both the head and commit are on the reader_page then we are done. */
-	if (head_page == cpu_buffer->reader_page &&
-	    head_page == cpu_buffer->commit_page)
+	/* If the commit_buffer is the reader page, update the commit page */
+	if (meta->commit_buffer == (unsigned long)cpu_buffer->reader_page->page) {
+		cpu_buffer->commit_page = cpu_buffer->reader_page;
+		/* Nothing more to do, the only page is the reader page */
 		goto done;
+	}
 
 	/* Iterate until finding the commit page */
 	for (i = 0; i < meta->nr_subbufs + 1; i++, rb_inc_page(&head_page)) {


