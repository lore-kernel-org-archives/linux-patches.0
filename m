Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A7B357CEC;
	Sat, 12 Sep 2026 09:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205645; cv=none; b=Qw9Y/okMp70iaKw19GllndHBhZOwX2ZwFBUtrsnYmdjJ5juv4rdMYZWDNNQIPx47x6a9ztnmdG16JFZhy4cQMyvtOq3nUXltwAlLjTr2wyfNtx8ZhLmX9CoX2F0qiKrangJIxMmza1S9Y9EL4Mx5id3CIkwY3S3EVr1X/lQLhZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205645; c=relaxed/simple;
	bh=gPhAS4s6aWScLjDkyPd/quEXKlKSVO7Rsey4wNoz2J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlPw9Vjcv07UAMkMTBzouI5E0s2fiMSbDzooQYUMVLw6uMX+9w5IJnUFAgcPrJsKC4qRL953ezJZX9MaH6SPGPj9Z8HyoEKO8RBDOJoJ8iPMLVenoiZZUEjP4+24Ddifgpv9t0hl6jRIYG9K5uhBL84wk4MhGf69JNQDvgW13K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uDQnIos; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uDQnIos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E861F000FF;
	Sat, 12 Sep 2026 09:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205644;
	bh=1exhiWxT225l0PhVrNFnPDdBD9Tg6PQqJ/oGrO3lbTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uDQnIos0PyIti9dlTAu4SgQ9Y8VVVsP7uxAhilBCR9maXRyBYpxLAQciabqZATzx
	 CUY9egAx+4izo36E7f7hrswvA14YvvPW67RkXewfr8l/L2Hb30b/lLHsvaExotRnr0
	 ZpnA5n2SZFMyWDJozK+9GvNOmVA0IopU3ln/e1kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0042/1518] ring-buffer: Allow splice reads on static buffers
Date: Sat, 12 Sep 2026 08:36:51 +0200
Message-ID: <20260912065624.386899357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 6365c44a824ff138e7926413932bb5c2e28a4c8c ]

ring_buffer_read_page() rejects splice (full=1) reads on static buffers
(that is user-mapped, persistent or remote) because !read check assumes
unread pages must be swapped. However for those buffers we have no other
choice than memcpy the data.

For the memcpy case, only return an error when the writer is still on
the reader page for the splice interface to wait.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901155445.1475405-2-vdonnefort@google.com
Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6739,15 +6739,8 @@ int ring_buffer_read_page(struct trace_b
 		unsigned int event_size;
 		unsigned int flags = 0;
 
-		/*
-		 * If a full page is expected, this can still be returned
-		 * if there's been a previous partial read and the
-		 * rest of the page can be read and the commit page is off
-		 * the reader page.
-		 */
-		if (full &&
-		    (!read || (len < (size - read)) ||
-		     cpu_buffer->reader_page == cpu_buffer->commit_page))
+		/* If a full page is requested, it cannot be the commit page */
+		if (full && cpu_buffer->reader_page == cpu_buffer->commit_page)
 			return -1;
 
 		if (len > (size - read))


