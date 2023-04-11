Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4B88C0D
	for <patches@lists.linux.dev>; Tue, 11 Apr 2023 13:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE91C433D2;
	Tue, 11 Apr 2023 13:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681218859;
	bh=V8y7TDfoJsub/u3pKi3iHbI8y82FeVGHzF3TsUjTMVQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=QFnh905y8OMnTj+vqpm1Rwc9/BjOqI2mGzPjDy31xKsujcNKkcuJ3OPCK3dmnW2Fv
	 BRw35ysREcxtIF7Y8+1NCETIUhVNn6pMjQ6pYWHkknAN6H+9K/NzzSuMoBorR1x/c6
	 LL6NZT8VjWSMtRGHElr4J7emYxHHAXESl2TPbhdw=
Subject: Patch "net_sched: prevent NULL dereference if default qdisc setup failed" has been added to the 5.4-stable tree
To: davem@davemloft.net,edumazet@google.com,gregkh@linuxfoundation.org,jhs@mojatatu.com,jiri@resnulli.us,nmanthey@amazon.de,patches@lists.linux.dev,ptyadav@amazon.de,syzkaller@googlegroups.com,vladbu@mellanox.com,xiyou.wangcong@gmail.com,zsm@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 11 Apr 2023 15:14:16 +0200
In-Reply-To: <20230411130210.113555-1-ptyadav@amazon.de>
Message-ID: <2023041116-sessions-storable-e8dd@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    net_sched: prevent NULL dereference if default qdisc setup failed

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     net_sched-prevent-null-dereference-if-default-qdisc-setup-failed.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From ptyadav@amazon.de  Tue Apr 11 15:12:32 2023
From: Pratyush Yadav <ptyadav@amazon.de>
Date: Tue, 11 Apr 2023 15:02:10 +0200
Subject: net_sched: prevent NULL dereference if default qdisc setup failed
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>, <stable@vger.kernel.org>, <patches@lists.linux.dev>, Eric Dumazet <edumazet@google.com>, Vlad Buslov <vladbu@mellanox.com>, syzbot <syzkaller@googlegroups.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Zubin Mithra <zsm@google.com>, Norbert Manthey <nmanthey@amazon.de>
Message-ID: <20230411130210.113555-1-ptyadav@amazon.de>

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


Patches currently in stable-queue which might be from ptyadav@amazon.de are

queue-5.4/net_sched-prevent-null-dereference-if-default-qdisc-setup-failed.patch
queue-5.4/smb3-fix-problem-with-null-cifs-super-block-with-previous-patch.patch
