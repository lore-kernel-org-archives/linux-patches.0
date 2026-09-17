Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B303783BE;
	Thu, 17 Sep 2026 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660326; cv=none; b=AzMK71w51Tc2bLiJSLWYuyV0eNGzSV6sxL3x+NVwpvnc+m9gPcd8f/F4dHKyo02k+CHid2CvKYT2Ha8Dwz5MwhYg/WzhX/eNXrgiKRGL1Jn8zc330KqnUJhAfo3VD4ERBcJf8z1ynGD7JynLNmQnVqACJpOItx5qvXm4Z5U70IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660326; c=relaxed/simple;
	bh=h/x/CWIMOniEg0sQiDUnHQep6Bi1OsT9il+Iqfvj6/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIJ51rDjckpvVxiiLPgbXmvQwUQ2R37hqCQ6l+Ey+P5dk0lPT1UrJ4sz4auvM+ZxpIBX/R1VfRTAapOYInRSRDq2VYopiPMkUvqpmlI7ExN0SzgHQ9i4ZOD03bY/M3AeyZatfFvSlhb7JqHE0hkfeRhnnC+6TgpObXv3BfYe3FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzr2Md8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzr2Md8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A57D1F000FF;
	Thu, 17 Sep 2026 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660324;
	bh=WV/QmUxmZCWP/O9J8+65cyIPnuFCPk+4vCoPqeT2BUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzr2Md8CSSAbSYbYcS3Kn2aiwCPFQ9LcxoRva7FUpgIs9l07WwA5cEOdvlaFdTtLM
	 6V6vvQe2UHjyMLopKEb/0jAHJOd9Y+///2c+Ac5oQOpzPBO7Ue8a/9SmE+0ovKCR54
	 pdCCOOw6PixiriBIQdLYnYupRyZ4AAxlpmzAbBmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.2 554/733] netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
Date: Thu, 17 Sep 2026 16:14:22 +0100
Message-ID: <20260917151406.082268552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


