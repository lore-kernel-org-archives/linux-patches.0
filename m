Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEC070808;
	Sun,  7 Jun 2026 10:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828963; cv=none; b=YACf9ysVzmNG0yAjr7MnQlB4+RNvrjRombBluDhTAbtXM+5jseeFBKefzFRt50soeLZiVjJzwun8j8+L2bBJV9YoVXyZgKxTXFFLGd4Xqur8OZVJEdLHIKTjzAE9eXTEZXfjkUu7jfa79I7O5EyO9W2016o4OPK7e2mpKlTLkoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828963; c=relaxed/simple;
	bh=IvJOACamxAmTmzJuTR5oLMs+Fw7JF9SLZOrAUR0KJ7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqUbVQc7votIbFhVm7Gm575ZtqW6N/tpQEzO+R22TOuIQTBIYX6OGfsqc3Eo+hjcTpnoFo/d9lm6vGdvaVEqcbUQ2Db37PjRkqrO3ezJ0hK/hBLyuImNMYfkrFrGKqzD1xYe39idiX4H6MyZOJ9EdgIfZEPzLYCOydpV9zHCFkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA1WiKbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA1WiKbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0681F00893;
	Sun,  7 Jun 2026 10:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828962;
	bh=HJtyKJl0iGmZ4mXlVMGr8lyjLScsLrf0JLtikD/XLhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA1WiKbR8lqYu6vBQHqWrPxdrqhvP4L0rScix+YpgvXBZ0+Vi7A8IA2XrUsuwhkzV
	 7kCzJcDSurOCacvmzzNVnX7Yn7knjCheHXWAiaOc8Rvxryz5m4rmeWkL6x79xXh5Cj
	 smN0BlY0iBI/faDqIaNvKGhbRhQE5gTM1FNjoHR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.0 230/332] netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST without direction check
Date: Sun,  7 Jun 2026 11:59:59 +0200
Message-ID: <20260607095736.501441492@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1221,7 +1221,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 			new_state = old_state;
 		}
 		if (((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
-			 && ct->proto.tcp.last_index == TCP_SYN_SET)
+			 && ct->proto.tcp.last_index == TCP_SYN_SET
+			 && ct->proto.tcp.last_dir != dir)
 			|| (!test_bit(IPS_ASSURED_BIT, &ct->status)
 			    && ct->proto.tcp.last_index == TCP_ACK_SET))
 		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {


