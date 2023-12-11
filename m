Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD1C5102A;
	Mon, 11 Dec 2023 18:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1S6R9EnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD10C433C7;
	Mon, 11 Dec 2023 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320463;
	bh=q0BSCiMJI4yziYsWPKcmOj/qtE4xuYpJisJqZ3W9Zts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1S6R9EnZ6dKyeJ8zgFUibJ/gj20KC9Iqggy6tBenMa05G1q9rj07z2cyxKQJ5kgXv
	 au/f7Tm7XaF0ProblqSR/HriP2Zet4HP0hOJlvf68i7g+0jSsFgoDoPRsDGsivlA9z
	 B+H7geojYR6lr/nB2+EL8RKYfINLvU7WN1okrB10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/194] RDMA/rtrs-srv: Do not unconditionally enable irq
Date: Mon, 11 Dec 2023 19:21:00 +0100
Message-ID: <20231211182039.613777483@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 3ee7ecd712048ade6482bea4b2f3dcaf039c0348 ]

When IO is completed, rtrs can be called in softirq context,
unconditionally enabling irq could cause panic.

To be on safe side, use spin_lock_irqsave and spin_unlock_irqrestore
instread.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://lore.kernel.org/r/20231120154146.920486-2-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 22d7ba05e9fe8..e26488ee36eac 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -63,8 +63,9 @@ static bool rtrs_srv_change_state(struct rtrs_srv_path *srv_path,
 {
 	enum rtrs_srv_state old_state;
 	bool changed = false;
+	unsigned long flags;
 
-	spin_lock_irq(&srv_path->state_lock);
+	spin_lock_irqsave(&srv_path->state_lock, flags);
 	old_state = srv_path->state;
 	switch (new_state) {
 	case RTRS_SRV_CONNECTED:
@@ -85,7 +86,7 @@ static bool rtrs_srv_change_state(struct rtrs_srv_path *srv_path,
 	}
 	if (changed)
 		srv_path->state = new_state;
-	spin_unlock_irq(&srv_path->state_lock);
+	spin_unlock_irqrestore(&srv_path->state_lock, flags);
 
 	return changed;
 }
-- 
2.42.0



