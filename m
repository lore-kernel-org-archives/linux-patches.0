Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA852690EC;
	Mon,  9 Feb 2026 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648547; cv=none; b=sCaCu+xNevzxiCmrG5eA3iGk9rPiZM3ZQK/h8rB/FhWDdGIZsc4uAZsPY+7vvL5RwUfEIEfbvQp/JHEi9n57A9j2mQzRajP523zREBUdYLysyg5BvxkXDmviadDqwCtHqmPnguoS2MzyS6uqvvv7rrLSGnqrD0dkdWN1nAfkFcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648547; c=relaxed/simple;
	bh=BPqAeuQsN1ed6ll4+QM/ZS9JGxuia4k+pPkBUpzMjyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wc1bYDHdfwrCSTqKvSlx8JbW9ex/Gmor/cBcmWd+m/qSOWvxPdYGnS+S1k8A5SPk0H2KJ4ty5E2cigyC7XfrOkuTbQsAyZYhkjmkcrZSCd4kKTBjF+U/cBydZ2iV5TsjX7YQIIwPNezieqHPyHnZbYOOQ3aP+HjorSNjy8siNL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gr9at36o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gr9at36o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF3C116C6;
	Mon,  9 Feb 2026 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648547;
	bh=BPqAeuQsN1ed6ll4+QM/ZS9JGxuia4k+pPkBUpzMjyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gr9at36oeg7wwwWfR8KzqIspF6jnWhmT+eiB5CbobwNprno7r8iftLPGT3kt0Exws
	 zEYan9KhexM/H19Qcx3g+GXx3mVcDE2SaA+aRNz8YRuzbst6M3HqCAraQC6Om99dmD
	 GUPvKE14K9K9qmoJqEncvezj2quWjMLe2Mgm6d7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 71/86] net: gro: fix outer network offset
Date: Mon,  9 Feb 2026 15:24:34 +0100
Message-ID: <20260209142307.331706897@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 5c2c3c38be396257a6a2e55bd601a12bb9781507 ]

The udp GRO complete stage assumes that all the packets inserted the RX
have the `encapsulation` flag zeroed. Such assumption is not true, as a
few H/W NICs can set such flag when H/W offloading the checksum for
an UDP encapsulated traffic, the tun driver can inject GSO packets with
UDP encapsulation and the problematic layout can also be created via
a veth based setup.

Due to the above, in the problematic scenarios, udp4_gro_complete() uses
the wrong network offset (inner instead of outer) to compute the outer
UDP header pseudo checksum, leading to csum validation errors later on
in packet processing.

Address the issue always clearing the encapsulation flag at GRO completion
time. Such flag will be set again as needed for encapsulated packets by
udp_gro_complete().

Fixes: 5ef31ea5d053 ("net: gro: fix udp bad offset in socket lookup by adding {inner_}network_offset to napi_gro_cb")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/562638dbebb3b15424220e26a180274b387e2a88.1770032084.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index b8cc44406e69b..87889cb75d219 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -240,6 +240,8 @@ static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 		goto out;
 	}
 
+	/* NICs can feed encapsulated packets into GRO */
+	skb->encapsulation = 0;
 	rcu_read_lock();
 	list_for_each_entry_rcu(ptype, head, list) {
 		if (ptype->type != type || !ptype->callbacks.gro_complete)
-- 
2.51.0



