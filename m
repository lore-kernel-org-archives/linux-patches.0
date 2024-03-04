Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73036200CD;
	Mon,  4 Mar 2024 21:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588609; cv=none; b=Kreu3Kerbj8lTmq83zz/xC8hl6Q1EIfWE+rzvxccWibNHP+1oONF1Mr3shElVUeDr12sWA0+vaUusfS6j+nBvhUX43waAl9dR6NQpws8IuP63OCHngOfDYvfmJJcvcSO7sn7J7mYsVYp1sckyT6ebP0UzSFpPMxTSp9AGrCYv5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588609; c=relaxed/simple;
	bh=pQyvvKRaID4syK0jFPazh3LTrTjg8/kcDz6n6dhZlMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQAqG3Rr35h6vSZZC+DzszcMrqVEwPAOFoLf49tclzFlTfnhJlQCavtlAM59DD/hvpPPme+VI0DKHIDcFmcWQs0tdpFExtygGU42VTaSbXP3sc8f4ogcWGgAde7NM/ndrBpJ3YlQE3qv58sZ3/XfLTlBneDHMQRmPp1GQazq+B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgR9NwD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgR9NwD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F235BC433F1;
	Mon,  4 Mar 2024 21:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588609;
	bh=pQyvvKRaID4syK0jFPazh3LTrTjg8/kcDz6n6dhZlMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgR9NwD0eAqhV/PKZejbjDeIc89MnfdW93PJj7nEAxlxiFRRdR7Y+rmIDaupwUh5s
	 vo9dkgD8yA+45u6PDgVuR4HgJ2iZVKx/6zi+0YFbmr20dpwSTevxJsZ6jloUTwEypU
	 pmrJL8E+dLmdkFZfJmNmLj/ROexfNMPuOwQTdtzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com,
	xingwei lee <xrivendell7@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/215] netlink: add nla be16/32 types to minlen array
Date: Mon,  4 Mar 2024 21:21:32 +0000
Message-ID: <20240304211557.914925619@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9a0d18853c280f6a0ee99f91619f2442a17a323a ]

BUG: KMSAN: uninit-value in nla_validate_range_unsigned lib/nlattr.c:222 [inline]
BUG: KMSAN: uninit-value in nla_validate_int_range lib/nlattr.c:336 [inline]
BUG: KMSAN: uninit-value in validate_nla lib/nlattr.c:575 [inline]
BUG: KMSAN: uninit-value in __nla_validate_parse+0x2e20/0x45c0 lib/nlattr.c:631
 nla_validate_range_unsigned lib/nlattr.c:222 [inline]
 nla_validate_int_range lib/nlattr.c:336 [inline]
 validate_nla lib/nlattr.c:575 [inline]
...

The message in question matches this policy:

 [NFTA_TARGET_REV]       = NLA_POLICY_MAX(NLA_BE32, 255),

but because NLA_BE32 size in minlen array is 0, the validation
code will read past the malformed (too small) attribute.

Note: Other attributes, e.g. BITFIELD32, SINT, UINT.. are also missing:
those likely should be added too.

Reported-by: syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com
Reported-by: xingwei lee <xrivendell7@gmail.com>
Closes: https://lore.kernel.org/all/CABOYnLzFYHSnvTyS6zGa-udNX55+izqkOt2sB9WDqUcEGW6n8w@mail.gmail.com/raw
Fixes: ecaf75ffd5f5 ("netlink: introduce bigendian integer types")
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20240221172740.5092-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/nlattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index dffd60e4065fd..86344df0ccf7b 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -30,6 +30,8 @@ static const u8 nla_attr_len[NLA_TYPE_MAX+1] = {
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_BE16]	= sizeof(__be16),
+	[NLA_BE32]	= sizeof(__be32),
 };
 
 static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
@@ -43,6 +45,8 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_BE16]	= sizeof(__be16),
+	[NLA_BE32]	= sizeof(__be32),
 };
 
 /*
-- 
2.43.0



