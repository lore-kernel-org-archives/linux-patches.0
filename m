Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444AF2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB77C433EF;
	Tue, 18 Apr 2023 12:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821035;
	bh=6XhEvYrJCTz1ciT2/7zgYjLxhKowSkg9Bsv+rqrzEZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItxwECczqvX3kxR3ZB+sMywC/1vKtQqf1xVdvfkzIBw8YrRT6uDcC1kTwjUpHrOlg
	 58HtvHz5lm3ceiIV8CDz7ZwZQtn/nHFJjng3zco83+l/oXqhbL30ImswLIJRfHNt/E
	 /5oCNRW7C0iCrKV6u005MDTbqM2gSFMZTo3//Q/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH 5.4 37/92] net_sched: prevent NULL dereference if default qdisc setup failed
Date: Tue, 18 Apr 2023 14:21:12 +0200
Message-Id: <20230418120306.139900500@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pratyush Yadav <ptyadav@amazon.de>

If qdisc_create_dflt() fails, it returns NULL. With CONFIG_NET_SCHED
enabled, the check qdisc != &noop_qdisc passes and qdisc will be passed
to qdisc_hash_add(), which dereferences it.

This assignment was present in the upstream commit 5891cd5ec46c2
("net_sched: add __rcu annotation to netdev->qdisc") but was missed in
the backport 22d95b5449249 ("net_sched: add __rcu annotation to
netdev->qdisc"), perhaps due to merge conflicts.  dev->qdisc is
&noop_qdisc by default and if qdisc_create_dflt() fails, this assignment
will make sure qdisc == &noop_qdisc and no NULL dereference will take
place.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 22d95b5449249 ("net_sched: add __rcu annotation to netdev->qdisc")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_generic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1116,6 +1116,7 @@ static void attach_default_qdiscs(struct
 			qdisc->ops->attach(qdisc);
 		}
 	}
+	qdisc = rtnl_dereference(dev->qdisc);
 
 #ifdef CONFIG_NET_SCHED
 	if (qdisc != &noop_qdisc)


