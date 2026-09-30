Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631B54F93DB;
	Wed, 30 Sep 2026 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785487; cv=none; b=hfoLC1wgKEf8cYP9BLcm450KTxwLPdcbEIJQZ5tGS4zzA9jcennECcOAUXy0OUQM+AcwuEVzpBDys8BrAvIyHmXjnbOTRgr9cqf+2rP9XEVvccp8hip3mhaab4/1MBb380eyPwHDwFoSDIU1XWU0pWmIVEQQ+pEsQSAu5EyyMLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785487; c=relaxed/simple;
	bh=+6QAO5YaTD9sfrc1BoQeQz+b/kipgUHlRZxVfhtiMLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU6tVF41LElZt57mai9Q/w1HsVBOm1DVaN8Ll4sBMalEK/GuA/ftJise7Osry5n5WQeZRcc5X0nxrFGW6XxzLt5Ndu+MifGmMsNUZNcwd27eCmdgNyLm4K4GNFXpiIjqJ1NTU+T2BBdWgTBmkbYkM4HMRjISHNrOmGeY1H3v/+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVGt9AZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVGt9AZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FAE1F0089A;
	Wed, 30 Sep 2026 16:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785480;
	bh=oHM5ifF6Sr3OpPuA7Fj7+EijPmJsX0ODqCgaqZiyZmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVGt9AZDcGp7Ze39uooxQiuPvMBWEx68gkQD4vZbWsfbwcxVpmbXuekL4kb+jQ8fE
	 kVR8tmiDPWk2pcT5d+Xx5Fuhm6X8cAjK3MWEBVaM+MHk+nLpTK6taZkreXB54BAohG
	 dMtzet3CUuI0so6Hcmo+YfcFYVt1SvT5gPxbatnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 523/982] netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
Date: Wed, 30 Sep 2026 17:20:59 +0200
Message-ID: <20260930152428.010589629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
@@ -1048,6 +1048,8 @@ static int ctnetlink_start(struct netlin
 	}
 
 	cb->data = filter;
+	if (filter)
+		cb->answer_flags = NLM_F_DUMP_FILTERED;
 	return 0;
 }
 


