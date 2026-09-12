Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AC13793CA;
	Sat, 12 Sep 2026 18:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237414; cv=none; b=R/z7qzqB/eUVP0+c5aIipZcP1x00EVBHGV0+sSvcXmxjtn78TFAPuwb854bJ8aXkThb+D8nITk/itnxnA5nmZf7DU1vlw9whdsUrDmN1WPXBmd0NYRzgfoe2PFt61AC6z0KNDILpnx0zflbeR9UMR0RFoko6ZQ54Hpcaf426Ljs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237414; c=relaxed/simple;
	bh=2IABv9Of7yUdk6BmDk24hkuTiZqHQYRnK/28Wy5IDMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T65Ser3Pg1uEOEyKAruV9M3VNQBKdYRqamFfj8QJJQ+2N54o/RPuLysGNDeUHug0taQgcHtKPZCthAVLGqVH+tfrSShFUc3fSooPf40+Ps9A7hNlWqBTLIcDVphIU6bB9xor3FsF5oFyqXHOBC56+iLKC2NdN36g8L7k6mPlTHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VA0ggcm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA0ggcm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B241F000FF;
	Sat, 12 Sep 2026 18:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237413;
	bh=YZzLI5ClrhDWYf520JoZg/Gq++gMWHXFEXFwIENkDZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VA0ggcm2LmsUhioepwDUgZ3pmCtfGx3T53NR51drnOW4ph6PpjCSvrwWyblgnBif/
	 +SsByWSVV1QQ/7RhEUxvqMPrPDGBY5w70aNCmwrteMC5KwgIfREFGpQpEvZX5wxQ6C
	 a0ryS1Xyaq7MtouIhHX0E1fpTSFU2G167DbnZoyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Norbert Szetei <norbert@doyensec.com>,
	Jongmin Jang <payload.jang@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/935] net: skbuff: dont touch shared zerocopy state in skb_tx_error()
Date: Sat, 12 Sep 2026 08:54:07 +0200
Message-ID: <20260912065531.800429464@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit f66bdb1cc0fcd227a062378f8be0b5873aa5600a ]

skb_tx_error() completes the zerocopy uarg and clears
SKBFL_ALL_ZEROCOPY, and skb_zcopy_downgrade_managed() clears
SKBFL_MANAGED_FRAG_REFS. Both live in skb_shinfo(), which every clone
shares, while the caller only owns the reference it is about to drop.
Through a clone it tells the producer its pages are free and drops
SKBFL_SHARED_FRAG for an skb that is still in flight.

Open vSwitch reaches this with a non-last OVS_ACTION_ATTR_RECIRC:
clone_execute() sends a skb_clone() into ovs_dp_process_packet() while
do_execute_actions() keeps forwarding the original, and skb_clone()
does not privatise the frags here -- skb_orphan_frags() returns early
on SKBFL_DONT_ORPHAN. A flow miss on the clone then strips the marker
from the packet still being forwarded, and a later local ESP delivery
decrypts in place over frags it does not own privately.

Skip it for a cloned skb. Nothing is lost: skb_release_data() clears
the zerocopy state once the last reference to the shared data goes.

Fixes: 25121173f7b1 ("skb: api to report errors for zero copy skbs")
Cc: stable@vger.kernel.org
Suggested-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Tested-by: Jongmin Jang <payload.jang@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/CFAB292A-674B-4C14-BB2C-BB8830AD5659@doyensec.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ There was no 'if' on 5.x as there is no skb_zcopy_downgrade_managed(). ]
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6281cfed03bb2..83ad581b12fa9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -889,10 +889,14 @@ EXPORT_SYMBOL(skb_dump);
  *
  *	Report xmit error if a device callback is tracking this skb.
  *	skb must be freed afterwards.
+ *
+ *	Does nothing for a cloned skb: the zerocopy state lives in
+ *	skb_shinfo(), which the clones share.
  */
 void skb_tx_error(struct sk_buff *skb)
 {
-	skb_zcopy_clear(skb, true);
+	if (skb && !skb_cloned(skb))
+		skb_zcopy_clear(skb, true);
 }
 EXPORT_SYMBOL(skb_tx_error);
 
-- 
2.53.0



