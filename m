Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208009;
	b=IqTuVvSmys1JbGIGH8xLxNFuV4T0ZBUWSv3FIqFrqJhkQwB8Gh0P8JcEeZmMorbLZCsZ
	 Aj8XXHzz3SYDx9rS+rWetM7JRYMihIIWhlUQUIoy5TSQJCJ83NqkaOx1GAB1El2qh0a7c
	 zwJmKBd2nse5pxzRZDA39TWB5gP27JfI2h3NFYGiiDj2DGMOqUYg6y2vhLsC/3QkKHeXH
	 q+Zs0aiEL8AsqZ4hEBN/iLxaSBvDgKmi2VLJqxSC4AH/X+iLkbQkpML1lriVpE8nI8FmI
	 2hIZNB1g52nT4yvaVM7E5ZuVQEFkLrnFbIpLqWf/CsxxPjkoKDlQVJdZA1zxAv5Moxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u3izAz4n1njVTowG8BIbyqw7Gdab9n1qQ32AaM4/cfY=;
	b=zb1oaRDIRam1LpaK5krFxFkb9XhuRYGuXXfoqhWfaAEfqGxFRHcVB08q1o6Tt8aQYqG7
	 pgrenX3n0W2i/8fVrkE5uYB8BJM0WVihHAOa9CHV3VU4+xW7E4H8mNUuTmzcjfa5Qdxsc
	 c+I2xhTIHG9OteuzEQaNzt5rkms/rB/SLjlNxmSuhkpYDP9GkMcw72L+OmYfum1belFZv
	 eSKB6euckfyuwWOsy54p1Q7QP1Z36Yy4/IAx9rwEXcOnmvPh0LaO50zhqBQwZPq3Ja1R4
	 7dtSecb++8RVz83afkysCjLmXGw713Is9DTJ5MNF7y61lqPxrxS7ragKBt43ZFJI9xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQAMHWJX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D83A606A31A;
	Wed, 28 Oct 2026 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQAMHWJX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEDB1F01828;
	Wed, 28 Oct 2026 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208009;
	bh=u3izAz4n1njVTowG8BIbyqw7Gdab9n1qQ32AaM4/cfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQAMHWJXXdVoYzhtn4NULOdDcIxB65jhTFLQ7diA1lFc/dZElr1Ujhp7zAeD/BvNR
	 EmjRxLoVmdAgfHuhGtCe/Ebr7KN77f4BiPIOKeUd30ZqdJRvyMQOTsidjfWMIwqkSR
	 P+H0EwAtuL0E4ib7QPg2hgmIBuNc/EQ556jgSeSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 215/247] io_uring/kbuf: handle index wrap in last buffer check
Date: Wed, 28 Oct 2026 18:00:18 +0100
Message-ID: <20261028165952.513230922@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit 6e773b5161506a4d0e739eb3aa4667d28f20219c upstream.

io_ring_buffer_select() flags the request with REQ_F_BL_EMPTY if it takes
the last buffer of the ring. Head and tail are 16-bit counters, but
"head + 1" is computed as an int. If head is 65535 and tail has wrapped
to 0, that compares 65536 to 0 and the flag isn't set.

A bundle receive relies on the flag to tell that there is no point in
trying to get more data. Without it, it goes for another round, finds no
buffer, and the request, which has received data, is marked as failed on
account of the -ENOBUFS. That severs a link, and ends a multishot.

Fixes: c3f9109dbc9e ("io_uring/kbuf: flag request if buffer pool is empty after buffer pick")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-36-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -181,7 +181,7 @@ static struct io_br_sel io_ring_buffer_s
 	if (unlikely(tail == head))
 		return sel;
 
-	if (head + 1 == tail)
+	if ((__u16)(head + 1) == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);


