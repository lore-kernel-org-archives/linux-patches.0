Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207648;
	b=qfLfBl9nbu6atIn03J3dnmmX1SMk/ZOin4TUM4bZ30ia90o9hLvbayj3isrG3jdJUsGl
	 wtUgQSwar8uI1nXJvvR8v2PF8X040GDbhRagxWnGwoz3gVxO/k+AnnFg2JNnsUBg47TuC
	 2OhOemLAm39IfWWzo7PT2oNh0miyt0/wC75rptbFFiyO/XxgwUMzGUXsI16Kczr6wGObM
	 M4u/kN5UOKgpC0ZIT+hOwK9fk+YOdN7fFK67Hq3XeiySY573EBSKgUYOvvdBuWwIwkvs2
	 3Zl6OIVfhbw3N/fLYeZJpP60PTwr6ChqP9NTLXPHLlicYr7F4hEvhxqoCi3RExzPZYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5+BgWPRmqd1sRFZezGfvOpaBOKus2+EdAuVG36goVAs=;
	b=VDWlPow0V8MGroM70nlPmuhg0/LGHJZl8PZeukVi3MmoS6nLbGYc5aQJpjwDS+OcsoDt
	 4Hiqr/46srjTvKslOLlR0CxlJeJ7eBHNLojgLoGvWCDezOcOZKu32WoAz6k0BRQd/tgVr
	 5pgwgvobhQZiZlr032Wlbc3PujBzuKN1cFIbUvPaARUDiNRtUZIikbFmsJrcoMLSSaABp
	 m3FVbuydeeTTpL87tI3VgA5TBQviX0KjeDsAvFIIzxf+7W5Re4WCDet8RCYEjm4yvSmSt
	 jq0zgMNAy648oDO+c+2PfYs/Ngd8Em4T/VLE4Yog5EvFMcaH7/KS0lV//GmMoMDqRGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XndIutdj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84B606A31A;
	Wed, 28 Oct 2026 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XndIutdj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281851F01828;
	Wed, 28 Oct 2026 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207647;
	bh=5+BgWPRmqd1sRFZezGfvOpaBOKus2+EdAuVG36goVAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XndIutdj7tUcXRWuXb6NYAD3dkskkKQoBb0GdO8IbAfM9rxpNU/qMs0rIN1SXUsQe
	 mePz935Ccorzqo4EphJRfmgi2kOeU60rCsKd4nC8e1S3NT1WIVCXVutDsJdrwBIkPe
	 wbvu8pCEvnWXFFgu14GqveuvGhKHA4lZJkmoxqQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 091/247] tracing: Take trace_types_lock when dropping the buffer_meta reference
Date: Wed, 28 Oct 2026 17:58:14 +0100
Message-ID: <20261028165949.548818887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6839,7 +6839,7 @@ static int tracing_buffer_meta_open(stru
 
 	ret = ring_buffer_meta_seq_init(filp, tr->array_buffer.buffer, cpu);
 	if (ret < 0)
-		__trace_array_put(tr);
+		trace_array_put(tr);
 	return ret;
 }
 


