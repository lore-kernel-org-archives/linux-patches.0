Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0171B15A5
	for <patches@lists.linux.dev>; Tue, 11 Apr 2023 13:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1681218147; x=1712754147;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F6afHIhDjsEA9/+NgDws+ajjyJCaWOzln2n2exsbkNQ=;
  b=NXjHuzgXzW+5xLYAebTYuZUJY0W0uxJSC9jDUNWsRq+Gd5RXztZu1qf6
   xt8Hxx0+MPJtCdUMGIeBHCVbuiRkJ0B8Z+D/ZW5lt2dkPPb8SKcciVWQ5
   vQ6Qe1ITsS+GQc3MYgmmM2vHrFuxNmMuVdse2B8E4/TyIaOZXOwCSDVe9
   I=;
X-IronPort-AV: E=Sophos;i="5.98,336,1673913600"; 
   d="scan'208";a="319085699"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 13:02:18 +0000
Received: from EX19D002EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com (Postfix) with ESMTPS id EA93340D72;
	Tue, 11 Apr 2023 13:02:16 +0000 (UTC)
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D002EUA003.ant.amazon.com (10.252.50.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 11 Apr 2023 13:02:15 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 11 Apr 2023 13:02:15 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
	id 1AC3922B50; Tue, 11 Apr 2023 15:02:14 +0200 (CEST)
From: Pratyush Yadav <ptyadav@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pratyush Yadav <ptyadav@amazon.de>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, Eric Dumazet <edumazet@google.com>, Vlad Buslov
	<vladbu@mellanox.com>, syzbot <syzkaller@googlegroups.com>, Jamal Hadi Salim
	<jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
	<jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Zubin Mithra
	<zsm@google.com>, Norbert Manthey <nmanthey@amazon.de>
Subject: [PATCH 5.4] net_sched: prevent NULL dereference if default qdisc setup failed
Date: Tue, 11 Apr 2023 15:02:10 +0200
Message-ID: <20230411130210.113555-1-ptyadav@amazon.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

If qdisc_create_dflt() fails, it returns NULL. With CONFIG_NET_SCHED
enabled, the check qdisc != &noop_qdisc passes and qdisc will be passed
to qdisc_hash_add(), which dereferences it.

This assignment was present in the upstream commit
5891cd5ec46c2 ("net_sched: add __rcu annotation to netdev->qdisc") but
was missed in the backport 22d95b5449249 ("net_sched: add __rcu
annotation to netdev->qdisc"), perhaps due to merge conflicts.
dev->qdisc is &noop_qdisc by default and if qdisc_create_dflt() fails,
this assignment will make sure qdisc == &noop_qdisc and no NULL
dereference will take place.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 22d95b5449249 ("net_sched: add __rcu annotation to netdev->qdisc")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---

As usual, this was found by our static code analysis bot. I have
compile-tested this patch and ran a simple boot test. Did not do any
testing specifically to hit this bug.

 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 1f055c21be4cf..4250f3cf30e72 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1116,6 +1116,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 			qdisc->ops->attach(qdisc);
 		}
 	}
+	qdisc = rtnl_dereference(dev->qdisc);

 #ifdef CONFIG_NET_SCHED
 	if (qdisc != &noop_qdisc)
--
2.39.2

