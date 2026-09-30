Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1DD3CAA41;
	Wed, 30 Sep 2026 19:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794953; cv=none; b=UTkmjIagixSrW+NRju3EM2Flk77kbbkPm+7ZeyMHewk2BtcOP32q6HZTNbOdpRPcg9AyR1C269uN2LIz6PUW9oBATQWZlJQmfm2ZI+DxyKD7ufbJjyiEiqL7Bz00a5ekpxk7hpeTp/QQhoGrDEh69OQn3KJ5kzix/AW8kU4rvOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794953; c=relaxed/simple;
	bh=qVFnwwhPEbQgQREjtfad+tcD1ZcCV7rjAbjJ0QuY76E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9KdqrbCTlW9/jWUUdMJM7TeJk1tnst3NvYE0UrM7DGoPxshsVxQJEuxvdpzbuCBwgldoZcUrMp53nLw5i3XfoVDBoxAjIpd7GJw5LzgUzHiwNqcvXCD8GqZPsYw5qa4Iw14g71Ew/S5wpehMpDGKrVfhgX178AmgfE5PG2UssQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0b4Ps8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0b4Ps8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A653F1F000FF;
	Wed, 30 Sep 2026 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794952;
	bh=cE1S/O2oMIimxCjpVRCwAytEG7eP8cC6byaBw5bq2mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0b4Ps8+792ChJPX6jPyP0Pzup9F3U8qxqpyXqAlepJ0Uv0JPH9y2XiwcERll7YQG
	 T7fJIw8h2w/0UrNzTFUTNRdKzvUPqzsTErC06xgm0VdF7tikXaaLqbEX+4AYNxLpXM
	 mfztaaWFo5oiXfoUAefUfgO4mNg5ZN37Lah5qUJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0391/1193] net/sched: act_api: dont open code max()
Date: Wed, 30 Sep 2026 17:17:55 +0200
Message-ID: <20260930152442.875743932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit c73724bfde0932cb0cafff2855e8ce81e12fd594 ]

Use max() in a couple of places that are open coding it with the
ternary operator.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20231208192847.714940-5-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 251367a0a331 ("net/sched: act_api: fix skb sizing and action leak on reoffload delete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 10a3364885559..59b86962f000a 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1842,8 +1842,7 @@ tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
 	struct sk_buff *skb;
 	int ret;
 
-	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
-			GFP_KERNEL);
+	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
 
@@ -1928,8 +1927,7 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 	int ret;
 	struct sk_buff *skb;
 
-	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
-			GFP_KERNEL);
+	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
 
@@ -2008,8 +2006,7 @@ tcf_add_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
-			GFP_KERNEL);
+	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
 
-- 
2.53.0



