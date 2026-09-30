Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DBC345EDD;
	Wed, 30 Sep 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791688; cv=none; b=c9YLyeK4c06HfLMV/1qfuP2b/Ms70H40Z88t9nvF0gefstn+rhp0fg75auSJn1/rXIfZwnfbQ5ET2YsTA3FTWaVa1QYEbzgXOeFQYAWUCPT357P+rxqMi7mkVx7zo0ult1N+9tTJIjH/lKjl2n3GZ69l8U58xpWkN1tNBNK3LxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791688; c=relaxed/simple;
	bh=BCR/V9BkB96V4/Pke8pwisMEFbe7eHuMFWRgYn8jdr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZbk/rLXBINcr4yxIGz0MdkIITzjEr8C9RnFDKIP8JKJcwlfLzHRhU5azdM84tkuiaPtjJOM/e2gV+f+jlAXD9s+iedKUswUhDGXtGp0EHRZqwms41ZfNLQhDosr8YMnGnaKEc6TNwJJYDEkGivvdUNm7hmM6QTTaFGZ1cad8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdHIcDB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdHIcDB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9D71F000FF;
	Wed, 30 Sep 2026 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791687;
	bh=GFIFDWg1wNj2YCNpZYczSdWKKvzUpYOPdPh8z+yz/1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdHIcDB5ikf0orh8Q5kQVZS4F7zQ2OM6ek6JEdSfZBMxxDPNQWhJfValy66sun6d6
	 IDnjGaSoqgmmrCAoAn4D/tjsY4WCVzUMbCqbxyRBlhLJPxsXDX/1iq6S9DJlJAHkdK
	 CGs9mLsnM6jjtGNOq8WB56C80KbKDWl1ppFgKAEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 390/752] netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
Date: Wed, 30 Sep 2026 17:24:20 +0200
Message-ID: <20260930152406.717826631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
@@ -1037,6 +1037,8 @@ static int ctnetlink_start(struct netlin
 	}
 
 	cb->data = filter;
+	if (filter)
+		cb->answer_flags = NLM_F_DUMP_FILTERED;
 	return 0;
 }
 


