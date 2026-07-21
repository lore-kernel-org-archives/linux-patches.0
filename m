Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53711231829;
	Tue, 21 Jul 2026 22:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671961; cv=none; b=sXvwJB5Xkskt9f1NaiHDrEYw/RACqYECSw4/qzcJD+9wFjkBtthO7/cnH1AGuBR3V4cEA1DhVpu08pW49Mt81qiuNtj9YnvJhUigx0SLGnodSyBt6we0NX/ZtVa2t/DoXl34uayaYpP58GivAxu4RAz6Tla6kehltyLdH2lDbMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671961; c=relaxed/simple;
	bh=k+bdLWk9vRhAtfaeiMweI9LDjo0iFOkwJIQ9HZqEL0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRaYykudn3S0kfX14HVTVlwppIc0H/FQvEmObftjOuFGNBFglxrBUxYIXAc6yQ0r+JoYTmXVQKcxeDndNdVCV98rtyoTssvkcFQKqLXalw7J6GTxoo4maeZGqPVqgTzIHwqu603xtGOyiR/0MoZS3TnlAOEiedFzggWQl1DVU5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cv1uuHRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cv1uuHRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30381F000E9;
	Tue, 21 Jul 2026 22:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671960;
	bh=5rff01G8PHEOCAeJKdneCfrb19oHeY6tWoX4uLsBSGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cv1uuHRhjIBw8/uUmu797omGwqbcxCNuKbHdUfEmr3X7PawMFe2AuWZTI1xA5f1tq
	 pRe0VaEA/x9CuyC5RfR0xKfGtFC5MtCR6nyA3sLXfqCU5OCa9O/vDmxvl080pIKRuQ
	 8aXLdWJD+se9dR+Vyt+sm9BGGYWydG64wJ7r62bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 442/843] net: psample: fix info leak in PSAMPLE_ATTR_DATA
Date: Tue, 21 Jul 2026 17:21:17 +0200
Message-ID: <20260721152415.972470599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit aedd02af1f8b0bceb7f42f5a21c41634ca9ed390 ]

psample open codes nla_put() presumably to avoid wiping
the data with 0s just to override it with packet data.
This open coding is missing clearing the pad, however,
each netlink attr is padded to 4B and data_len may
not be divisible by 4B.

Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20260616003046.1099490-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psample/psample.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/psample/psample.c b/net/psample/psample.c
index f93fcebd0cf02a..4a886901e911e6 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -464,15 +464,17 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 		goto error;
 
 	if (data_len) {
-		int nla_len = nla_total_size(data_len);
+		int nla_len = nla_attr_size(data_len);
 		struct nlattr *nla;
 
 		nla = skb_put(nl_skb, nla_len);
 		nla->nla_type = PSAMPLE_ATTR_DATA;
-		nla->nla_len = nla_attr_size(data_len);
+		nla->nla_len = nla_len;
 
 		if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
 			goto error;
+
+		skb_put_zero(nl_skb, nla_padlen(data_len));
 	}
 
 #ifdef CONFIG_INET
-- 
2.53.0



