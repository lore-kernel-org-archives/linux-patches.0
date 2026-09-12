Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A6357D18;
	Sat, 12 Sep 2026 19:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240232; cv=none; b=YqN1x0Y8bVHpTjbB1yMQFUBABNTjKuYWBJDNLYEE9hIsMLdzFsoqdycehVhSxGEpc7k6F9vTJ9QvPiBPtiEq7VtMnr54u+oCAZXiXXzUP9r5rHUuGrEZeYRK8KIOY6mwmGcrm7xtiM0C7mG1nEOX9F0QRgtb+DlnOjYck9DuiaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240232; c=relaxed/simple;
	bh=kwUFhJ2Qcsk5iNg0luPH49pN4rDSQqP7vVPt6560VFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1g+kpdOik53waTb6I4ROeGgPTJld42ZKEjzIXg3RosK3TZD5gW1DGA/l9xhB1b2feaMKapzmQT+qhosrqojkfT41t3GpMTxaO3XY9P9jfUSt5+POPgz1ocbbg2v11X714lgzSYgcvNONx3B3lFPdJGhyLjCzp3Gr5iR1JFju/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcoiWtNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcoiWtNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0B61F000FF;
	Sat, 12 Sep 2026 19:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240229;
	bh=o7Hry4UZmxxqP3dR52G9dVdY7Xz9dCjnO0Vz/w8KRtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcoiWtNi1aScCI0UgvbNAiCkH1Bmr7n3HQkEcb5b0rT4OolkBEIE3RY5M95e/y2R1
	 z5BPp10gn6mC1RR7Y/YM1f9DAcEqcQInjpBrLdBZbxeAsz3K3Rm6AzljmP09LGnM6b
	 lB4wgKZ92oE+/xZuF8QgY6qXaflH+Bx0Wim664Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 827/935] bpf: Fix pending_pos walk on 32-bit ring position wrap
Date: Sat, 12 Sep 2026 09:04:17 +0200
Message-ID: <20260912065545.793609119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a8b8f023ff795..fddf10eb14045 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -334,7 +334,7 @@ static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
 	prod_pos = rb->producer_pos;
 	new_prod_pos = prod_pos + len;
 
-	while (pend_pos < prod_pos) {
+	while (prod_pos - pend_pos > 0) {
 		hdr = (void *)rb->data + (pend_pos & rb->mask);
 		hdr_len = READ_ONCE(hdr->len);
 		if (hdr_len & BPF_RINGBUF_BUSY_BIT)
-- 
2.53.0



