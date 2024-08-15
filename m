Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAA663D5;
	Thu, 15 Aug 2024 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732224; cv=none; b=dHjJq7biaPQbXWd0xvLWg9pVs74gMiuupZxe+oI0cV+vTX/aMaNqSTXPaIEO8xP5xSkl6gophqRueKBcJz7c+TKV8XGf7shME76WIOEsn/CSxLHQG58Mf5tkhtWOj2I1egdfFUltq1pQX7f9QO8Zrg1oXmMLpF+OWGr2va9kGVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732224; c=relaxed/simple;
	bh=Z41+D0Jcw97LaYghP0PkqA/QuaQ++z5ketTYON2lmJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBSCCA1Y5KNf2JY/DgEVrahWefYb+kmN00l5eB8KRGaQaGZX3+Nlt+X87aPa69opfLNIhd70p9E8/OjOl9hnOTBd2jRak8tCZ7R2Mv5F0I7zPEJG1RsNu+kzhpOSKXezG8TwfhajjP0GkVDCcYLHn8t5U2cEBKO2X0EWIdQb3KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVBpvEmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVBpvEmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F422C32786;
	Thu, 15 Aug 2024 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732223;
	bh=Z41+D0Jcw97LaYghP0PkqA/QuaQ++z5ketTYON2lmJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVBpvEmJZSaPAWaa7TVc01GEPMxvySUPZlOiRHrp6WEX4hyzdWnuBHhSP/83wB9T1
	 MacseBCwlomLs66P5m6hqTzZDNBEPaAUh0BypOPphnOXP5zCPX/8flRi9HsYlK2ST4
	 qdMCoJNwPkEuYPI0C3etmtEvq0DzI9lKGEWNuXFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/352] netfilter: ctnetlink: use helper function to calculate expect ID
Date: Thu, 15 Aug 2024 15:22:57 +0200
Message-ID: <20240815131923.546294483@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 782161895eb4ac45cf7cfa8db375bd4766cb8299 ]

Delete expectation path is missing a call to the nf_expect_get_id()
helper function to calculate the expectation ID, otherwise LSB of the
expectation object address is leaked to userspace.

Fixes: 3c79107631db ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ceb7c988edefa..b55e87143c2ce 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3413,7 +3413,8 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 
 		if (cda[CTA_EXPECT_ID]) {
 			__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
-			if (ntohl(id) != (u32)(unsigned long)exp) {
+
+			if (id != nf_expect_get_id(exp)) {
 				nf_ct_expect_put(exp);
 				return -ENOENT;
 			}
-- 
2.43.0



