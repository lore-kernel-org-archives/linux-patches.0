Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC01D44AB60;
	Tue, 21 Jul 2026 21:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669093; cv=none; b=NcYj8TTjj2F0+jUhTIu9d9hPvur6lAdGiyKcUB/+bdEWc/qLgPCk2j6aO23x6KDSQJKDPwJAYTHJzR+r48F3RoZZKGRRqjVEjKT0NcnGAVeBWDY0z3lCLYn8OGdBJsqR2HHsjE1hBU8EOJ3H+OjGUYzRWdlYJpw7uIw4BIAmgXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669093; c=relaxed/simple;
	bh=H261A6hBbZX0BGrWIVbCVJM4z4GuldiozTKzRbBo1kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/v0PG4QuixnK9263RtIiakxMqAXovlqqHvguRKMf7ytozMnrB1z9cC/4qpdJ+xviD/ZIcBe9jqhOnVhXbNWjDlHuA4XfSfdl4BRI9Go3bRmIvf2j5k0rsR+oZZEmDX9LqJscNkYMV+Gddk8O7KcutBaE7XT0YCuELRtE4dITdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIFHusGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIFHusGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F2F1F000E9;
	Tue, 21 Jul 2026 21:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669092;
	bh=Y5YYlwrL/iadTdEb+JGY+EF0CVAqJF2IpbBbBtHEfSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIFHusGxHsc0X33g9D9wbyl8QSo+0w7OuOirOVtazWuOvdBtSM/Om2XIuxmuiP3OB
	 J9Ws4VIxwu4cSivsFbdD+cgDYytSBc2VvLOmkb1mxG7q/FcP9uvPsCvOdR8v64tqNv
	 oZ/2zAqsq/sj7Mb4kAP64FNcQyUJIlsn2Oe7lbks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0381/1067] netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
Date: Tue, 21 Jul 2026 17:16:22 +0200
Message-ID: <20260721152433.155361327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 6d3dfbeb398cb4..b61656cb0f3eb5 100644
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



