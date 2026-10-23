Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774736;
	b=4yCwkXIO2EieUNlXU7qd7WJobve27AubMXnD194iPNo+G7lniytCX7+ty9iYeLdrxGnh
	 YZ0s17f6sSN1bNCMzKXtQ1uiFBFc2RKfWIjX2vwqhwahv8kn9DXm3nGMF/rkWfHsantAK
	 PmgVzg47iCpMvJK6ov9UH5ifgc8bhSiDwJGjMfmRTMcIcbywSjoL8LlWEJPuD8C1u4fuM
	 kVJOoWFzNz6vC1Qkd4XR/uiyoQRfq2MuBju8vdNTlNsQgRcJBjR5X7u8KbYtzdrMtYDrw
	 DPAvBzztOqjhmmMsDR++9ncri7AyhEIj5IFHetUHmFaW3ImncxjqTDw/K71tQHzYJTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FouEzS6SAWEgprPKgjrvb96ovcxDEbrWVAyjxpoOVdI=;
	b=cpAfHzz21lE+t+8XEi0ad2/If/FN/yp5QghRr6ho9kCW+BS4lDqyq3hg2Lm4Sx6Yxt8H
	 szBuOH2cc4G1Y1jcmdRqTG7iwY+lhw2xFzhpHoXCfqHIpQoNIkXlRhz4b7/ivuzqmzkJv
	 LRnsptNNVG2pDi+vpvMJkUGA4CuIFIkXkKE2BZlMNFogIo4EU8sOflmSXSxQ/nTugYjJG
	 yf6mKwksncWx1z7dasbnCZljUgYiyBjvjjUnzJSDU3QiAc/cptEMV5aDDfGdYHfixIOpi
	 BKKLqg+L5SWqhPvQIPSguub9JEvrYVrbZuZx2uociuBVcqWDK/ntety5zypVRSJBmwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysI3KjGI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4B6606A31A;
	Fri, 23 Oct 2026 16:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysI3KjGI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8BF1F01828;
	Fri, 23 Oct 2026 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774736;
	bh=FouEzS6SAWEgprPKgjrvb96ovcxDEbrWVAyjxpoOVdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysI3KjGITmJPakBJUxg6+5LH1EdDWmq9RfwllEYzBN5n8d3AIAZnhQI+zYJuRcUU4
	 AzkGb0b9b7GyYEz9QXVubUbgVf4JpAWwb8s27Tx6thT9S1TThKF6YltldeWN28Y7Sz
	 JU9ogYKcKkHP11OrJADxxyTxEJlNWrmBqdH/l0+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 142/242] ring-buffer: Fix the sub-buffer array base in rb_meta_subbuf_idx()
Date: Fri, 23 Oct 2026 18:39:44 +0200
Message-ID: <20261023163717.138208747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 25132363c723afc39aace8b098f547ab4a0ea759 upstream.

On a persistent ring buffer, rb_meta_subbuf_idx() can return an index one
sub-buffer too high.  rb_setup_ids_meta_page() then fills subbuf_ids[]
shifted by one and leaves subbuf_ids[0] NULL, which __rb_map_vma()
dereferences when userspace maps trace_pipe_raw.  rb_update_meta_reader()
writes two such indices into meta->buffers[], which rb_cpu_meta_valid()
would reject on the next boot, discarding the previous boot's trace.

A CPU's sub-buffer array starts after its meta header and the nr_subbufs
integers that follow, aligned up to a sub-buffer.  rb_meta_subbuf_idx()
inverts that calculation but skips only the integers, not the header, so
its base is one sub-buffer low whenever the omitted header size crosses
the alignment boundary.

Invert the calculation with rb_subbufs_from_meta() rather than repeating
it.  rb_range_buffer() maps an index back to an address through the same
helper, so the two directions can no longer disagree.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260918071507.1019251-1-donggeunyoo.kernel@gmail.com
Fixes: b14d032973d4 ("ring-buffer: Add ring_buffer_meta data")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3616,10 +3616,8 @@ static void rb_inc_iter(struct ring_buff
 /* Return the index into the sub-buffers for a given sub-buffer */
 static int rb_meta_subbuf_idx(struct ring_buffer_cpu_meta *meta, void *subbuf)
 {
-	void *subbuf_array;
+	void *subbuf_array = rb_subbufs_from_meta(meta);
 
-	subbuf_array = (void *)meta + sizeof(int) * meta->nr_subbufs;
-	subbuf_array = (void *)ALIGN((unsigned long)subbuf_array, meta->subbuf_size);
 	return (subbuf - subbuf_array) / meta->subbuf_size;
 }
 


