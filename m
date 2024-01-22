Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0816E64AA7;
	Tue, 23 Jan 2024 01:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975043; cv=none; b=FhdjCMKXIv8Ti0uOfTZh79FUVp4m1obYD3F/Cr/oV5QfSzB+8jDYKSPkkRdjMfLakqSN9zwMmYkadXwnQ28eEwkfkSSAbuoZ8z2Pvl9naBnxwXuHZvh4Zqv+EB9aTeoTmoFhmH7iJSnsoy4jss9frL9M/DEfG9KDdmJ7NQhwqMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975043; c=relaxed/simple;
	bh=AKsQkva4vtMizkjBNfidLgsJ/aXHreAzaOCuaVqFLYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/22umBPms4ZK7oOSJUj7XeQQEtsfeaZh4ou/Z4uGeyRZ7/JHcTqgH4MxcsxX487Lq3WXZfapRM/3yfRxmh0sgpwbm6mnJwHmeQYj0GeTLgyRGtYWuPHS6rJdbo2PGMUGISAzJ8vQ6ekLF37DJpdLzW+udxsneV0NWphI+EioTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vER1odGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vER1odGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64627C43394;
	Tue, 23 Jan 2024 01:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975042;
	bh=AKsQkva4vtMizkjBNfidLgsJ/aXHreAzaOCuaVqFLYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vER1odGnNCJ++HCfCf5MS4fWbSNJ4D8I6jVRH14MWRO65v3WxqFIiWRws//w6A05k
	 VaDzKQWss02s7yURsq/6mXpGB9YCZPHfDd1r0DOaSjau2yD2/wkXaDWXZhwmSGcexe
	 F58QxkfqVO9gXBUcYK3NZH6aMGamii/fkIVNS5Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Peter Krystad <peter.krystad@linux.intel.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang.tang@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/374] mptcp: strict validation before using mp_opt->hmac
Date: Mon, 22 Jan 2024 15:59:53 -0800
Message-ID: <20240122235756.626833744@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c1665273bdc7c201766c65e561c06711f2e050dc ]

mp_opt->hmac contains uninitialized data unless OPTION_MPTCP_MPJ_ACK
was set in mptcp_parse_option().

We must refine the condition before we call subflow_hmac_valid().

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Peter Krystad <peter.krystad@linux.intel.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Mat Martineau <martineau@kernel.org>
Cc: Geliang Tang <geliang.tang@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20240111194917.4044654-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a1349c6eda46..c2c30724b322 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -698,7 +698,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			fallback = true;
 	} else if (subflow_req->mp_join) {
 		mptcp_get_options(skb, &mp_opt);
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ) ||
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPJ_ACK) ||
 		    !subflow_hmac_valid(req, &mp_opt) ||
 		    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
-- 
2.43.0



