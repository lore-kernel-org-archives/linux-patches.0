Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916D0323C
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE5AC433EF;
	Mon, 30 Jan 2023 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088637;
	bh=0Ff1wA/jsyyzrcmDhgicIlBx8qhymYYf+T9UwvZxt8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOOQD0uQNAkhEhRcOIcljHd2KaAjpBmNHAh79zrlml85pnbG1K8oOReUpiwwDkU3z
	 kdmgkRNXwdXi7Y+z6Uyxq1j/Rt3dwulr7DHZjZtaREKmyjPwV2xgw66bcPK8JRrsgv
	 s88oFxWq2FUQfZUJv6z0ATRaZ+1jYu5FRVLL2pjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/143] w1: fix WARNING after calling w1_process()
Date: Mon, 30 Jan 2023 14:51:53 +0100
Message-Id: <20230130134309.185051367@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 36225a7c72e9e3e1ce4001b6ce72849f5c9a2d3b ]

I got the following WARNING message while removing driver(ds2482):

------------[ cut here ]------------
do not call blocking ops when !TASK_RUNNING; state=1 set at [<000000002d50bfb6>] w1_process+0x9e/0x1d0 [wire]
WARNING: CPU: 0 PID: 262 at kernel/sched/core.c:9817 __might_sleep+0x98/0xa0
CPU: 0 PID: 262 Comm: w1_bus_master1 Tainted: G                 N 6.1.0-rc3+ #307
RIP: 0010:__might_sleep+0x98/0xa0
Call Trace:
 exit_signals+0x6c/0x550
 do_exit+0x2b4/0x17e0
 kthread_exit+0x52/0x60
 kthread+0x16d/0x1e0
 ret_from_fork+0x1f/0x30

The state of task is set to TASK_INTERRUPTIBLE in loop in w1_process(),
set it to TASK_RUNNING when it breaks out of the loop to avoid the
warning.

Fixes: 3c52e4e62789 ("W1: w1_process, block or sleep")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221205101558.3599162-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/w1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 6e9f3569971d..15842377c8d2 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1160,8 +1160,10 @@ int w1_process(void *data)
 		 */
 		mutex_unlock(&dev->list_mutex);
 
-		if (kthread_should_stop())
+		if (kthread_should_stop()) {
+			__set_current_state(TASK_RUNNING);
 			break;
+		}
 
 		/* Only sleep when the search is active. */
 		if (dev->search_count) {
-- 
2.39.0



