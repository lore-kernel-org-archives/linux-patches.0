Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7A428DDA;
	Fri,  5 Jan 2024 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rfrvsw4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE2DC433C8;
	Fri,  5 Jan 2024 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465841;
	bh=Re8QA32xIRdZW+mPYvG+S7krtPw5DpAqFz7xbaXg01w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rfrvsw4zKVSlsG8Vlw7SjQiJEMI5SvrxYqLkEdd+4KO46Q5vjhkoG4VBlFwEb7qN/
	 +uhDiiOlgnUAmpFH4LAABeiPR1EitoVDft7YV3j5Uun60kTy6niC2CisYfsMtPy1Zy
	 eC7lSyY7GSgpNhboNEHgNKdq1XuR5thvDqBf/oHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 46/47] ring-buffer: Fix wake ups when buffer_percent is set to 100
Date: Fri,  5 Jan 2024 15:39:33 +0100
Message-ID: <20240105143817.430859607@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 623b1f896fa8a669a277ee5a258307a16c7377a3 upstream.

The tracefs file "buffer_percent" is to allow user space to set a
water-mark on how much of the tracing ring buffer needs to be filled in
order to wake up a blocked reader.

 0 - is to wait until any data is in the buffer
 1 - is to wait for 1% of the sub buffers to be filled
 50 - would be half of the sub buffers are filled with data
 100 - is not to wake the waiter until the ring buffer is completely full

Unfortunately the test for being full was:

	dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
	return (dirty * 100) > (full * nr_pages);

Where "full" is the value for "buffer_percent".

There is two issues with the above when full == 100.

1. dirty * 100 > 100 * nr_pages will never be true
   That is, the above is basically saying that if the user sets
   buffer_percent to 100, more pages need to be dirty than exist in the
   ring buffer!

2. The page that the writer is on is never considered dirty, as dirty
   pages are only those that are full. When the writer goes to a new
   sub-buffer, it clears the contents of that sub-buffer.

That is, even if the check was ">=" it would still not be equal as the
most pages that can be considered "dirty" is nr_pages - 1.

To fix this, add one to dirty and use ">=" in the compare.

Link: https://lore.kernel.org/linux-trace-kernel/20231226125902.4a057f1d@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Fixes: 03329f9939781 ("tracing: Add tracefs file buffer_percentage")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -579,9 +579,14 @@ static __always_inline bool full_hit(str
 	if (!nr_pages || !full)
 		return true;
 
-	dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+	/*
+	 * Add one as dirty will never equal nr_pages, as the sub-buffer
+	 * that the writer is on is not counted as dirty.
+	 * This is needed if "buffer_percent" is set to 100.
+	 */
+	dirty = ring_buffer_nr_dirty_pages(buffer, cpu) + 1;
 
-	return (dirty * 100) > (full * nr_pages);
+	return (dirty * 100) >= (full * nr_pages);
 }
 
 /*


