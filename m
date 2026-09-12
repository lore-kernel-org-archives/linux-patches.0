Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28383537FF;
	Sat, 12 Sep 2026 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231591; cv=none; b=S6+uz6sJumI4+0D5dUyL1nuMCBiewYW1ovrWLBUA5Y+k+hFJ4Y37VCpss1mEeabP58kQ7o5/AIor7xrYLgR0uocNxiJ5A1tkPQrHceLk0QIh3ISZlRZvPRKhJuMmi90i2IQ4Qw42QtUnpz6+maaBQMzQm+mQX6oadhPVg11Wb+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231591; c=relaxed/simple;
	bh=JSmBEYiq03xK89Bl9aF2WbL/oWU6X40hmIjh9Di74LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fq6mxIkJUINhwqSBWjXgKpvUDevxfJW+Rb2pSsynnCqgJ/knvK7d81nE37X3sMUUJKIXnK6tuXrg4pIdb3gErg1iMA9lrnAeS1HKVir44/iphXrN1cGeDHBaXucI/mirnvlBIfZqfNwgPsyKUiPICA4xzAHIkEgY0BrBK1zkbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQLoKizn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQLoKizn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D681F000FF;
	Sat, 12 Sep 2026 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231590;
	bh=C7hpJeLiB3Z8YdhqAXdzH6TKtQwEFLcX1OWVFwluCTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQLoKiznDWSOSi0VjN6fqaFp6o9vnvQOfF8Ps/0Mpb+TqjijewZrVKFwX5a1Ad2n6
	 LSQw245pyAnLXnNR7EIuMArPhOzXwce17SozGBTTvXzSwhEXuJG+tCoqQWKaYsLr2l
	 YGGK8vqvJxRk9OITILHB2XdCqL0nYAyHkYf3XoX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1013/1191] bpf: Fix pending_pos walk on 32-bit ring position wrap
Date: Sat, 12 Sep 2026 09:02:21 +0200
Message-ID: <20260912065610.945848596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Israel Téllez García <i.tellez@btesa.com>

[ Upstream commit 6ff5b56a50c5351aeeb180e34327736576c038fa ]

The reservation path caches the position of the oldest not-yet-committed
record in rb->pending_pos and advances it past already committed records
on every reservation:

	while (pend_pos < prod_pos) {

consumer_pos, producer_pos and pending_pos are unsigned long, i.e.
32-bit on 32-bit architectures, and Documentation/bpf/ringbuf.rst states
that these counters may wrap around there. Every other comparison in the
file is written as a difference, so modular arithmetic keeps them
correct across the wrap. This one is an ordering comparison, and it is
not wrap-safe.

Once producer_pos wraps past 2^32, prod_pos is small while pend_pos
still holds its pre-wrap value, so the loop condition is false and
pending_pos is never advanced again. Reservations keep succeeding for a
while, because bpf_ringbuf_has_space() uses differences, but
new_prod_pos - pend_pos grows as the producer advances, and once it
exceeds rb->mask every subsequent __bpf_ringbuf_reserve() call fails:
the kernel believes a pending record spans the whole buffer. The ring
never recovers, bpf_ringbuf_output() drops every event from then on, and
nothing is logged.

Observed on four armv7 devices (i.MX7 Dual, 6.6.52) running a
tracepoint-based collector with a 512 KiB ring and 160-byte records.
Every one of them stopped delivering after exactly 26846821 records and
4295491360 bytes had passed through the ring, at event rates between 441
and 862 records/s, that is after 8 h to 17 h of uptime: the trigger is
the byte count, not time or load. That figure is 2^32 plus 524064 bytes,
and the excess is one ring's worth of grace period, as expected while
new_prod_pos - pend_pos is still below rb->mask. The last reservation
that fits is the largest record boundary X with X + 160 <= 524287, and
since 2^32 mod 160 = 96 the boundaries after the wrap sit at
X = 64 (mod 160), giving X = 524064. Userspace kept consuming normally
until the producer stopped, then read zero records for good. With this
patch applied, one of the four devices took 10 GiB through the same ring
with no stall, while the three unpatched ones kept wedging at the same
byte count.

64-bit hosts are unaffected in practice: their counters would need
16 EiB to wrap.

Compare the two positions as a difference instead. pending_pos never
runs ahead of producer_pos, so the unsigned difference is the real
distance between them and stays correct across the wrap.

Fixes: cfa1a2329a69 ("bpf: Fix overrunning reservations in ringbuf")
Signed-off-by: Israel Téllez García <i.tellez@btesa.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260814124843.22041-2-i.tellez@btesa.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 1d49e77a6a01b..c5a8bb4a81b76 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -419,7 +419,7 @@ static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
 	prod_pos = rb->producer_pos;
 	new_prod_pos = prod_pos + len;
 
-	while (pend_pos < prod_pos) {
+	while (prod_pos - pend_pos > 0) {
 		hdr = (void *)rb->data + (pend_pos & rb->mask);
 		hdr_len = READ_ONCE(hdr->len);
 		if (hdr_len & BPF_RINGBUF_BUSY_BIT)
-- 
2.53.0



