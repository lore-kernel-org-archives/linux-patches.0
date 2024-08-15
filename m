Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D50F38DC8;
	Thu, 15 Aug 2024 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731284; cv=none; b=YwQ9SwpDpbqtzp7JqD+oE36MA6iqRRivYodWeRdvfGnZTflnMlL8+aSQvQeng3gHvmPC72cRv0Fl21+60nI2jonq/f38j5vvdQjnCADpaXezfePFj6ngYwQ/NLdg4fI0N0XsrNL8TzUf/z+ZwCjU1Vo4BahZeq4X0QL9jOAJ14A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731284; c=relaxed/simple;
	bh=NaAif0dNY/dvgZfHFeeasHyuiWBrs9QFDZtRdTIJ76I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwHO+FGOPNAiCDpSA/iw7P4mP1h8cHOcZQ3hzcL42rE6WXYnE8MdMS+JpR1t4S3S+IRHLWPRs4O5lEluOtW4Yp5Xlj5yqRCT5SrLcrEGFHwDyBYBjJkgQf0CFZ3o/+B1XTgM1lLD8PGEm7yjC52pz0iEvOCsbuaXGFbRdqn6+Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdJbglQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdJbglQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57CBC4AF0A;
	Thu, 15 Aug 2024 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731284;
	bh=NaAif0dNY/dvgZfHFeeasHyuiWBrs9QFDZtRdTIJ76I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdJbglQsvdIVsOlxAMi7cEc47uBm7OdSY0SlyhVBD/DwmOBVr+YP/cSiPGm2smGFA
	 33p0kD/MygNbZEA+DzQw/7Wdul8B6tqM0oR94dgwTfpKQymQ7Xcnlm8Z1RkEpaU74t
	 /hiZSTPWI/xShfCR0nORSj2w5uDdQbjr8flCKS1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/259] netfilter: ctnetlink: use helper function to calculate expect ID
Date: Thu, 15 Aug 2024 15:23:33 +0200
Message-ID: <20240815131905.892577696@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 45d02185f4b92..c1401193a971b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3129,7 +3129,8 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 
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



