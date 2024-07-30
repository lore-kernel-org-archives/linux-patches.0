Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4655C1917D9;
	Tue, 30 Jul 2024 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359375; cv=none; b=sX/CU+zDw/rr/Nxhn5sjXXgLlzivw1Xy/ek1TSmKyoQyFyvshy0Qw5AYRhKozKlRP65ZmWqkKMvvdn7FboSbWHsCwsNTivuVsj7y7276PTY9yy8/AOsozNeljxYBrsA84HHpL5m/x9v2yjePS4/vCbXTlAroCUNhfSLNJhFepN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359375; c=relaxed/simple;
	bh=k2HhBaJUTjJM/aRn51bC1zabo1WE8YaKEcwS550rS9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9uVCl64Gk0q2YASpK3LpafPtr1ZsfsoGiOA4Bd7Mlyg5QmFAnDiYeGVA4Joc3oGxtu5srItrxgH6SCvPswAjOyiKrQ20CKQqPSv2newsm2NOd22OERXuzVIgjS/vPqh4+vzEmxL6nR3ILBN1TwMtg7HX6sIDuHY8cslhNjLSas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FtZMTpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FtZMTpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1298C32782;
	Tue, 30 Jul 2024 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359375;
	bh=k2HhBaJUTjJM/aRn51bC1zabo1WE8YaKEcwS550rS9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FtZMTpyRlEqH9TY7YWOoJ7/599/LBW9leoL6kIrr43YOjn72J+zIf1hCUDbUdk24
	 SmtCksD20khfrmKTTMGmk1D0ZYqpEqR9+xJd/fW/HU0+gMb2/zFWDOOsLDHMHR4VUt
	 q3QCTO38qbPHgeM7jWy4TGs2PlxiIeXDOrQhOrJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 475/809] netfilter: ctnetlink: use helper function to calculate expect ID
Date: Tue, 30 Jul 2024 17:45:51 +0200
Message-ID: <20240730151743.496463907@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3b846cbdc050d..4cbf71d0786b0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3420,7 +3420,8 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 
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



