Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBBB513549;
	Wed, 30 Sep 2026 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793831; cv=none; b=SbVysXv17WQaRZuWOeiILg2xoJ3ki+sR6TRaPmTV+rNej8kwOS+Xv+Sm5FKdtZrWFoSe4ORj62NGkETI/nRLxz+dpCz+FxJEd13glE3AeoZt6in5+OM1pwgxFMFkxwgplzeUY2bu/U2fOK/TsPt40PcqoYjboOpTXAip0uno0ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793831; c=relaxed/simple;
	bh=fRYDROYAmMZawxqU2KNpUN9tIVnUxQYyz1EoZ0qJWQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrHvBbxJ02GbaPYDxH3haBruUKXh1vSBdJP3pT5+sKkWBkjQdLeRZH0lelmHXjRvO5DV6WxTUcYkN6PNm9hqDpoiRzaYn4jBboQs2x/QrnPp9o/+uWJnBeertJnOWCDIz9Y7aaRpXBFYyq08RMzyJ6A6XT5UiqtMb5mh9rp+JQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSFfWGZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSFfWGZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587791F000FF;
	Wed, 30 Sep 2026 18:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793829;
	bh=PvVXsRJcDZghc3HnepxrQTBZWcUOoRiTofRV4yMhcRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSFfWGZv3NkBK9v+p88GOiVPyWvvHzt3Q6CNgx7DI5HuixpS3Px/hVsAyI7zbh9F/
	 JuSJwUWsxxyFKHYW9528uq4+nONvmadW6vleRvc68eE5PaNgAiYliaEdxTEtCb7QO8
	 KOy6LcpS8vcjadPbaUDCj37BHYSDdgikifvskvHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 392/395] rose: guard rose_transmit_link() against a NULL neighbour
Date: Wed, 30 Sep 2026 17:30:54 +0200
Message-ID: <20260930152349.207011425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_kick() and rose_write_internal() call rose_transmit_link(skb,
rose->neighbour) without checking that rose->neighbour is still set.
Since commit e8eb0c6faa88 ("rose: clear neighbour pointer after
rose_neigh_put() in state machines"), the state machines routinely set
rose->neighbour to NULL once the underlying AX.25 link is gone, while
leaving the socket in ROSE_STATE_3. rose_kick() only checks the
state, not the neighbour, so a write() on such a socket reaches
rose_transmit_link() with neigh == NULL, which immediately
dereferences neigh->loopback and crashes:

  Unable to handle kernel NULL pointer dereference at
  virtual address 0000000000000036
  ...
  pc : rose_transmit_link+0x14/0x1c8 [rose]
  lr : rose_kick+0xec/0x198 [rose]
  Call trace:
   rose_transmit_link+0x14/0x1c8 [rose] (P)
   rose_kick+0xec/0x198 [rose]
   rose_sendmsg+0x260/0x3c8 [rose]

Reproduced on f6bvp-8 (a real ROSE/FPAC node) when the BBS daemon
wrote to a socket whose neighbour had just been cleared. Confirmed
by recompiling rose_link.o with a static_assert on
offsetof(struct rose_neigh, loopback), which matches the faulting
address (0x36) exactly.

Drop the skb and return early when neigh is NULL, matching what
rose_transmit_link() already does for other frames it cannot send.

Fixes: e8eb0c6faa88 ("rose: clear neighbour pointer after rose_neigh_put() in state machines")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_link.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -263,6 +263,11 @@ void rose_transmit_link(struct sk_buff *
 {
 	unsigned char *dptr;
 
+	if (!neigh) {
+		kfree_skb(skb);
+		return;
+	}
+
 	if (neigh->loopback) {
 		rose_loopback_queue(skb, neigh);
 		return;


