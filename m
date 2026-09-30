Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2862E39CCE0;
	Wed, 30 Sep 2026 15:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783225; cv=none; b=JWqRD3NdcmceA0GHdqPyLgR61UzsECYI1FGmPpfr/x8U3Oh7NlTO64m1zrEQs35tINVJLCIso00WxFk58kgJhFtBDMP7/tRttc52BLv1ruioXCzNA2R2FFsPp+rerU3IVIzCGBepoDi+uR89fkI6JM4K7hGANORqcwpxSjsge64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783225; c=relaxed/simple;
	bh=6U5TyCDaAK5oLqftQyJKUyZyfndUVeLs5Q5o/rmONHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbzwKzE4mP7t++K7ynhxiLg5VdtI6KAC5TdBf0iZc/xoWb75axsNWMPOBjekKgPnELxVleg94N1U0l4RAjttwCYcHSKF579p7YWaF00D9NoPe6Klw/4CPP335xwh12yqndE/6w8XPbJpavpXpO+7764EHXESOCGE76060sVQRhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppRAgs01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppRAgs01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2554C1F00893;
	Wed, 30 Sep 2026 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783219;
	bh=l2kHoPtK13jFnDyvf65WuB80z7p++ZUd0XKtg3Q8XCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppRAgs01K1ECxOM4MK6dPNJJHiVanVuBdDEU+kYdZin4t6pmQ1G9Aid7hCkFp7C8E
	 vin9rgzIBKFANTAhUiEHBBFaY2Mm8hL+oLUOrGP67V1rOlQOWBNikLFHt1I/Otxl/C
	 SdDMfo8/6B+F1urYFv2EYm+CrUzGcotHe2QwoKZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 305/595] netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
Date: Wed, 30 Sep 2026 17:23:18 +0200
Message-ID: <20260930152354.250351884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -989,6 +989,8 @@ static int ctnetlink_start(struct netlin
 	}
 
 	cb->data = filter;
+	if (filter)
+		cb->answer_flags = NLM_F_DUMP_FILTERED;
 	return 0;
 }
 


