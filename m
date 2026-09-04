Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA64F3EE1FC;
	Fri,  4 Sep 2026 06:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502523; cv=none; b=a4KyEWTGQUZb4CHIcEyeVaU3u1I8aTH2yjOeF8JQSWCghtkOYTqsbapSN0oQnDK0cGTCYm1EcZpk3FxYEoU/A4lGjfC7CT28Mafyc3dP8oA0E3TCr6p+uyg1b4raUcEvOeGLKrkp5B+lfojf6THnuYWqLCsrtn5j1N5iltPtkSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502523; c=relaxed/simple;
	bh=sBmJDFL8xbYljcPebznySvHxjJkEbhFQNXVhoYIDCO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccTrijv1FH4kns44LLLyG389y2FEBYPZbDXCACqxBYRfZOJbwZSJUIBgAhqoBPfV2eMR3Sb3KanHaIEW/myypltHB8GLYrsseK2Z40tjtCKX6lAEi/RE8yLHO0eITlr6nO22VTDES2t5cxu46mNZPSx4Thlx6zYnMtAqu0mKs6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M66cmaFC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M66cmaFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95941F00A3D;
	Fri,  4 Sep 2026 06:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502522;
	bh=AlPF8WEYP8k4SO1JUliAR5t9LhnyFXFcG4OfRGh5weU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M66cmaFCkjtaByDdCCDOoQakrEWV4cN3/sDU8yw7JaQX8+TUpb6mcyGSjHvXvT3T1
	 GynBAs7fnbZuzp/Tp8cw+ht7vMHDspBGfF7BUAgUdD+3j1LnQXTrgZLDVVbxQ+XbK3
	 nnIrRPvo0tv/vJyJP+d/G8ZWNeqEPslKEO9Sizcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 238/403] ring-buffer: Free cpu_buffer::free_page with subbuf_order
Date: Fri,  4 Sep 2026 07:00:41 +0200
Message-ID: <20260904045740.282969541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -2316,7 +2316,7 @@ static void rb_free_cpu_buffer(struct ri
 		free_buffer_page(bpage);
 	}
 
-	free_page((unsigned long)cpu_buffer->free_page);
+	free_pages((unsigned long)cpu_buffer->free_page, cpu_buffer->buffer->subbuf_order);
 
 	kfree(cpu_buffer);
 }


