Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D65473C9F;
	Fri,  7 Aug 2026 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117144; cv=none; b=lOOL3DqVR8SF0J95QWoc6fDMCa/jeT0qgDTDlQNNKUFisTRBT5QwRWmj0Pbtu0PT1IBsB4ruVIXEDJKaZUlgb4YBmomouAGfKf8QvKDx8R/k6DobWIqjVextYAznn+uYzor5g20iO3bR4jK5AtLUo0mbTHyJJgP3/70GRk2Lia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117144; c=relaxed/simple;
	bh=gvcFFIkWg9CWIprxOfykdQwEUnY/h51XEUS1jb8JIaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRTUO7QDJC9tFBzCl/pJxppaZvaYX0x/Rkn5xg6yS9rK4apgKAb7t9lGVnew6yoN8L6GzwjRBOKjo7DwlRAkgpOwIQcFgJ7gWUt8SNdutARibv20zXuXfTtmdZMsXZxXcM2bCZNq7DBwu4Y+FhL9QDnKSz93SKkFIYA4zxO1bIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvlSBP8X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvlSBP8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEE71F00A3A;
	Fri,  7 Aug 2026 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117143;
	bh=O0OR7nghDZLxKSgX61U9qIBr4PmoaEt7ef9QmjESgxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvlSBP8XqVLh47Q6Zt8Y8NkOoHXxHTQKGniRu1YGBWVnSFX9gpj9DC8iz7Ar2jwe/
	 NUD0O/tAAdHct6MNuzNdlRorSmuYzGNzabXpzqxgYBlINN9dWDoJJ+E9nEow8u9mOz
	 /aDlCzWMGA79WrICaME/aofwZTBX4Hsqn/dfBa6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Keir Fraser <keirf@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 171/438] ring-buffer: Fix reader page read offset for remote buffers
Date: Fri,  7 Aug 2026 16:36:07 +0200
Message-ID: <20260807143431.678040540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 78cd56c2a9d2e8da763cea3b06b636266ca66911 ]

A page swapped in by __rb_get_reader_page_from_remote() retains its
stale read offset, causing subsequent reads to skip events or read
past valid data. Fix it.

Link: https://patch.msgid.link/20260729133609.4022734-1-vdonnefort@google.com
Fixes: fbd1743ecba1 ("ring-buffer: Add non-consuming read for ring-buffer remotes")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Keir Fraser <keirf@google.com>
Tested-by: Keir Fraser <keirf@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index da9339466bddd..d896fb25de702 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5624,6 +5624,7 @@ __rb_get_reader_page_from_remote(struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->head_page = new_head;
 	cpu_buffer->reader_page = new_reader;
+	cpu_buffer->reader_page->read = 0;
 	cpu_buffer->pages = &new_head->list;
 	cpu_buffer->read_stamp = new_reader->page->time_stamp;
 	cpu_buffer->lost_events = cpu_buffer->meta_page->reader.lost_events;
-- 
2.53.0



