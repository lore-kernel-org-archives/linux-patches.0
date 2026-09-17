Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34AF4DA9DC;
	Thu, 17 Sep 2026 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671161; cv=none; b=grq89PysLBJUezsZO6pwtyDc4ZaNsWNJ6gV+ByNBMjNxs5sBVheLL4lKTwwMFBVGu4k5XY0xFMSe5KzlkfHXMEdTU2rxShrBsobH9a2TvFScVEvU8oNryguw9qGXQbAp5K+A0Y3daOsgXgQz8ZrYyWsUhoJFDLLl7i6RH3ER018=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671161; c=relaxed/simple;
	bh=Mt/As2bRkaS7r2IIyEotjxgIOg3MbXsL455xXjrI4Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clt6WE4Ea/DLs/IIsAzilpw8HDsbglEUWebLIbQwCroaroPInOwPkgX9JLOuBJc1FclUujx9+o08+KOFTyJ+zPiUPbFAdpzToyKH4QaB7frTLlcNyB7YI30u/xZVUMJJmyt9EdvQN8l8vAfLZ5EnE8RIY2kPpf3jDdra6xlnNiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRdtkdr1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRdtkdr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8631F000FF;
	Thu, 17 Sep 2026 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671159;
	bh=R8usT+gfc8jhCwX98hrtHilfasZ3GaM/nkMedJv57io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRdtkdr1fACpHlnJUEYAaOrW9eXmA2jY9k2J279C6CNQGAxoHyPPMZKqADEfCyS+e
	 +YZ1X50TUtm1gVoOhI6O0Rg8VSuW4qxT9c2bNW3YUCN5MjVh1kJVQ8yjzBhRVuN6IU
	 r9JOHwD7rVNbk3s2mnRwtZorIb+0igPBkDStkYeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 0847/1102] netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
Date: Thu, 17 Sep 2026 16:13:10 +0100
Message-ID: <20260917151601.795475084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -1053,6 +1053,8 @@ static int ctnetlink_start(struct netlin
 	}
 
 	cb->data = filter;
+	if (filter)
+		cb->answer_flags = NLM_F_DUMP_FILTERED;
 	return 0;
 }
 


