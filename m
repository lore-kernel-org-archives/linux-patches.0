Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D56E611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D4DC433EF;
	Sun, 28 May 2023 19:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301246;
	bh=SJjX2uqS/9D2+GfOT/eA9XkhtSUgjCUqjjkzu3b651Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0PWPbpyPyVGsdSEISvUHPD4QBYrVEktP6Y6a+aHibX5dOJ3CPxD8egb9cVanBtOo
	 v2hePQKLd3VXvKMVn7jbeFlZRMA3RM72k/bZkwEbICL6QqRSlbT6hoCNAZ1JPYwxhi
	 gbWx5uhWr+YsHfPa5rZTo2xr13xlUrwF6DSmwqiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Brunner <tobias@strongswan.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/86] af_key: Reject optional tunnel/BEET mode templates in outbound policies
Date: Sun, 28 May 2023 20:10:13 +0100
Message-Id: <20230528190830.049209673@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Brunner <tobias@strongswan.org>

[ Upstream commit cf3128a7aca55b2eefb68281d44749c683bdc96f ]

xfrm_state_find() uses `encap_family` of the current template with
the passed local and remote addresses to find a matching state.
If an optional tunnel or BEET mode template is skipped in a mixed-family
scenario, there could be a mismatch causing an out-of-bounds read as
the addresses were not replaced to match the family of the next template.

While there are theoretical use cases for optional templates in outbound
policies, the only practical one is to skip IPComp states in inbound
policies if uncompressed packets are received that are handled by an
implicitly created IPIP state instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Tobias Brunner <tobias@strongswan.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 09a0ea651f577..49813e6d05ed7 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1950,7 +1950,8 @@ static u32 gen_reqid(struct net *net)
 }
 
 static int
-parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_ipsecrequest *rq)
+parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_policy *pol,
+		   struct sadb_x_ipsecrequest *rq)
 {
 	struct net *net = xp_net(xp);
 	struct xfrm_tmpl *t = xp->xfrm_vec + xp->xfrm_nr;
@@ -1968,9 +1969,12 @@ parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_ipsecrequest *rq)
 	if ((mode = pfkey_mode_to_xfrm(rq->sadb_x_ipsecrequest_mode)) < 0)
 		return -EINVAL;
 	t->mode = mode;
-	if (rq->sadb_x_ipsecrequest_level == IPSEC_LEVEL_USE)
+	if (rq->sadb_x_ipsecrequest_level == IPSEC_LEVEL_USE) {
+		if ((mode == XFRM_MODE_TUNNEL || mode == XFRM_MODE_BEET) &&
+		    pol->sadb_x_policy_dir == IPSEC_DIR_OUTBOUND)
+			return -EINVAL;
 		t->optional = 1;
-	else if (rq->sadb_x_ipsecrequest_level == IPSEC_LEVEL_UNIQUE) {
+	} else if (rq->sadb_x_ipsecrequest_level == IPSEC_LEVEL_UNIQUE) {
 		t->reqid = rq->sadb_x_ipsecrequest_reqid;
 		if (t->reqid > IPSEC_MANUAL_REQID_MAX)
 			t->reqid = 0;
@@ -2012,7 +2016,7 @@ parse_ipsecrequests(struct xfrm_policy *xp, struct sadb_x_policy *pol)
 		    rq->sadb_x_ipsecrequest_len < sizeof(*rq))
 			return -EINVAL;
 
-		if ((err = parse_ipsecrequest(xp, rq)) < 0)
+		if ((err = parse_ipsecrequest(xp, pol, rq)) < 0)
 			return err;
 		len -= rq->sadb_x_ipsecrequest_len;
 		rq = (void*)((u8*)rq + rq->sadb_x_ipsecrequest_len);
-- 
2.39.2



