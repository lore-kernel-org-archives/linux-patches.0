Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFE524468C;
	Tue, 20 May 2025 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750780; cv=none; b=JxF3Cu8/GIZ6YANhviJAOCG2Y076s+uNFPw3zBnMZMUgUG0PW0fnOeq8PtRceNpLoOwPheSuRyFpX8Fr87LhhDpA+rSVdg0rsNzOlV6kuZBwCDnUrpVp18T4/CPOXibnUZHzWQ4ye86SBXAoNvPy4fFxq6CvCfB6kQzqyZkV1N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750780; c=relaxed/simple;
	bh=FdXQvkgwVV0IJKC3jsjhWmZYwtz37lT5nrQthcYQkbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0pB9gr/rtt2HE9SsTSPxsm8Dr/4HVynitP2TTO2N+PoY8Drc1WVwDwTvckMDffbFzeH8uufkjx1mCHyD0WhvjeCEFkzpQPMA/pd/K016BybNmjeiQRJ3poteCqCPFKOonaTmrszxKoZaP3RLHxnir9bwPUlhVL4lrduGYynQQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjQ0o1sU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjQ0o1sU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC837C4CEEA;
	Tue, 20 May 2025 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750780;
	bh=FdXQvkgwVV0IJKC3jsjhWmZYwtz37lT5nrQthcYQkbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjQ0o1sUQSO1UwUGxivnbQUA7rSp/pY1MjZVtx/2eitSsgxxnGr1aoS8qCkbeDGQn
	 5CRhhUoyk0L+mkEBpI3zapxBOB6JPW/oHB0iUoiLUncrpCTDTv0sAAYO0khux3dCls
	 OEpY7JAZxewVc9XEOe5SO0P+P4uPegkVGiQYzSyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tasos Sahanidis <tasos@tasossah.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.14 119/145] ring-buffer: Fix persistent buffer when commit page is the reader page
Date: Tue, 20 May 2025 15:51:29 +0200
Message-ID: <20250520125815.213016721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


