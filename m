Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3304A3A6EEE;
	Thu,  2 Jul 2026 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009610; cv=none; b=BhWSRW2lXy8m+4tjL3ty5RSJ/UWqMbSLY2kc0v7ZCKuut2ma6Ks722BUpB3dLNBoGnbNkHnIHTT135FQb4N1roNpmXo1ImhF0bvHJIfy74vhVIzWSkFHEdU1/nAFK/p93yN+lysTz4LG37BeRSX6GvvK6818ez3IgqqNHPF2mkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009610; c=relaxed/simple;
	bh=Nc7zzFM/TEIN6cawa4zGg/DfDNp9Qd05J1YrpI397nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVhY/kHUJ7ExeR2DM8art1irdF3qzWiFl2K5vwdSh0HL6en63ywJDFBHpM8wo9c68y513MLhotFxO3HdGk2FhLQiCGjzdTE7LEvmX2EwpXvmcRkBnH7uMp2B0dJfq0lfUy3wMkZW3a74czngc7QDdc+K4eTyEsXKL0fk8/z4F5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZsUgdKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZsUgdKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C57B1F00A3A;
	Thu,  2 Jul 2026 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009607;
	bh=WQ0SYUqBFndWanls7ZOwx000LXERYyDz9FwW6XnQON4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZsUgdKcWheFmE5ep4J+MJ22hItG5AMmZ21aJ8Ne0qMvhAXiKEIBIpAmM1Bv8s4BJ
	 1sLSRFZ0f4fnmkYAdv+PIeIe12hGJN4JqIkF3JKQSqhXkuYcRYNoNIMBPlLHqq7QZb
	 kNCoPsvcVGIgsl7Qta06EbeQEmn9/k8Yzm9lQW+g=
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
Subject: [PATCH 5.15 02/95] net/sched: act_pedit: check static offsets a priori
Date: Thu,  2 Jul 2026 18:19:05 +0200
Message-ID: <20260702155109.253649271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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
index d800e0285d5c25..999ac09e33d5dc 100644
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



