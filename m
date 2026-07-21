Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21BE46C4D2;
	Tue, 21 Jul 2026 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649192; cv=none; b=GTY7nCdV8pGLPwlb0nUqal5plGiywD+Yx0Fv/wqeTM6C7uTUABG1QNtDdY/zDHoivJYIwgsAa8Lf8qVnGdwaKJ5AfIf3WeCFKjgGx3a0WOJgxUOQjlGLNNN/+Pto6bZKVCyuVYv6qpKzbssBsdbQ903lmMO6RUuE6KhY7AHH4+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649192; c=relaxed/simple;
	bh=B9TSh4BO5E1O+ip0k1JE3VsdRkinhelTH01NyGTDPAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YesXyqpNfgtN0ZVlQMPDxvH5t58sp90yqEfo0Gv0eXlG4HPzrtlg8LXE2/Fi/sr//9ANdcG0V7KG3rODE+wAphm1QFCczqcSZS9XfR0i6aHtWiB70AqFyZW7ifogndyAwBQrXExhGAO/WmRi0JnpA1SaA1TT1QgrpeXDXaDOfX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIDVFmh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIDVFmh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FEF1F00A3A;
	Tue, 21 Jul 2026 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649191;
	bh=MtLiExG0h0ZN+wVvPUFkeuqmSpOSkcXvANr/Zuhka54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIDVFmh8I/EncHlO3fi8fpyGF3RMYh5ImuS4UhLyFFiMyLCUcX9rVgH0YvYojt6jh
	 Cod1BNq+VnOzSfs/9XlEQvkuYfuWLh4yTWJl6MCgdwkxx5MRbM9Tx9Hmu6Fa0kYkt2
	 OvLMqz1/fXXM2gk8FOZ5QdIFPnpp87cGvw9IWSnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0484/2077] netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
Date: Tue, 21 Jul 2026 17:02:37 +0200
Message-ID: <20260721152604.225383185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index acb753ec5697a5..92002079f8eab6 100644
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



