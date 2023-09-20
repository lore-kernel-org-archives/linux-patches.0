Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9955D15AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB80C433C8;
	Wed, 20 Sep 2023 12:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213490;
	bh=G9DqQ+jNkFa+IFlwK13IhGAXOW//nxN4gF58Jt5Dhk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjdWRARC3gE/Q6PDwgIV9zKQKsTj69KpDQEDJ9Bib1JvwP1WftYvYaAie55liP6AY
	 iRmb0MDKoPOm4jG6WS8wjD6RcQy89AW8tnpT1reacYSDXzxdMFGhSV8Xe0kzrn2JOE
	 8jqLxoRUcwuTj7DcrRNC3NW14ZUrdzBVWFH2cpQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars Ekman <uablrek@gmail.com>,
	Quan Tian <qtian@vmware.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 239/367] net/ipv6: SKB symmetric hash should incorporate transport ports
Date: Wed, 20 Sep 2023 13:30:16 +0200
Message-ID: <20230920112904.752845353@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Tian <qtian@vmware.com>

commit a5e2151ff9d5852d0ababbbcaeebd9646af9c8d9 upstream.

__skb_get_hash_symmetric() was added to compute a symmetric hash over
the protocol, addresses and transport ports, by commit eb70db875671
("packet: Use symmetric hash for PACKET_FANOUT_HASH."). It uses
flow_keys_dissector_symmetric_keys as the flow_dissector to incorporate
IPv4 addresses, IPv6 addresses and ports. However, it should not specify
the flag as FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL, which stops further
dissection when an IPv6 flow label is encountered, making transport
ports not being incorporated in such case.

As a consequence, the symmetric hash is based on 5-tuple for IPv4 but
3-tuple for IPv6 when flow label is present. It caused a few problems,
e.g. when nft symhash and openvswitch l4_sym rely on the symmetric hash
to perform load balancing as different L4 flows between two given IPv6
addresses would always get the same symmetric hash, leading to uneven
traffic distribution.

Removing the use of FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL makes sure the
symmetric hash is based on 5-tuple for both IPv4 and IPv6 consistently.

Fixes: eb70db875671 ("packet: Use symmetric hash for PACKET_FANOUT_HASH.")
Reported-by: Lars Ekman <uablrek@gmail.com>
Closes: https://github.com/antrea-io/antrea/issues/5457
Signed-off-by: Quan Tian <qtian@vmware.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_dissector.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1564,8 +1564,7 @@ u32 __skb_get_hash_symmetric(const struc
 
 	memset(&keys, 0, sizeof(keys));
 	__skb_flow_dissect(NULL, skb, &flow_keys_dissector_symmetric,
-			   &keys, NULL, 0, 0, 0,
-			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+			   &keys, NULL, 0, 0, 0, 0);
 
 	return __flow_hash_from_keys(&keys, &hashrnd);
 }


