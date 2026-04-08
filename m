Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFA62494F0;
	Wed,  8 Apr 2026 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672473; cv=none; b=bwXs3WHaBHnPCTABNT+uBr/mj4luwRV8MHcQxaTcQCvIZ4zp2IUMS3Trl/QE6LVeZKOGoSjrvJ5zTHrd2W6Eg4ZGGr/IemTYYnsCC5146vLjYkO4ylgyqsXpEnX+z9GuNc+GTguc2q7DQCa6DYPgURpbOH4nSDiWmyMglOXwFhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672473; c=relaxed/simple;
	bh=a9bsNPsLUP7H/uJCdSRoo8dhNTi0b7WD53TaxgZKZRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmK0YdxwnGJZNpws6hjrYP4W89bzvRWmM56zFFobFBgycruQcnU6IxkoPX1bU+1LN7Sj58Rq3Ksd150LooaEeFvkxht+wXtP3uUxapOefR6g/kqsANU8QZS8B73rAEnVtBlk9COeefcXbbLhjbcPqNLQLCBWFppMoQV3NwvK2d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQrzjoQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQrzjoQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E36C19421;
	Wed,  8 Apr 2026 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672473;
	bh=a9bsNPsLUP7H/uJCdSRoo8dhNTi0b7WD53TaxgZKZRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQrzjoQtbuwEdIjVG6njqpNnzjmGITGuJqiugdiRsJbD7zMsVTe+WXqfkafJkuTAq
	 CxCJlrdzX8mbIdfI2DbhAkYv7FKNqDY020oSs7eZkJ+OulY8stYlfJuslwCWOP5A4Z
	 1OePMwdiO0+PXF2fBEDxsLHu7BN2pDeFB5qcXiQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/160] net: ipv6: ndisc: fix ndisc_ra_useropt to initialize nduseropt_padX fields to zero to prevent an info-leak
Date: Wed,  8 Apr 2026 20:01:47 +0200
Message-ID: <20260408175913.952479459@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Yochai Eisenrich <echelonh@gmail.com>

[ Upstream commit ae05340ccaa9d347fe85415609e075545bec589f ]

When processing Router Advertisements with user options the kernel
builds an RTM_NEWNDUSEROPT netlink message. The nduseroptmsg struct
has three padding fields that are never zeroed and can leak kernel data

The fix is simple, just zeroes the padding fields.

Fixes: 31910575a9de ("[IPv6]: Export userland ND options through netlink (RDNSS support)")
Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260324224925.2437775-1-echelonh@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 80ceb401ecf2d..652263e2f2d02 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1216,6 +1216,9 @@ static void ndisc_ra_useropt(struct sk_buff *ra, struct nd_opt_hdr *opt)
 	ndmsg->nduseropt_icmp_type = icmp6h->icmp6_type;
 	ndmsg->nduseropt_icmp_code = icmp6h->icmp6_code;
 	ndmsg->nduseropt_opts_len = opt->nd_opt_len << 3;
+	ndmsg->nduseropt_pad1 = 0;
+	ndmsg->nduseropt_pad2 = 0;
+	ndmsg->nduseropt_pad3 = 0;
 
 	memcpy(ndmsg + 1, opt, opt->nd_opt_len << 3);
 
-- 
2.53.0



