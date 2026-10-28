Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207499;
	b=bVcsNqR+5R2GogdOJ0N4kaSlIaSM3PSVn4HF6ZHuv62RFo+fs1//YQiukDLoLzuMcCcw
	 XPOVRcRvnsvD13udxKoXfJUgaue/uD1M/BV7wWlmOXxvUYdsKfUTkScXon04nZTOYTcMH
	 npe3D2JFoYMzbvTizLMCh3+Gn6kSgBWYe8ldHE9BB7jOR6EEJ9OkY56xF7e+DzA56bIh5
	 aBxrJ1AdaozGZhU1I6HoiH3xAoTOfrc1U0I7K9GR5/zLb4Zyhj12MKPqEjCOSkcT8BNyf
	 OVcOp9/dsDuTMyvurPPP+y1xAlaPHCTthyscjobBFlgBXPlWlF1DaOVWw8tk24xETgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6N9a4ZA9CevQMFJ1lq++WGlYiQPZl/W+Gm3sss6iyYQ=;
	b=44MzDAgUEaieVGfvdz1wBdh2colariwEGba0QUXpKg17a/adyGIqzMOctFdhCTJVcOUk
	 +08abSBtmYJo7Z0fswYdrtDaikrW2zKTMlBD8rkaHJbcz3z0mUkEPjE5Mhx7BQU3Y+AIL
	 cR/mUbh+ECoGJDuQPRjkE0i8KPGrIYTuBwZVNLZtC/gUeGOyng0Mahg4sphVcKqyYKpSz
	 NdYI6boLl/QB3xGu4a6a3tobbSeCLdycDRNoWkYTeam/MTTdXjmIQdauw4t2CD771cu9s
	 hGwogENI1wsLKAoLvAKUhcfHbYKelEaDwPTYHXFMebIxqyo6bBvi8FWJMM7f/fEqf8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yov3yb6J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DCD606A31D;
	Wed, 28 Oct 2026 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yov3yb6J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3561F031E7;
	Wed, 28 Oct 2026 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207499;
	bh=6N9a4ZA9CevQMFJ1lq++WGlYiQPZl/W+Gm3sss6iyYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yov3yb6JGLnZMY8FVZrlzCQ8wPsWROmmLsu02rrfAN5gkMbeR+t/9QiDTe0G2CzNM
	 52oTV6d5jVVRnxFrjUiG6MiXw7VBk8PnlbTkatfIpEm7EaJ1H3M+SdWDJSn+IEFKu5
	 MI9GeQ51k1sS3RelRd64T3MTyQ2IAsFgoI8WUTlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/247] rose: guard rose_transmit_link() against a NULL neighbour
Date: Wed, 28 Oct 2026 17:56:50 +0100
Message-ID: <20261028165947.532018295@linuxfoundation.org>
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
(cherry picked from commit 2aa2cf6eb000bd324c8296a877680186b5df5fe9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_link.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 0f77ae8ef944a..cbfb11fc3ac52 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -263,6 +263,11 @@ void rose_transmit_link(struct sk_buff *skb, struct rose_neigh *neigh)
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
-- 
2.53.0



