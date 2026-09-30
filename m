Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC26A52842A;
	Wed, 30 Sep 2026 17:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789978; cv=none; b=egGSfozmslH18XUrIo+Olo3aozQSln8LktbjOODLHAPi7GGlwKpu1DUC3uiRNBBYf03AQ4yAmDZKWIZqGunwvbsr8OQjWw4eBQJ21yF2E1u3Vs4Yu6WzuNa2J4RVR8MUNgppDIZFhGUG1YgF5g1pSrSoVtgpZMTMw8Heuv20UyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789978; c=relaxed/simple;
	bh=Q1xgj2pSqUJFuHuJqtKw3AEvOgQGwBfiSPSravkyF9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVHeFs6qLlIeiSEgjgqimPKb4XZlWXcgAAoNRLb0bmHu5yuYgq7J9dIgcU07ZIWnIy6y2yP3BiaM528Oa7gLI41XabKbpKrGxC5ppfJnEVuBG519cnxIr91bSBreN7ViNCQdjDA0TgK/pHs5SAuAIR9UiYo0d6ueltDLnKRtNyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgPhI9/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgPhI9/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBB31F000FF;
	Wed, 30 Sep 2026 17:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789976;
	bh=TxEL7zDXnspZvsrWG2KozArp5TxteBQlsBR/yfQQ2d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgPhI9/KHu2WNxAe+BlbDYdJ8d8+ox1NCPbzJx/Od9+4ntm5YmNv8dNyG/qBclQNC
	 sHli5XOrhrNG/sOzwzbka9xxVgfWMbK+QODXQCQFdmhjZO8/zmICLm1ur3eOb+E5+N
	 jXcjg7fgkJttc5xwtkF1evNm0PVijJfsFP8scP5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 640/877] ring-buffer: Allow splice reads on static buffers
Date: Wed, 30 Sep 2026 17:25:51 +0200
Message-ID: <20260930152428.464010708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6591,15 +6591,8 @@ int ring_buffer_read_page(struct trace_b
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


