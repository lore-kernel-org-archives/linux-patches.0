Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE563081C4;
	Mon, 13 Oct 2025 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370159; cv=none; b=HnIUezQGuzWvtymUkezaXFOWkgyJd4cSbuhr0DYSTwcjOYiS6WO0IXiXzMAG7EYtw3miggtRLvkYC3adMfcztGw5DHcGuHGoB7LXY4+3SxBhrNvKQX3T3XsAEYyjlKABED6ggXja823X6MAugQ7Xlyxa45Vumwh6kzYCBNR8B+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370159; c=relaxed/simple;
	bh=RzL6346LaAapUfL406GV9MP6LqLgC0Fvc4zqW6p7/dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHHQhJqP9E8QRDi2Yb/er/dP3dyrgtrIjQ5NRE+Dq1s8/01q7bq9exUaQjcgKyHUWfkQcMWhgpaB8O4KM99maoIzm3f9verB71Ifr2fhJ0nhjQkMNdElhMIphbQgc2HTQf4NKzgthGue04EyGk7wjI8hL/oaTAZ0dARGMs5LVv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp1jbopw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp1jbopw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E49C4CEE7;
	Mon, 13 Oct 2025 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370159;
	bh=RzL6346LaAapUfL406GV9MP6LqLgC0Fvc4zqW6p7/dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xp1jbopwm0G/wo1V9lhwoNTptS4j+w8Iqw03BVOBk3K9xu/TQ6HuZTG8Oyn3ixP/y
	 R86P/0LGWsFBMLjvfgcrEZ/4FjGXuUNM1U+KFqAv0VanwnfFs4miU+LoU8cu8LY4vP
	 8oQC5nqBN9qi4EFHIMuQxDTNLiJdxNncVb4kFm9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Matthias Jasny <matthiasjasny@gmail.com>
Subject: [PATCH 6.17 500/563] io_uring/zcrx: fix overshooting recv limit
Date: Mon, 13 Oct 2025 16:46:01 +0200
Message-ID: <20251013144429.421890390@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 09cfd3c52ea76f43b3cb15e570aeddf633d65e80 upstream.

It's reported that sometimes a zcrx request can receive more than was
requested. It's caused by io_zcrx_recv_skb() adjusting desc->count for
all received buffers including frag lists, but then doing recursive
calls to process frag list skbs, which leads to desc->count double
accounting and underflow.

Reported-and-tested-by: Matthias Jasny <matthiasjasny@gmail.com>
Fixes: 6699ec9a23f85 ("io_uring/zcrx: add a read limit to recvzc requests")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1154,12 +1154,16 @@ io_zcrx_recv_skb(read_descriptor_t *desc
 
 		end = start + frag_iter->len;
 		if (offset < end) {
+			size_t count;
+
 			copy = end - offset;
 			if (copy > len)
 				copy = len;
 
 			off = offset - start;
+			count = desc->count;
 			ret = io_zcrx_recv_skb(desc, frag_iter, off, copy);
+			desc->count = count;
 			if (ret < 0)
 				goto out;
 


