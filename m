Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905912F28FC;
	Sat, 12 Sep 2026 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226416; cv=none; b=q2Fc0W4gCqu0ffKI890xf2dvpMlO8wJtMbFSC90B1X+XOb+jKrEApzMAFDMOSACoLQmVfEk6cnGz2buBDMKoW0w1SeWEQmk4huLuJNUt+d5ZyYFNybgH+BkqdOQ2z4RB3zwS55+ZlPDrFVDEpGqLp0Bh+Zoi62RiaFq/+Ki5RHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226416; c=relaxed/simple;
	bh=ka1ueleugfGps2antp4z80rBEZ1pK4Y6XvM+KhYkWyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLHbcnH5sisqYwfI/JXshI9XxLAqaofZYO2OZrNns0FPsjMqBkaXXzbZQFVhxxkDSHUTETu8cBuZD9SEvW3a0qT/dh5uuTyckWk/hREIft5FAfOH6mew0nXF0uF/FXvgQOq9Lpaio7SY5vuMWb3YSXjE6K+sM7W1heVwWB4zWDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBf0rJJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBf0rJJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C5C1F00893;
	Sat, 12 Sep 2026 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226415;
	bh=w+b0x0hFXKQC6usWz/nI/rmckGjYva73+84D3hjz2Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBf0rJJ5JAzFrJHAybhsqP1rd3Y6YtIQO0U5AjvSIylm8w0/DuesdVmskATTQE3g8
	 6vb175MLgAA6A4tzUoaQGehXfuQqP8/9CezEAeHilZ3TesPZEcuoE0J0NIQQ2QdGLT
	 m8AKG70wRtqGnrw2qtYEqWwlrGG9NrO9Bp1SzfJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1396/1424] tcp: fix corruption of urgent data on multi-segment retransmit
Date: Sat, 12 Sep 2026 09:03:48 +0200
Message-ID: <20260912065638.524997248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit ce2b807f42ed5e55567b8864ab72963f90779270 ]

On the normal xmit path, while in urgent mode we refuse to build a
multi-segment TSO packet, so every segment gets its own urg_ptr:

	/* tcp_write_xmit() */
	limit = mss_now;
	if (tso_segs > 1 && !tcp_urg_mode(tp))
		limit = tcp_mss_split_point(...);

The retransmit path has no such guard. __tcp_retransmit_skb() builds a
segs > 1 skb and hands it to the GSO layer, which only advances th->seq
per segment and copies urg_ptr verbatim:

	/* __tcp_retransmit_skb() */
	len = cur_mss * segs;		/* segs > 1, no urg_mode check */
	...
	/* tcp_gso_segment(): bumps seq only, urg_ptr is copied */

urg_ptr is an offset from the segment's own seq, so a copied value points
at a different place on each segment. The receiver rebuilds the absolute
urgent seq as seg.seq + urg_ptr, so it walks a moving urgent point instead
of the one OOB byte:

	seg1  seq 1     urg_ptr 5001 -> urgent @ 5001   (ok)
	seg2  seq 1001  urg_ptr 5001 -> urgent @ 6001   (wrong, +MSS)
	seg3  seq 2001  urg_ptr 5001 -> urgent @ 7001   (wrong, +2*MSS)

The real OOB byte is never pointed at, so the receiver stops splicing it
out and delivers it as normal in-band data, corrupting the stream.

Guard the retransmit length like the xmit path: keep segs = 1 while in
urgent mode.

Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260826141145.67823-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5abad93d3c743..93817ce0dca9f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3317,7 +3317,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		avail_wnd = cur_mss;
 	}
 
-	len = cur_mss * segs;
+	len = cur_mss * (tcp_urg_mode(tp) ? 1 : segs);
 	if (len > avail_wnd) {
 		len = rounddown(avail_wnd, cur_mss);
 		if (!len)
-- 
2.53.0



