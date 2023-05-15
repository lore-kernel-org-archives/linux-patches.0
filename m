Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6E3FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871D1C433EF;
	Mon, 15 May 2023 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169386;
	bh=vNu5/Ha+wdbcfN9nLgGOHdPhDJYDG3KZ19kvAPi4csw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRfVZP2N+e6hxXUXd9+hP9HmbO8T6ybdWgW0+ZTEjEHpumxJ0Bm52Ae8o9gdjqNZy
	 C/5kqqrJVth7Kz/bmY0LDpxWucpgMetFkExdNZZPNMRJj/DthvdjHRXzQ80ZPNiDsk
	 A5ma80aJXOqps3lFepdZNNSluGBunFHgPOA7oAM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 023/246] net/sched: flower: Fix wrong handle assignment during filter change
Date: Mon, 15 May 2023 18:23:55 +0200
Message-Id: <20230515161723.304815375@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 32eff6bacec2cb574677c15378169a9fa30043ef ]

Commit 08a0063df3ae ("net/sched: flower: Move filter handle initialization
earlier") moved filter handle initialization but an assignment of
the handle to fnew->handle is done regardless of fold value. This is wrong
because if fold != NULL (so fold->handle == handle) no new handle is
allocated and passed handle is assigned to fnew->handle. Then if any
subsequent action in fl_change() fails then the handle value is
removed from IDR that is incorrect as we will have still valid old filter
instance with handle that is not present in IDR.
Fix this issue by moving the assignment so it is done only when passed
fold == NULL.

Prior the patch:
[root@machine tc-testing]# ./tdc.py -d enp1s0f0np0 -e 14be
Test 14be: Concurrently replace same range of 100k flower filters from 10 tc instances
exit: 123
exit: 0
RTNETLINK answers: Invalid argument
We have an error talking to the kernel
Command failed tmp/replace_6:1885

All test results:

1..1
not ok 1 14be - Concurrently replace same range of 100k flower filters from 10 tc instances
        Command exited with 123, expected 0
RTNETLINK answers: Invalid argument
We have an error talking to the kernel
Command failed tmp/replace_6:1885

After the patch:
[root@machine tc-testing]# ./tdc.py -d enp1s0f0np0 -e 14be
Test 14be: Concurrently replace same range of 100k flower filters from 10 tc instances

All test results:

1..1
ok 1 14be - Concurrently replace same range of 100k flower filters from 10 tc instances

Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230425140604.169881-1-ivecera@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 475fe222a8556..fa6c2bb0b6267 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2231,8 +2231,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 			kfree(fnew);
 			goto errout_tb;
 		}
+		fnew->handle = handle;
 	}
-	fnew->handle = handle;
 
 	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
 			       !tc_skip_hw(fnew->flags));
-- 
2.39.2



