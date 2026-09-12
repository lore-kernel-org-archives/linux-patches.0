Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8072E7631;
	Sat, 12 Sep 2026 13:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220907; cv=none; b=Wv8GgTt1rIlim278WBIOXKIgNiJE2UNqDKeSlyxHKvev+InyuUaSxQMFCAagMmjC4S1V6LownREdLWYzqj5paA+JOPjTZJJBzLIE/b3TbrFfbdPqColOW7BG5kILX9iq5uJVMK6amIX5M/4BxB3Zt7b1iiHvQQYsRQu6YrO7wpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220907; c=relaxed/simple;
	bh=88TclrEHqwPnMpKo0WC8BL7QIijWgNQWrd2Xyhhf/v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBZHcegEJP+OhkfhaBaPUxe1dWvv4hlbE79P53RmBn7PP8Xxl2UEXipztYCqM9qCLVSSilRravbH7jAqMF8UXpiMXTO30u+PZvCo508aCdCjNku66Ds91AlOXMp5KbMeDC2vJYN/Y3x5bVYgbEMXc+yfnPgVlymit3g5Y6Zmz5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrfdpZVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrfdpZVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95481F000FF;
	Sat, 12 Sep 2026 13:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220906;
	bh=kBK/aU36QPaHGoQfYd+daUH61fzwSpj88tzYBw6WWyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrfdpZVLX/4weBvspw8ROBFe2R+ZK+9s5sARQ4PF7wxXoBp3pfXcaEQFHadIldTGK
	 IUjAgT6UYMlYFDrH0AKf2H8AaIg49sdoJGdxIf2YsP9XpTRCRaW9W9XqfOL7aCxjA7
	 xjWnwIhkALUNCxm26w+k7CG+oC1MNZ755B5qvAnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Norbert Szetei <norbert@doyensec.com>,
	Jongmin Jang <payload.jang@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 0274/1424] net: skbuff: dont touch shared zerocopy state in skb_tx_error()
Date: Sat, 12 Sep 2026 08:45:06 +0200
Message-ID: <20260912065613.412736953@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

commit f66bdb1cc0fcd227a062378f8be0b5873aa5600a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1256,10 +1256,13 @@ EXPORT_SYMBOL(skb_dump);
  *
  *	Report xmit error if a device callback is tracking this skb.
  *	skb must be freed afterwards.
+ *
+ *	Does nothing for a cloned skb: the zerocopy state lives in
+ *	skb_shinfo(), which the clones share.
  */
 void skb_tx_error(struct sk_buff *skb)
 {
-	if (skb) {
+	if (skb && !skb_cloned(skb)) {
 		skb_zcopy_downgrade_managed(skb);
 		skb_zcopy_clear(skb, true);
 	}


