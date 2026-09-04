Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DA840F754;
	Fri,  4 Sep 2026 06:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502874; cv=none; b=BeilgP7LDpbNLIsf/N9Yg1f4n2aNmXIHFtnNhU4WckCFqKmkctQqX0cMzppOblGRtUEFJc63MWT4T3ln0Ye90Wx7TKgDCEBqOFDA29AkPZs2P0E26/8C7Wr7ICc6g5zaLgHym8cQVGSj+n390vHMGYemp21BrY/SiW/hICNUSuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502874; c=relaxed/simple;
	bh=nU0oL85gUEN2aYcbDvNvTox1kV1NOP9cfx7E1iLwhGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfdROvZJnSXkBoh98ndGP2idvQwzqWNd9pDAzcnWT0ZjsquLDa+qRqzidAWAyVkoFIQhxwRhvUjD/uXi4CfKfxctJ5/vi4bVubA36IapGd+eBw9R2pQ1vzB3SmGS06uNDMl8cfMER6aiTpoRaWwLI13xj2U4RIIDfjYwNm622c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVZOLHHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVZOLHHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4C01F00A3D;
	Fri,  4 Sep 2026 06:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502873;
	bh=QTK+bNe8UjXA8701WcA6U7ygHXMv003aGNqsYsLx4ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVZOLHHwsrMpkzxC/sHOAsKd4AgVu9BeBa2FH84ygjvAdmsnVkNC0CwmoaQUKLvsM
	 GQBZc38lXxEwieGSD+mAahdHdpV0DlQ+SVhiYnt11L8P/xtBCZwySrOOe4gJ3S0p1V
	 nsiNrLACEKFbcbOKX0o/w6MAhvVZW02bwsvUaJz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Norbert Szetei <norbert@doyensec.com>,
	Jongmin Jang <payload.jang@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 358/403] net: skbuff: dont touch shared zerocopy state in skb_tx_error()
Date: Fri,  4 Sep 2026 07:02:41 +0200
Message-ID: <20260904045742.955429978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1403,10 +1403,13 @@ EXPORT_SYMBOL(skb_dump);
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


