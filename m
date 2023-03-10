Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF688481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4D3C433D2;
	Fri, 10 Mar 2023 14:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457299;
	bh=Wf9jryCHNH5I4bYYGDWQlk/vw2bbfB2rvLv4FkYFDcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdZFuWR+Xu4XzjzM49vGwiQ5ntlGqj7YNQ89acxral0O3BkiNUdz97Z03FcpumuqH
	 wNeJEdWe8SrtuPVADZBQFA+hIkBdd/EMPLGm65EIsWj6AHZ2TGd6XqKEWPy0/3z/Eh
	 gtQV+zq5z6CBOeGVVtA51tNgEO5StOEsbMt4jPYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/200] net/sched: act_sample: fix action bind logic
Date: Fri, 10 Mar 2023 14:38:16 +0100
Message-Id: <20230310133719.841035598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 4a20056a49a1854966562241922f68197f950539 ]

The TC architecture allows filters and actions to be created independently.
In filters the user can reference action objects using:
tc action add action sample ... index 1
tc filter add ... action pedit index 1

In the current code for act_sample this is broken as it checks netlink
attributes for create/update before actually checking if we are binding to an
existing action.

tdc results:
1..29
ok 1 9784 - Add valid sample action with mandatory arguments
ok 2 5c91 - Add valid sample action with mandatory arguments and continue control action
ok 3 334b - Add valid sample action with mandatory arguments and drop control action
ok 4 da69 - Add valid sample action with mandatory arguments and reclassify control action
ok 5 13ce - Add valid sample action with mandatory arguments and pipe control action
ok 6 1886 - Add valid sample action with mandatory arguments and jump control action
ok 7 7571 - Add sample action with invalid rate
ok 8 b6d4 - Add sample action with mandatory arguments and invalid control action
ok 9 a874 - Add invalid sample action without mandatory arguments
ok 10 ac01 - Add invalid sample action without mandatory argument rate
ok 11 4203 - Add invalid sample action without mandatory argument group
ok 12 14a7 - Add invalid sample action without mandatory argument group
ok 13 8f2e - Add valid sample action with trunc argument
ok 14 45f8 - Add sample action with maximum rate argument
ok 15 ad0c - Add sample action with maximum trunc argument
ok 16 83a9 - Add sample action with maximum group argument
ok 17 ed27 - Add sample action with invalid rate argument
ok 18 2eae - Add sample action with invalid group argument
ok 19 6ff3 - Add sample action with invalid trunc size
ok 20 2b2a - Add sample action with invalid index
ok 21 dee2 - Add sample action with maximum allowed index
ok 22 560e - Add sample action with cookie
ok 23 704a - Replace existing sample action with new rate argument
ok 24 60eb - Replace existing sample action with new group argument
ok 25 2cce - Replace existing sample action with new trunc argument
ok 26 59d1 - Replace existing sample action with new control argument
ok 27 0a6e - Replace sample action with invalid goto chain control
ok 28 3872 - Delete sample action with valid index
ok 29 a394 - Delete sample action with invalid index

Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_sample.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 7a25477f5d996..09735a33e57e2 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -54,8 +54,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 					  sample_policy, NULL);
 	if (ret < 0)
 		return ret;
-	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
-	    !tb[TCA_SAMPLE_PSAMPLE_GROUP])
+
+	if (!tb[TCA_SAMPLE_PARMS])
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
@@ -79,6 +79,13 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		tcf_idr_release(*a, bind);
 		return -EEXIST;
 	}
+
+	if (!tb[TCA_SAMPLE_RATE] || !tb[TCA_SAMPLE_PSAMPLE_GROUP]) {
+		NL_SET_ERR_MSG(extack, "sample rate and group are required");
+		err = -EINVAL;
+		goto release_idr;
+	}
+
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
-- 
2.39.2



