Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FA147143E;
	Tue, 21 Jul 2026 17:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656311; cv=none; b=B/0WIRpYZ1zC9amwFHfFhuek18fa/UBqWCBX9gHkCfEKcDP+et5RuYv6CqZ55wk6EQDrJ3547lf0ymnb1Lz3gmLuhbCbG+AvuLeBnG2vMTc1axttheCyr5xk0fkwBTdLQRF1cCYCwgUC85znTW21OjvQumrNDRemSlBbiD+0TJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656311; c=relaxed/simple;
	bh=vvdr1+d9/A6vGn4mhC5Nz/tnlQ9tOM8D7JG6SVwnEfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKhxNUQK57d2a+FntKGDVQMSeq+fnZcvO7tUDzYuovZ/FpJHGT3c7ohq31d99GLofWkbW/cSnkMmsVgJ5adGuN1kwPs6WHO+dekOAYtnoIAWInHBylmRayVXvuniMR/aY2ThAcZgwCXSEARedEZSspFV2QOXv8NeTNr/8Q+DyA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6fQyS6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6fQyS6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525D51F000E9;
	Tue, 21 Jul 2026 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656309;
	bh=3M9an6HFmKDXisHZkP8P933UQA6QCUeY8NF4Mcu3mAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6fQyS6iUk4dqNw9T3X0hoXnXpvaqSRXATRkpNpEcoPyH7oWy0A+VJL8FhYdnspZQ
	 zGl/dmRgBX1UiwNDrBHvFm2w/aGTG/VEnNsL0lSGxkDCD0MFNEiVaiT2bvykrQqCbb
	 SLIaXaLV/uVwh0aoQJZJVXnNVx7Wsuvms4w2pRA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0340/1611] netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
Date: Tue, 21 Jul 2026 17:07:36 +0200
Message-ID: <20260721152522.762911266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index c89efb951994a9..b9a0257fa2bef7 100644
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



