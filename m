Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4584F3EAF;
	Tue, 13 Oct 2026 12:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892881; cv=none; b=nUgUTZTKWwiqMZjyWq6wnTaD7OqW3JDBb6tMbGH4hOQfmvjQTaWDOrQ/nEr6nwTjTiCDVSilCQXtSdu/3VqbJaFHmC0PWJtqRFMWpjlG1HcVceByBVUrP0u7za2ooGfhL7W4l66geSbO7WQCLa2yCEmJ2GLDxSIOHD6F1YiYFwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892881; c=relaxed/simple;
	bh=Dm8cwXkhpxqIJjT4BmXWYj8ajf5rh1PpbJxVObh9W8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KUGB3Dsz8SC1NL8C7Km/cRLk4d2Bjdh1vOpZYdQQZtcIKKs9G+Q30wLlVhDJfDkTJaqpMYNDkx4Oxw3AGck/+8L3jr5JJBLURa5IZoa+xvwzY3PVHMmm0ttZ9u9/sEYOjRAH8zi2Ii9LmTmekRZOGLfv0Lg6zG3JfYyRfgyxqZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7JLQgwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7JLQgwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8B31F000FF;
	Tue, 13 Oct 2026 12:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892880;
	bh=BGuV4pGM8LDTFRvUSY5flF1y4NWLDuUt7ZqOFzBv4SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7JLQgwkUNyebJrYi3dumPhb46n6MovctuMH0jij+O0MY4WY/ujp+83x/3ChbcxWV
	 XUQ/yJsC1Loj+BpIQbgxq2TZqb3eBy181G35v/KWiAax1YmU/yobNc8zfCjyItHgtO
	 aA5hQ71r1qFYG1GkPrTbB2o2epIE8t8mLRyVh01M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramses de Norre <ramses@well-founded.dev>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 039/621] wireguard: queueing: preserve tstamp_type when encapsulating packet
Date: Tue, 13 Oct 2026 13:30:34 +0200
Message-ID: <20261013112921.791766225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramses de Norre <ramses@well-founded.dev>

commit 65ab9de4bdd4c05d8277cfc20ae0b9f5aff60897 upstream.

Sending traffic through a wireguard tunnel on a host using the fq
qdisc fills the log with:

  fq: likely mono tstamp with tstamp_type 0

An skb carries a timestamp in skb->tstamp and, separately, a
skb->tstamp_type field recording which clock that timestamp came from.
The two have to agree.

When wireguard encapsulates a packet it calls wg_reset_packet(), which
clears the fields that must not leak from the inner packet into the
tunnel packet. It does so in two steps:

  skb_scrub_packet(skb, true);
  memset(&skb->headers, 0, sizeof(skb->headers));

skb_scrub_packet() deliberately keeps skb->tstamp when it holds a
monotonic timestamp: that value is the time the packet is scheduled to
be sent, and the qdisc still needs it. The memset then zeroes
skb->tstamp_type, because that field sits inside the headers group
while skb->tstamp does not. The packet therefore leaves wireguard
carrying a monotonic timestamp labelled as a realtime one.

Nothing noticed until commit c4f796c4f16b ("net_sched: sch_fq: convert
skb->tstamp if not monotonic"): fq used to assume every timestamp was
monotonic. It now consults tstamp_type, spots the mismatch, warns, and
falls back to treating the value as monotonic. Pacing still ends up
correct, so the log spam is the actual problem.

Save tstamp_type before the memset and restore it when encapsulating,
next to the hash fields that are already carried over this way. When
decapsulating it stays zeroed, which is right: an incoming packet's
timestamp is a realtime receive timestamp.

Fixes: d98d58a00261 ("net: Set skb->mono_delivery_time and clear it after sch_handle_ingress()")
Signed-off-by: Ramses de Norre <ramses@well-founded.dev>
Reviewed-by: Toke Høiland-Jørgensen <toke@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20261008130124.724119-3-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/queueing.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -78,12 +78,14 @@ static inline void wg_reset_packet(struc
 	u8 l4_hash = skb->l4_hash;
 	u8 sw_hash = skb->sw_hash;
 	u32 hash = skb->hash;
+	u8 tstamp_type = skb->tstamp_type;
 	skb_scrub_packet(skb, true);
 	memset(&skb->headers, 0, sizeof(skb->headers));
 	if (encapsulating) {
 		skb->l4_hash = l4_hash;
 		skb->sw_hash = sw_hash;
 		skb->hash = hash;
+		skb->tstamp_type = tstamp_type;
 	}
 	skb->queue_mapping = 0;
 	skb->nohdr = 0;


