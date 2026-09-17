Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E33B51A13F;
	Thu, 17 Sep 2026 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666510; cv=none; b=uRz23c2ctp50CzvzpDTVMbK4NKvWlKE+/tsbuNKt/GdUCMhJ1+FrDjvYWSRxJ+fQgIuRYxc2Y+hxGSGF7bXXEA4QBy4UuYNQHzG0K8HktA/t8ant8w5v79Oa4X8w5eVsaf/cFV85bl8Je2rXnFzmteBpgQGNosVhHkiMtYDzpC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666510; c=relaxed/simple;
	bh=/paDxeEiCJEA/vp1CH3hdxAA/6ezoFP0bPhLUNdAcmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqzyAeaplKVqnv8x1Xox7zN0rl8R1CA/GsD4TL9RnfhgrkLofjo08j+ZGOd8GLYKvCE51QmVFJVaUGl2DYGGjxmssQ+CGZSa3XATBTkE0rdGTiUltGYD5kzBeEPHU0yJU8WVWtrOvMv1EufbWnJZjxe6xUsy9upl+Dqd+8cEKjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEoTgzwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEoTgzwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3301F000FF;
	Thu, 17 Sep 2026 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666509;
	bh=JpNx6BQ2uic8hjKc+EjyJXEh9bb+HIlatFmOwHd0Ka8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEoTgzwZUgIGYTQLbsnnS6tctNjOG6McdxdkQworPJKyNpnvu2XPPHlhHax2RzWxU
	 sDRoEEmAUerh1QN7elVf3jBv+nVYLdHRFNzJDvc5UGXtTgI/UujlrepZVnAtePIKlz
	 /6aZYLX5YotYo4t5r6KX9EBeMPF84kN1iL59Ed/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 1024/1250] netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
Date: Thu, 17 Sep 2026 16:13:39 +0100
Message-ID: <20260917151619.812700022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit 7a099b347fef536a84068076e2d384f044e5cfc5 upstream.

NLM_F_DUMP_FILTERED is only set on data elements in the conntrack dump.
But when everything is filtered out it is confusing for the user space,
since the flag is not reported anymore and it looks like the table was
empty, which may or may not be the case.

'answer_flags' were introduced precisely for this use case, and the
conntrack dump should set the flag in there in case the filtering was
applied.

This is important, for example, to be able to tell if the filters are
supported or not by the kernel without modifying the kernel state.

With the proper reporting of NLM_F_DUMP_FILTERED on NLMSG_DONE, an
application in user space can just try and dump with an arbitrary
filter without worrying that there could be no matching entry.  The
reported flag will signal that the filtering was applied and therefore
supported.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_netlink.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1077,6 +1077,8 @@ static int ctnetlink_start(struct netlin
 	}
 
 	cb->data = filter;
+	if (filter)
+		cb->answer_flags = NLM_F_DUMP_FILTERED;
 	return 0;
 }
 


