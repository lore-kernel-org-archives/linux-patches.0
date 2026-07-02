Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD51D33EB0E;
	Thu,  2 Jul 2026 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009834; cv=none; b=qozV5tX6TNb58MhQUr6inW0ThiEsllVJqOn2F5jZT9NZDlrBqBZg33lEglV0vXPSLLsrBTn54GQJvS4NrRVLNoqqmlqhqGnRJi+zx5IE5d7PXFTmq2X7UrSawnacePzrgbob5WzB18M8iT3ksCDMc7Y7AQyYXELwQZmHdJovlAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009834; c=relaxed/simple;
	bh=7krVGSIF1fnJFkypoI5/N4d47efxIucJqgbCoxyXqN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftQ0VbPbJch85FGy0VKxQggZuzQ1rvxH40jUbUWM6t2zvLchUU+iV5zXo6toQXKxyd0/JM0PRdnPMpSTnUR/MKLa6QOkpE1qHvxYWhRmgVEif+2a5jpsOdPq3fLtiik+/vlJvHG7XrNwpNs79RUAjymN2bFiqXmHFK6wMrT7P0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGmsO/Lc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGmsO/Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE11F000E9;
	Thu,  2 Jul 2026 16:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009833;
	bh=CSiY0ZFgCpxo9FPeqTE5Vgv7mYVDmhW7ZkUeE9StOP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGmsO/Lci3XiY0QK5YmBzYTgtbILrG7sAGN7xO31B/2NBv/LZ8WKCZXG8ZlVg6rlJ
	 bAfAKE6Ty0HSAdTwUzUv8iWAigEkj/mwEOlvOaSoMDLteDJSsNXvRKuAf4jMxT+q1r
	 +DPosjIRPFYTC84c13NQlFHUcGIjn7NNbQ8Kz+fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/129] net/sched: act_pedit: check static offsets a priori
Date: Thu,  2 Jul 2026 18:18:41 +0200
Message-ID: <20260702155112.216006091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit e1201bc781c28766720e78a5e099ffa568be4d74 ]

Static key offsets should always be on 32 bit boundaries. Validate them on
create/update time for static offsets and move the datapath validation
for runtime offsets only.

iproute2 already errors out if a given offset and data size cannot be
packed to a 32 bit boundary. This change will make sure users which
create/update pedit instances directly via netlink also error out,
instead of finding out when packets are traversing.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit e1201bc781c28766720e78a5e099ffa568be4d74)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index aee2e13f1db624..2bdc44efee779a 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -250,8 +250,16 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	memcpy(nparms->tcfp_keys, parm->keys, ksize);
 
 	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
+		u32 offmask = nparms->tcfp_keys[i].offmask;
 		u32 cur = nparms->tcfp_keys[i].off;
 
+		/* The AT option can be added to static offsets in the datapath */
+		if (!offmask && cur % 4) {
+			NL_SET_ERR_MSG_MOD(extack, "Offsets must be on 32bit boundaries");
+			ret = -EINVAL;
+			goto put_chain;
+		}
+
 		/* sanitize the shift value for any later use */
 		nparms->tcfp_keys[i].shift = min_t(size_t,
 						   BITS_PER_TYPE(int) - 1,
@@ -260,7 +268,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		/* The AT option can read a single byte, we can bound the actual
 		 * value with uchar max.
 		 */
-		cur += (0xff & nparms->tcfp_keys[i].offmask) >> nparms->tcfp_keys[i].shift;
+		cur += (0xff & offmask) >> nparms->tcfp_keys[i].shift;
 
 		/* Each key touches 4 bytes starting from the computed offset */
 		nparms->tcfp_off_max_hint =
@@ -429,12 +437,12 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 					       sizeof(_d), &_d);
 			if (!d)
 				goto bad;
-			offset += (*d & tkey->offmask) >> tkey->shift;
-		}
 
-		if (offset % 4) {
-			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
-			goto bad;
+			offset += (*d & tkey->offmask) >> tkey->shift;
+			if (offset % 4) {
+				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+				goto bad;
+			}
 		}
 
 		if (!offset_valid(skb, hoffset + offset)) {
-- 
2.53.0



