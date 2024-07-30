Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424E014831F;
	Tue, 30 Jul 2024 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358084; cv=none; b=LyxUBgV6NjEripAzcjXKjnQPio0wS7uqA1JU3IXSL9p+AFIfM7aDKXIfeaj3QLnF0nea0qHLS4vJmnObTOgcDDRfxyE7uAmA4LWrDvy3eRc+pTB4hgl9vYbmxtCL9tV+9xS14sGVbyz96W/jyz/6fQ5za+bHf4mAALG6DIWI48s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358084; c=relaxed/simple;
	bh=V6p+vwy0m0d4qsWZv/80BksEFluv7T6j96zitC10vjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLrqYxqGcPDOMNCkC3Z2ySjSD+nC4/UqeDdkbBHIg+PncUTLy6cJWXSm0Luqr7vy2mhAX4dp2Mt2OT0p4lTlTHr1vRHrRW+UTnLerG1P0/NYPSSEsQCpjhCG598dJ+FaihotQu2exfYZ2u+NSkR3QKSWyWuRFN+31SeVqAzvCS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O52JlWPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O52JlWPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7FEC32782;
	Tue, 30 Jul 2024 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358084;
	bh=V6p+vwy0m0d4qsWZv/80BksEFluv7T6j96zitC10vjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O52JlWPXrBFHbcQ/sSjGtC4GO7VDH7owgWL9tsVxf4UpQtOkNtwFBIq+OPs3HssOj
	 opgP2Aq66u2k09Qk2PgZVl09vk1+6FKLOO6SOj6aSl8Qs06sEHVV6+RN6mgzQnhA2Z
	 Fqf9VtcXWODeR+5rdc65CAZn4fLSmhA9EwmgXkpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 309/568] netfilter: ctnetlink: use helper function to calculate expect ID
Date: Tue, 30 Jul 2024 17:46:56 +0200
Message-ID: <20240730151651.950768029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 334db22199c1d..4dab45039f349 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3411,7 +3411,8 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 
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



