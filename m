Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E884E3EE1;
	Wed, 30 Sep 2026 15:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782837; cv=none; b=Nrji3kcFt39HN+2Hm9saLrlp4jwiUZa9Uo0Xom6rwCuCEEBF0jjvdND4jdomuZLrdv1IYHHnFVgaOINDe0+86ZmKiSZ/wqE4NhuLIPGmRNe55beBj2Yjq769I15j/lLReJkKYXFd/PqPfHq1puzg4lA4iYaUF29882Wn2eFKmt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782837; c=relaxed/simple;
	bh=aTlRHkkvJt78pAqRuRdUcw/s1YzoHpVovQPyKvXAY+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LllvtJn7WFgTlQKM/IagQ/Xf52KYsY5N/n5ShgI6oRStmleNrS+VRXC9EyCC3UbAzpEbR/zSIUH83z24mIYVdcJQI9wj5dQfdLXC9OtmIsR+DHwUQ1TQagboJcpix5xAkW/d62yh5UAH3Ob+I8OmO0CQVKzwrTjekvUhnxcB2lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2B8Vvs7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2B8Vvs7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B961F000FF;
	Wed, 30 Sep 2026 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782831;
	bh=VKeZjjA63zryYGe8kppOZwoxXL3tveAil06nZPrZql8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2B8Vvs7Wisj/NSjhtKI3JSaBOLJMgdalnKvSZ7PmvaKVWbCuA6KEr+sdlVRtN43SJ
	 02IBk0I3QW94/dKBqE8flW5AFa/H6vct2uMmhzqAJqACj4byrDZIbsnTo8N/3vpNYf
	 CMaKkywISE7sV2bwnY1FAWvEtb8nzr1NXLViWEeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vlatko Kosturjak <kost@linux.hr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/595] ppp_async: drop the errored frame instead of resetting its headroom
Date: Wed, 30 Sep 2026 17:21:18 +0200
Message-ID: <20260930152351.720200669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlatko Kosturjak <kost@linux.hr>

[ Upstream commit 8dc5d98a16fa23c00999aecf10018c9f69fa5bf4 ]

ppp_receive_nonmp_frame() prepends a two-byte direction tag before running
the pass/active BPF filters:

	*(__be16 *)skb_push(skb, 2) = htons(PPP_FILTER_INBOUND_TAG);

Nothing on the receive path guarantees those two bytes of headroom. The
frame-error path in ppp_async's process_input_packet() resets a reused skb's
headroom to zero while claiming to restore it to a freshly allocated state -
but a fresh skb from dev_alloc_skb() carries NET_SKB_PAD:

	err:
		if (skb) {
			/* make skb appear as freshly allocated */
			skb_trim(skb, 0);
			skb_reserve(skb, - skb_headroom(skb));
		}

ap->rpkt still points at that skb, so the next frame is reassembled into it
with no headroom at all. A peer that sends a bad-FCS frame followed by one
beginning ff 03 then leaves a single byte of headroom by the time the filter
tag is pushed, which lands one byte below skb->head:

  skbuff: skb_under_panic: len:49 put:2 head:ffff888003c10000
          data:ffff888003c0ffff tail:0x30 end:0x640 dev:<NULL>
  kernel BUG at net/core/skbuff.c:214!
  RIP: 0010:skb_panic+0x13e/0x230
  Call Trace:
   skb_push+0xbd/0x100
   ppp_receive_nonmp_frame+0x48a/0x1d10
   ppp_input+0x4e9/0x2f80
   ppp_async_process+0x2a/0xe0
   tasklet_action_common+0x20f/0x8a0
   handle_softirqs+0x18e/0x590
  Kernel panic - not syncing: Fatal exception in interrupt

Zeroing the headroom violates the NET_SKB_PAD guarantee that dev_alloc_skb()
gives the rest of the receive path. Besides the filter panic above, when CCP
compression is enabled ppp_decompress_frame() hands skb->data - 2 to
->decompress()/->incomp(), which then reads out of bounds before skb->head
for the same reason.

Rather than restore the headroom, drop the errored frame - as ppp_synctty
already does on its error path - and clear ap->rpkt so the next frame is
reassembled into a fresh skb with proper headroom. This is simpler and fixes
both the filter under-panic and the CCP out-of-bounds read.

The original V1 of this patch made room in ppp_receive_nonmp_frame() with
skb_cow_head(); Eric pointed out that fixing the root cause in the transport
is the right approach.

Found by fuzzing the PPP receive path with a mutating peer on a pty; it is an
interesting (remote) DoS: root configures PPP, the peer supplies two crashing
frames. The reproducer (repro-ppp-skb.c, unchanged from v1) panics in about a
second, and returns cleanly with this applied.

Fixes: 6722e78c9005 ("[PPP]: handle misaligned accesses")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vlatko Kosturjak <kost@linux.hr>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/apkR6ZU+tqP2C3Fl@griffin.linux.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_async.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index 164c11df8192f..86bd14220aa0a 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -822,11 +822,8 @@ process_input_packet(struct asyncppp *ap)
  err:
 	/* frame had an error, remember that, reset SC_TOSS & SC_ESCAPE */
 	ap->state = SC_PREV_ERROR;
-	if (skb) {
-		/* make skb appear as freshly allocated */
-		skb_trim(skb, 0);
-		skb_reserve(skb, - skb_headroom(skb));
-	}
+	kfree_skb(skb);
+	ap->rpkt = NULL;
 }
 
 /* Called when the tty driver has data for us. Runs parallel with the
-- 
2.53.0



