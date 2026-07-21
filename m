Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53570231829;
	Tue, 21 Jul 2026 22:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673620; cv=none; b=ZyMvF71G573sGfMSrVRAtan4lQS4fINnJrsQ3W/FewvS3Z/XfNvpSOPiAjdCV+DLltqv10nVsZnThJyEhdMLGBDUj0tnJC8OqSXWZVhW7rfSoYs9ScrSB5L8L+axwHpu8xLLKFyYd0UVW8PkMGf7vvT3rY5zPOaDJ5c5BaDue7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673620; c=relaxed/simple;
	bh=ivVrO7haA+1a2tCJx91TitnchKSZdydk4uVlnOxLkDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF8mGzqdiRBvdYjPakoWJ8l+CEnB4jTV5c8JyCrO3Y/FTyZfx8twTcQVm5erKFKyBOlPHOWiYuVNlQxx/H5PM8HUj6JJEjY9yuJlPCnOJBWwYmv6d5aCY4gWNDSl/3IojsGWSMg4P1NMYXenH0J+hSXs4rOgfO8FcUkYgX9ETw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8BaWEp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8BaWEp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C441F00A3A;
	Tue, 21 Jul 2026 22:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673619;
	bh=sDnKo3Y2mVVNrG57fuNvsIJ3MHaFzAR40uIN6I31NSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8BaWEp7Jtf8UKNrD+x6VH6+Q/vMA2DEku2BMPy6jyPqc5s06csbS3ke8yQZclhDH
	 CWkkB2NPBLlZVUfMCYlvBIzeuPMzgojcGAZtAejajozwnM7AJaG4eFqmfsBXJKmndg
	 kijjwVYdGaypBNahkiUOXM7sN/HUFubVGgpjGtrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/699] netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
Date: Tue, 21 Jul 2026 17:19:51 +0200
Message-ID: <20260721152400.934392245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit a625c94144c9b66d32e1f374f909f38db46161c1 ]

The MSS calculation in nf_osf_match_one() manually shifts bytes to
construct a 16-bit value before passing it to ntohs().

This works on little-endian hosts but it does not work on big-endian as
the bytes are being always shifted and set in the same way for all
architectures.

Use get_unaligned_be16() to fix this on big-endian systems. It also
simplifies the code.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index eee87713420dc8..96a5bf099b7691 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -95,11 +95,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 
 			switch (*optp) {
 			case OSFOPT_MSS:
-				mss = optp[3];
-				mss <<= 8;
-				mss |= optp[2];
-
-				mss = ntohs((__force __be16)mss);
+				mss = get_unaligned_be16(&optp[2]);
 				break;
 			case OSFOPT_TS:
 				break;
-- 
2.53.0



