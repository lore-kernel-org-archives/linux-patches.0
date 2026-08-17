Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721AF43BDD2;
	Mon, 17 Aug 2026 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974623; cv=none; b=EUloUkEQLSmibnzvNLnNH6Q2qeZsWv/zRO4Vm3AkKdZ8d+3ZIoliUn2XG9PSePIKUaRh1QvKQMUkCZTduV1WYCsNx/4LUarQ/QcdJjkSAky0gRY7KlgqkhQayRw1mMF1YItSomxn6T9vEO2YZwWphWnEtG/rngu+lKHHOBxMlZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974623; c=relaxed/simple;
	bh=HWTfLZob+P/gqJTLH147eBGNY+2I5vI9a6k6HKyn77Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDOGDk8v1v70u37ttL5oHUERNFYhVQtWIaKQimKYYmxdME9L0jq7bui3+hn/rjN3Su+W7Lp3o5CF/HYDbvw0VZ8tbUpCuMB4YJHBDmhko+oXqAFgw+BXRMXeJ0K0UcUC19Qscewva4q/S6Ilie1vU2yHYliixmKO6QFGJTlwl7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFK8sYz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFK8sYz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD431F00A3E;
	Mon, 17 Aug 2026 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974617;
	bh=oUX4CnRCy7jZfua4dNpgsuy+6e8C1Tqn4yuaaSeiyZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFK8sYz7TP5KVFWpI9KrCSkLOlvDBk7BHxOyOOUtMpjyn3u6U65OLdrDXKVAKt0/y
	 Mjx8PLCtqQOfJqXMvqZiRQT4ESim4rDeLkaB16XwUztqlbeiN3kg8tTsZDw5oKDVbG
	 Dmj87ygCWSLz4NTd3xhTXF958n2N1HA9I5uqJzQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 250/271] ring-buffer: Initialise reader page order in rb_allocate_cpu_buffer()
Date: Mon, 17 Aug 2026 15:32:55 +0200
Message-ID: <20260817132547.030688352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

commit 6d014e44b68ddd43f71288d2a4dbb1a259869149 upstream.

In rb_allocate_cpu_buffer(), bpage->order was omitted, leaving it as 0.
This is an issue for a ring-buffer with subbufs bigger than PAGE_SIZE if
when freed: free_buffer_page() relies on this value. Align the value
with the actual allocation size (buffer::subbuf_order).

Cc: stable@vger.kernel.org
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Link: https://patch.msgid.link/20260806211306.3704194-4-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2400,6 +2400,7 @@ rb_allocate_cpu_buffer(struct trace_buff
 	bpage = alloc_cpu_page(cpu);
 	if (!bpage)
 		return NULL;
+	bpage->order = cpu_buffer->buffer->subbuf_order;
 
 	rb_check_bpage(cpu_buffer, bpage);
 


