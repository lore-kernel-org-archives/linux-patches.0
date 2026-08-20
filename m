Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FEA28C2BF;
	Thu, 20 Aug 2026 17:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247188; cv=none; b=bSh0CpUpAlItCfA4yayzYhOc1Cxa+J3WkIJ02xwfvWRss9DLVgvaTEjLzKEltw8rnhrphChqgZuRxbI+cKAMFg9kESt/OOF2XDAPbJQBjQvFfiPmvwnirzEpcyuuin8NAcjcEwO/Hgkr2vXRX1/YXOoRFtWFY+/TRlS502Yi8sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247188; c=relaxed/simple;
	bh=gTf12NUuaLXPF0Xj6+C6ypfix0LEN8qjI/0cMZEECOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcApMDSPFPRyOkia4CCBXerm8FqTGpCaMhyhocD1DCGLpD0/HOebSjRhwMzbeHOBxE2e3hkYkleZotPgowPXeTie369l+rMp9LrMrCgvJ1s3jmt4sNfsIuf2C0Cp9USh7sevYxvz0JAYZoumtwYwZJRfUHLhQH7pWItEvhjIY5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHD8B31t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHD8B31t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D6F1F00A3A;
	Thu, 20 Aug 2026 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247186;
	bh=NyvBVYZcQP1gA/iphyOON55FZmWozlno52eDc2C64ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHD8B31tuiRmhhPxBkSR6xaSBN5eea19EQOre9R9HjiYqgeZs5nVsB/UBkOd/2uRl
	 j+s4hC+9S2Ymb7t7udeYbKkz0gUMVVP79G3oAIY4RsLPgimVwJ05v9I93mqZI9GNEl
	 U4S+DFAlDovSw4vcpJK+U+M5owtVJ6WWQhlATMFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/220] ring-buffer: Initialise reader page order in rb_allocate_cpu_buffer()
Date: Thu, 20 Aug 2026 16:56:08 +0200
Message-ID: <20260820145228.824412034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

[ Upstream commit 6d014e44b68ddd43f71288d2a4dbb1a259869149 ]

In rb_allocate_cpu_buffer(), bpage->order was omitted, leaving it as 0.
This is an issue for a ring-buffer with subbufs bigger than PAGE_SIZE if
when freed: free_buffer_page() relies on this value. Align the value
with the actual allocation size (buffer::subbuf_order).

Cc: stable@vger.kernel.org
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Link: https://patch.msgid.link/20260806211306.3704194-4-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2220,6 +2220,7 @@ rb_allocate_cpu_buffer(struct trace_buff
 			    GFP_KERNEL, cpu_to_node(cpu));
 	if (!bpage)
 		return NULL;
+	bpage->order = cpu_buffer->buffer->subbuf_order;
 
 	rb_check_bpage(cpu_buffer, bpage);
 


