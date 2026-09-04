Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A423938E8DD;
	Fri,  4 Sep 2026 05:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499670; cv=none; b=mYjpg6b8akbLP25jgSY+m4GWzuUxyG9M4H/awC+Kk9MZxIk0gBJ81ZR7E2uUoAQ8GjWnmupxcdWLYuPTQpCstBVuL0WpWf6GBBgNDPXquf2nr9xENEpimTyv7/I2DZtUhNZHDTaw4aTYQT6AcXo30YsWX49NIbAymVdrtBBMT4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499670; c=relaxed/simple;
	bh=nlCjoq+vFIRfnjhv8jVJoLxRfjtctkwQQXc5VonuOs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmWXBMwfRqyBQoH/pWV63vRwTYm3i0FdllQ+oQO6xJ/OEe4Fn2DHH0Iilcp65ntdXsx3O2R5qqffG2Jeyxr/viNfta4dOFL9Vta2NFuRJ4XsPEe6QzIjbKPhLKV+zLKPTa6fGbyp3j3brWdr41o+7sksL6Hs1GJRU52WJ9TaWWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px4YOjFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px4YOjFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD851F00A3D;
	Fri,  4 Sep 2026 05:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499669;
	bh=cWff1+XTKqSKnHpvDQ0qa39aSOsoE7wDdqpgBBJfx3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=px4YOjFzCo4VVe3o/MFiKv+1EmGEbGDX0ci0FR73Yd3tgOoEN/1NxGALESy3ACBmM
	 fm58RJdRpKU44HzfrLdep0qHhs8rqRcP2WB7JI55VyO3oxM+56fR1P4vJN4x888pU2
	 lzJ0wapxwLS6GNCxmsnDY2VaAZhcLOzqgZRNqXRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Immanuel Shaji <ivanimmanuel1234@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 456/713] ring-buffer: Stop remote reader update when page swap fails
Date: Fri,  4 Sep 2026 06:57:04 +0200
Message-ID: <20260904045814.047778235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Immanuel Shaji <ivanimmanuel1234@gmail.com>

commit 5eab74874d11160725c42ab676ba97a797a362eb upstream.

The remote swap_reader_page callback can return -EBUSY when the writer
moves the head before the remote catches it, particularly during an event
storm on a small buffer. __rb_get_reader_page_from_remote() currently
warns about that failure but continues with the unchanged reader ID and
rearranges the local page list as though the swap succeeded.

Handle the callback failure as a recoverable error. Report it with
pr_warn_ratelimited() and return NULL. Callers already handle a NULL reader
page as a failed attempt. This avoids splicing the same page as both the
previous and new reader without flooding the log under contention.

Cc: stable@vger.kernel.org
Fixes: 2e67fabd8b77 ("ring-buffer: Introduce ring-buffer remotes")
Link: https://patch.msgid.link/20260825-kernel-patch-1-v2-2-bb3461807a32@gmail.com
Assisted-by: LLM sparse
Signed-off-by: Ivan Immanuel Shaji <ivanimmanuel1234@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5791,8 +5791,11 @@ __rb_get_reader_page_from_remote(struct
 
 	prev_reader = cpu_buffer->subbuf_ids[cpu_buffer->meta_page->reader.id];
 
-	WARN_ON_ONCE(cpu_buffer->remote->swap_reader_page(cpu_buffer->cpu,
-							  cpu_buffer->remote->priv));
+	if (cpu_buffer->remote->swap_reader_page(cpu_buffer->cpu,
+						 cpu_buffer->remote->priv)) {
+		pr_warn_ratelimited("Remote reader page swap failed\n");
+		return NULL;
+	}
 	/* nr_pages doesn't include the reader page */
 	if (WARN_ON_ONCE(cpu_buffer->meta_page->reader.id > cpu_buffer->nr_pages))
 		return NULL;


