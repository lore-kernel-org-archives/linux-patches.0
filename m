Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856DA351C04;
	Fri,  4 Sep 2026 05:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499662; cv=none; b=Hj/VhX8a1H05nZE8GXl58jj9A0G0H5OAwZl68bLB81B7pMnKl/MKgCsmQvTWTJoGi3iGYfYUcDjf0WUvvYWteTxa6borULY4Ydeqz/0C5Kz8199IhMcWE22qbjYRoBc+XDuFqscv72/W9t+RPIdfB59nZrAkJhinm6rTfJe+p1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499662; c=relaxed/simple;
	bh=6W8UaCJ/MS4W82TAEaMQqMNzfQapTfYDEK8J9pSRSOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKFfnkOf5lJy4d/bWEOpykUoDoR0RyGq1pi5i7wI+7C3h8wJ8B7MByV3IxjfTFzNitu+XHd5KGSxug1cmfX8bg4BqDjG7PusRFs3EOM1c+4mXm3EwxnLL7yteVvls7I6RMaQ5Q1K/ZE4uX3ODtrKqgq6TErWifensD2XE18IAbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/DRSxMm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/DRSxMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6191F00A3D;
	Fri,  4 Sep 2026 05:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499661;
	bh=Js3+mBqonWCP0jwdioAvl8yr+xv15ZkYxbyKohfBUM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/DRSxMmFBQzVQfC8HiDmEnMPqlB9TrrD/dXF/VMKiNMRKJwSz66ymce7ag+u5t3s
	 y2aopWxjvPhTiTjpjwz+quZ7qahWPRC+4UE9G5zjdihvf8EzRwdlLYtetnEgc0T680
	 lvHkNi8B9mvtV8X0Er7XQG05tjNETLHofv4NVCKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 453/713] ring-buffer: Free cpu_buffer::free_page with subbuf_order
Date: Fri,  4 Sep 2026 06:57:01 +0200
Message-ID: <20260904045813.980989235@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

commit 234b1a72e9706fe20c08c96f4374ec8e83b934cb upstream.

When sub-buffers use an order greater than 0, cpu_buffer->free_page is
allocated with subbuf_order. Use the correct order for
cpu_buffer->free_page.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260813131152.3589632-2-vdonnefort@google.com
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260806211306.3704194-1-vdonnefort%40google.com # patch 3
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2672,7 +2672,7 @@ static void rb_free_cpu_buffer(struct ri
 		free_buffer_page(bpage);
 	}
 
-	free_page((unsigned long)cpu_buffer->free_page);
+	free_pages((unsigned long)cpu_buffer->free_page, cpu_buffer->buffer->subbuf_order);
 
 	kfree(cpu_buffer);
 }


