Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3D163B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28742C433D2;
	Mon, 20 Feb 2023 13:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900534;
	bh=yP50BR0ig4/lVQ9anDF9lxOqUsFyEn6FuCOxhbWvJC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEDcB2pyk4tHr5/+M8Blp+t2oX/XJmUhI535WS0shk1sf+cLjTFhF/X2zqgUXXnCm
	 7pzucnLUUELqUdJlAaiCtSCkQpdVKTubN305b60ugqJ+5hrrs6LeJDHkX4vKb3V2eb
	 Y8v51RloHELChmOqigKWZkk5AJOwLUFaqSVMhJAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Ahern <dsahern@gmail.com>
Subject: [PATCH 4.19 62/89] bpf: Always return target ifindex in bpf_fib_lookup
Date: Mon, 20 Feb 2023 14:36:01 +0100
Message-Id: <20230220133555.324166482@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit d1c362e1dd68a421cf9033404cf141a4ab734a5d upstream.

The bpf_fib_lookup() helper performs a neighbour lookup for the destination
IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
that the BPF program will pass the packet up the stack in this case.
However, with the addition of bpf_redirect_neigh() that can be used instead
to perform the neighbour lookup, at the cost of a bit of duplicated work.

For that we still need the target ifindex, and since bpf_fib_lookup()
already has that at the time it performs the neighbour lookup, there is
really no reason why it can't just return it in any case. So let's just
always return the ifindex if the FIB lookup itself succeeds.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Ahern <dsahern@gmail.com>
Link: https://lore.kernel.org/bpf/20201009184234.134214-1-toke@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4235,7 +4235,6 @@ static int bpf_fib_set_fwd_params(struct
 	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 	params->h_vlan_TCI = 0;
 	params->h_vlan_proto = 0;
-	params->ifindex = dev->ifindex;
 
 	return 0;
 }
@@ -4333,6 +4332,7 @@ static int bpf_ipv4_fib_lookup(struct ne
 		params->ipv4_dst = nh->nh_gw;
 
 	params->rt_metric = res.fi->fib_priority;
+	params->ifindex = dev->ifindex;
 
 	/* xdp and cls_bpf programs are run in RCU-bh so
 	 * rcu_read_lock_bh is not needed here
@@ -4447,6 +4447,7 @@ static int bpf_ipv6_fib_lookup(struct ne
 
 	dev = f6i->fib6_nh.nh_dev;
 	params->rt_metric = f6i->fib6_metric;
+	params->ifindex = dev->ifindex;
 
 	/* xdp and cls_bpf programs are run in RCU-bh so rcu_read_lock_bh is
 	 * not needed here. Can not use __ipv6_neigh_lookup_noref here


