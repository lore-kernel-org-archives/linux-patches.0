Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5E98BE5
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69B2C433C0;
	Mon, 19 Jun 2023 10:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171798;
	bh=4hFPkMwLMS+CCfxOLCvle9E8immgMl2eTXItmkHxd6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1B3Aum1s5jCRZGEdV7WnTfoSHr9hWnAvpMiHxuy/5Fb5mc2WM0mHNN9Rnu+6yYhe
	 h3cRBg6uwxcUUya8Tt1SGdykkv54hrjRDGBVbg//MC4ltbnOxrt5f9sFlzALGrHr0s
	 WyZ+s63EXNWy19HwXEVI2ANQUaI16O3GP/n2DrQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 160/166] net/sched: act_api: add specific EXT_WARN_MSG for tc action
Date: Mon, 19 Jun 2023 12:30:37 +0200
Message-ID: <20230619102202.450369193@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

commit 2f59823fe696caa844249a90bb3f9aeda69cfe5c upstream.

In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
to report tc extact message") I didn't notice the tc action use different
enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.
Let's add a TCA_ROOT_EXT_WARN_MSG for tc action specifically and put this
param before going to the TCA_ACT_TAB nest.

Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc extact message")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/rtnetlink.h |    1 +
 net/sched/act_api.c            |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -789,6 +789,7 @@ enum {
 	TCA_ROOT_FLAGS,
 	TCA_ROOT_COUNT,
 	TCA_ROOT_TIME_DELTA, /* in msecs */
+	TCA_ROOT_EXT_WARN_MSG,
 	__TCA_ROOT_MAX,
 #define	TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
 };
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1596,6 +1596,10 @@ static int tca_get_fill(struct sk_buff *
 	t->tca__pad1 = 0;
 	t->tca__pad2 = 0;
 
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_ROOT_EXT_WARN_MSG, extack->_msg))
+		goto out_nlmsg_trim;
+
 	nest = nla_nest_start_noflag(skb, TCA_ACT_TAB);
 	if (!nest)
 		goto out_nlmsg_trim;
@@ -1605,10 +1609,6 @@ static int tca_get_fill(struct sk_buff *
 
 	nla_nest_end(skb, nest);
 
-	if (extack && extack->_msg &&
-	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
-		goto out_nlmsg_trim;
-
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 
 	return skb->len;


