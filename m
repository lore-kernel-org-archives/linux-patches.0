Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F46613EFF4;
	Tue, 27 Feb 2024 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043873; cv=none; b=t3FYbYAcv7w/xELYFjYktkHaWpdYmackr2gUZIf+owJKRPcdJE0p2IFZJUs8QbNo0B33+ZidX6jerYjkaYdQrpei6MhOsCzoeWbAh1BIUqdHY/qki5VDszJSytILZzK3JR2z5CZuDF8VmEqAeBAZYXPD+KfMWfVhnAiWJf0j3N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043873; c=relaxed/simple;
	bh=oV9aRpHn8ZgjD2JjVolkA4Hj4lDn+ll6oIVuIG467pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pkq+F0p/8spJvf1hksRTx0UpB9IqTiteBZW6EOCqSPWlogDIiPHkpelI7hIz00vFH49LQjEZnKkCv17Wmd+AxE4L4T+26jTlwHPB+OevUdCfvO8LrTnewkiMLtfzX7roGsPY011go3JA2Hd1p6Sio49gejsABs7nDv7UgIt+Blc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgmYrlgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgmYrlgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D5AC433C7;
	Tue, 27 Feb 2024 14:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043873;
	bh=oV9aRpHn8ZgjD2JjVolkA4Hj4lDn+ll6oIVuIG467pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgmYrlgzkmECtXgs7yHPwVWBkoNoa7KCgoGSp4lBRwylCTPva7ahmfIUgaqay0Aqm
	 or7id0XZXtBbACQ+gbs5qKrJdLT9M4xd9iGaKengHSsxuoHth3o7kpsKCdEY2HG0oF
	 fdr7sZOQyvILX6LpZTCnJ6qTtTpOrvd5Y98iCXYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 65/84] RDMA/srpt: Make debug output more detailed
Date: Tue, 27 Feb 2024 14:27:32 +0100
Message-ID: <20240227131554.987927116@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d4ee7f3a4445ec1b0b88af216f4032c4d30abf5a ]

Since the session name by itself is not sufficient to uniquely identify a
queue pair, include the queue pair number. Show the ASCII channel state
name instead of the numeric value. This change makes the ib_srpt debug
output more consistent.

Link: https://lore.kernel.org/r/20200525172212.14413-3-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Stable-dep-of: eb5c7465c324 ("RDMA/srpt: fix function pointer cast warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2822ca5e82779..ccd9811c6c1e2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -217,8 +217,9 @@ static const char *get_ch_state_name(enum rdma_ch_state s)
  */
 static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 {
-	pr_debug("QP event %d on ch=%p sess_name=%s state=%d\n",
-		 event->event, ch, ch->sess_name, ch->state);
+	pr_debug("QP event %d on ch=%p sess_name=%s-%d state=%s\n",
+		 event->event, ch, ch->sess_name, ch->qp->qp_num,
+		 get_ch_state_name(ch->state));
 
 	switch (event->event) {
 	case IB_EVENT_COMM_EST:
@@ -2005,8 +2006,8 @@ static void __srpt_close_all_ch(struct srpt_port *sport)
 	list_for_each_entry(nexus, &sport->nexus_list, entry) {
 		list_for_each_entry(ch, &nexus->ch_list, list) {
 			if (srpt_disconnect_ch(ch) >= 0)
-				pr_info("Closing channel %s because target %s_%d has been disabled\n",
-					ch->sess_name,
+				pr_info("Closing channel %s-%d because target %s_%d has been disabled\n",
+					ch->sess_name, ch->qp->qp_num,
 					dev_name(&sport->sdev->device->dev),
 					sport->port);
 			srpt_close_ch(ch);
-- 
2.43.0



