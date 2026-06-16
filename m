Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7573BFE5B;
	Tue, 16 Jun 2026 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630986; cv=none; b=Xf9eKMpWXcSWejO8svz8Na0OjvbB5CtzZaj/KJAZKf14K54R9fHNfTi+2HzViJBS3Ao25c2rgS1d3Q97L0iSLmzX1oQVx5Qid2Niyo3Rn+gPd/YVLnyCWovsEr7yQModhd+xB0fQlkaBLnYGgf9XE5bXp0ujH8OviEQtDlORxlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630986; c=relaxed/simple;
	bh=z06MKUgJ4aooyWCxTs5pS1tGFVMLjAqa6E7y11bn+wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHAOZ2V8b6Vbz5+oMZniu8b3hPEOZYIoEMj2lRUrzycpjWH/IaHV0c5fQTgJkWD8aYhZnJVUAtvhw32ezGTnSqisbqkhZzqwwZMylRc7iSLH3BjJV6CNt9yLsqGhTmgW+QO0p9Kt/bARS2N7B2nLDruZKRFupq9oKuUUnPzZBJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivcszbdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivcszbdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB691F000E9;
	Tue, 16 Jun 2026 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630985;
	bh=fDYFQdbbtwlYMnGwNv5f7XwjKMAi1FdrtIoVsDckxLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivcszbdQioIkhVOed7T/cXzGKyoGX6vo07tq7fVE0SFyVGsD/WzHlATu8AD0nn5aV
	 LUigPC/PHapqrstoZbubBD8iOkPauS1CPU+/klegWOPlRD9mjbEUJLD9TmF28bpY5U
	 t/qn2ONZOGaxxDtm/+2VLVnrZFiEWce7LqRByNK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 133/522] netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST without direction check
Date: Tue, 16 Jun 2026 20:24:40 +0530
Message-ID: <20260616145132.329518959@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1222,7 +1222,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 			new_state = old_state;
 		}
 		if (((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
-			 && ct->proto.tcp.last_index == TCP_SYN_SET)
+			 && ct->proto.tcp.last_index == TCP_SYN_SET
+			 && ct->proto.tcp.last_dir != dir)
 			|| (!test_bit(IPS_ASSURED_BIT, &ct->status)
 			    && ct->proto.tcp.last_index == TCP_ACK_SET))
 		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {


