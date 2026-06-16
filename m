Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDEB3CEBBD;
	Tue, 16 Jun 2026 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633537; cv=none; b=W6BKIJIyw2VuhgvkEmnNzLX6AIu3V4AIdEOo/ojJxOU54oBvFmdUC928iC33RlJImCWqk5Mvlzdz+DaX9Oq31eITZLK7CN6fWK2nhi/4Daj+Cl+EFyGm1FPQh0gmaGMvyyw5uyuYje8dNOdIoQNbRmLNOy0/UacgqYdSp37sQ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633537; c=relaxed/simple;
	bh=CRLgN48lVh2rTiJDafTjRFiPBTuHdiW0FbD7k4KnfjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJDFMTKAAT/m9EEkSToK7okvm48N0q3O/l/yu8Ie4cMaiFGf7uzsPrOnrFmbd/1HkONe9m/wyLfXBjR7ZWM/yJo6CALtCRR+5Oz3Iv3sgh+V9Z+UefsEaRv7k4Af1kciYsByPlJ0c5XRWWc9APktd5JI2sKFptBqzV290Ew0v8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alMomm8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alMomm8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EC01F000E9;
	Tue, 16 Jun 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633536;
	bh=XBHOd1OtdW9qUbKz/adAvPODX8W3xBau/RamXio8dVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alMomm8ppkf/iBWUNiLhdXkW1WwEo4kM6+3wmwyDQYuiv6K7kt8nzR3rRbpP0W4+5
	 w6A+JwULH3rq+W6+M/JgvcFzCY8MbVEyTIcmcL+z/KzI+EV8EoSePWnpMlSWafITY3
	 A0HdivmmOwi4X2oozX88e7B/MvYPALXYeQljO4j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 098/411] netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST without direction check
Date: Tue, 16 Jun 2026 20:25:36 +0530
Message-ID: <20260616145105.427422466@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

commit bed6e04be8e6b9133d8b16d5a42d0e0ce674fa9a upstream.

An unintended behavior in the TCP conntrack state machine allows a
connection to be forced into the CLOSE state using an RST packet with an
invalid sequence number.

Specifically, after a SYN packet is observed, an RST with an invalid SEQ
can transition the conntrack entry to TCP_CONNTRACK_CLOSE, regardless of
whether the RST corresponds to the expected reply direction. The relevant
code path assumes the RST is a response to an outgoing SYN, but does not
validate packet direction or ensure that a matching SYN was actually sent
in the opposite direction.

As a result, a crafted packet sequence consisting of a SYN followed by an
invalid-sequence RST can prematurely terminate an active NAT entry. This
makes connection teardown easier than intended.

So, tighten the state transition logic to ensure that RST-triggered
CLOSE transitions only occur when the RST is a valid response to a
previously observed SYN in the correct direction.

Cc: stable@vger.kernel.org
Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1170,7 +1170,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 			new_state = old_state;
 		}
 		if (((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
-			 && ct->proto.tcp.last_index == TCP_SYN_SET)
+			 && ct->proto.tcp.last_index == TCP_SYN_SET
+			 && ct->proto.tcp.last_dir != dir)
 			|| (!test_bit(IPS_ASSURED_BIT, &ct->status)
 			    && ct->proto.tcp.last_index == TCP_ACK_SET))
 		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {


