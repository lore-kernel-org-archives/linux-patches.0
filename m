Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774874;
	b=TrNDvh3hovWu2lmJwqEtmUavWzEqJs1ma6qSpreHlv9h02QuB3XRFu9Z02stSqmQz7bJ
	 8p76pW+LEyupsA5OWgA72DkDY2QyS8kEARQBAHKliYFeFOMN8Q5Out7pprI/YDswEiiKP
	 xDBS6ttBko1ZGC5Tem+z+vEreiOq04dqplPqXEBijvJzt++FOTbyF4l8AN3Na3FAz/NK2
	 uODEWjTsMy6WZ13wU4DayLo29cAzKaJFxRiV3BbovPeNaczVlo1+n7aT0zjoB+ZEwvZFQ
	 1pbMLxqs7NBMtCWHHB88cZTIdu0zC2cOIh2t1Q+T0yE7ZWwW6zHuAasVhrz9/e4pzbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n2XciUPIR6RUed+XaZ7rV/cRfYMv1+RcknlvdzS2O7E=;
	b=vjO6pf+1mSbgw8irh61yB8Tbkjm1OpSsOz9f1ovZ8CG8b5MEI8tu5WBK4b2Nal1TovYl
	 nMdhzE6QWCKL3gDRY+rLKcLHvCKVpOPbvuKosrYe72nIUrznlnVxR17oKOB8OJkpsPg4f
	 6eetrdDBJaBmSZbdqjOO5gcZXshOqI3MAZW+86j6OhXSzzXeumnEqyINrS8XSnsUXpQYt
	 PRFAagpYjJiuoPUiEn3kIvHXfwHLhjWA2oi00UEuraqAxfEg1/NL+7QZQ6EP0krqVqdqc
	 CcdKW3TpRc2NR9zBVOk3OdsX+5UbpQpkcCSGe0kHBr15q9tviYy2ikGXgE/uIPA8KuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BYHrWewv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E24C606A31E;
	Fri, 23 Oct 2026 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BYHrWewv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E04E1F01825;
	Fri, 23 Oct 2026 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774874;
	bh=n2XciUPIR6RUed+XaZ7rV/cRfYMv1+RcknlvdzS2O7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYHrWewv8ClmKkJGUovs61DkPcSwpkg+RCKP5S8FY6OcES3HF3MaINZnITD+Pvrb6
	 gtVTnid4gRipMOC4yjq5SuYrmpO1gb/eEgF1WJL8C7vn06HBTuju8C0NZvj/Dl7iHY
	 q/ZfWo2Ly8NwmGcZGAvwhVGIJCItMOvG/8OoPAvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 170/242] tracing: Take trace_types_lock when dropping the buffer_meta reference
Date: Fri, 23 Oct 2026 18:40:12 +0200
Message-ID: <20261023163717.805847297@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit 2afe7575fb24b9d0476ae4a3a9862f7997216aa4 upstream.

tracing_buffer_meta_open() drops the trace_array reference with
__trace_array_put() when ring_buffer_meta_seq_init() fails, without
holding trace_types_lock. Use trace_array_put() like every other open
error path.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914133506.4865-2-devnexen@gmail.com
Fixes: 950032ffcee7 ("ring-buffer: Add output of ring buffer meta page")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5879,7 +5879,7 @@ static int tracing_buffer_meta_open(stru
 
 	ret = ring_buffer_meta_seq_init(filp, tr->array_buffer.buffer, cpu);
 	if (ret < 0)
-		__trace_array_put(tr);
+		trace_array_put(tr);
 	return ret;
 }
 


