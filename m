Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B561B94E;
	Sat,  3 Feb 2024 04:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933730; cv=none; b=jDgfP5hSxzfN+IMYc7EmpLKZSoPdvHXc8GgRfGe0H+n3WbBHTWOjddF7xPVgqY4DhjFoYv/E/iCANzSIvQovqDspXkF30Y8cm+58W9AZoXAPr7f/cKHLTHUEf2K71OEy+dod40ZVCy8I0Zcb0KjP/sYJWisihQHEudcMVsryP64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933730; c=relaxed/simple;
	bh=9d6vwmYG47JD5iQTiTMV+9vCFcKpEebEp6RTxSUnIS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7sDw7LOL2DsM5o088/gHLKxfW7oWqh9o0BijDrAjQgsj2O6qJm/PwynEJgai8CeKWZckGr7JN4dJfTaZJos+KT8hPs/Fl2jOkktyhi/OBPlngSfsK+Skciyl3Pwa7e0AwD/kGpY3K/q2PYJquXFZss8CWQ51eZEH0ci6IJIy3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0z27kpUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0z27kpUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CB8C433F1;
	Sat,  3 Feb 2024 04:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933730;
	bh=9d6vwmYG47JD5iQTiTMV+9vCFcKpEebEp6RTxSUnIS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0z27kpUg4zjl7LjhPc/RJoCEHXUMbpkeBVkez7LMw8KQdzgO23/BItilkSe4eQGr9
	 XzFuSOFz3c97kW/aIdydtJvsEee70fBxFULjmGy7zTW0/eqCmRx2PDh76pett+58JK
	 4VqRasjIZaBswJ765O8Y4BySjVjgURDEimqh+X50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Riches <chris.riches@nutanix.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 017/353] audit: Send netlink ACK before setting connection in auditd_set
Date: Fri,  2 Feb 2024 20:02:15 -0800
Message-ID: <20240203035404.291916918@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Riches <chris.riches@nutanix.com>

[ Upstream commit 022732e3d846e197539712e51ecada90ded0572a ]

When auditd_set sets the auditd_conn pointer, audit messages can
immediately be put on the socket by other kernel threads. If the backlog
is large or the rate is high, this can immediately fill the socket
buffer. If the audit daemon requested an ACK for this operation, a full
socket buffer causes the ACK to get dropped, also setting ENOBUFS on the
socket.

To avoid this race and ensure ACKs get through, fast-track the ACK in
this specific case to ensure it is sent before auditd_conn is set.

Signed-off-by: Chris Riches <chris.riches@nutanix.com>
[PM: fix some tab vs space damage]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 16205dd29843..9c8e5f732c4c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -487,15 +487,19 @@ static void auditd_conn_free(struct rcu_head *rcu)
  * @pid: auditd PID
  * @portid: auditd netlink portid
  * @net: auditd network namespace pointer
+ * @skb: the netlink command from the audit daemon
+ * @ack: netlink ack flag, cleared if ack'd here
  *
  * Description:
  * This function will obtain and drop network namespace references as
  * necessary.  Returns zero on success, negative values on failure.
  */
-static int auditd_set(struct pid *pid, u32 portid, struct net *net)
+static int auditd_set(struct pid *pid, u32 portid, struct net *net,
+		      struct sk_buff *skb, bool *ack)
 {
 	unsigned long flags;
 	struct auditd_connection *ac_old, *ac_new;
+	struct nlmsghdr *nlh;
 
 	if (!pid || !net)
 		return -EINVAL;
@@ -507,6 +511,13 @@ static int auditd_set(struct pid *pid, u32 portid, struct net *net)
 	ac_new->portid = portid;
 	ac_new->net = get_net(net);
 
+	/* send the ack now to avoid a race with the queue backlog */
+	if (*ack) {
+		nlh = nlmsg_hdr(skb);
+		netlink_ack(skb, nlh, 0, NULL);
+		*ack = false;
+	}
+
 	spin_lock_irqsave(&auditd_conn_lock, flags);
 	ac_old = rcu_dereference_protected(auditd_conn,
 					   lockdep_is_held(&auditd_conn_lock));
@@ -1200,7 +1211,8 @@ static int audit_replace(struct pid *pid)
 	return auditd_send_unicast_skb(skb);
 }
 
-static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
+static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
+			     bool *ack)
 {
 	u32			seq;
 	void			*data;
@@ -1293,7 +1305,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				/* register a new auditd connection */
 				err = auditd_set(req_pid,
 						 NETLINK_CB(skb).portid,
-						 sock_net(NETLINK_CB(skb).sk));
+						 sock_net(NETLINK_CB(skb).sk),
+						 skb, ack);
 				if (audit_enabled != AUDIT_OFF)
 					audit_log_config_change("audit_pid",
 								new_pid,
@@ -1538,9 +1551,10 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
  * Parse the provided skb and deal with any messages that may be present,
  * malformed skbs are discarded.
  */
-static void audit_receive(struct sk_buff  *skb)
+static void audit_receive(struct sk_buff *skb)
 {
 	struct nlmsghdr *nlh;
+	bool ack;
 	/*
 	 * len MUST be signed for nlmsg_next to be able to dec it below 0
 	 * if the nlmsg_len was not aligned
@@ -1553,9 +1567,12 @@ static void audit_receive(struct sk_buff  *skb)
 
 	audit_ctl_lock();
 	while (nlmsg_ok(nlh, len)) {
-		err = audit_receive_msg(skb, nlh);
-		/* if err or if this message says it wants a response */
-		if (err || (nlh->nlmsg_flags & NLM_F_ACK))
+		ack = nlh->nlmsg_flags & NLM_F_ACK;
+		err = audit_receive_msg(skb, nlh, &ack);
+
+		/* send an ack if the user asked for one and audit_receive_msg
+		 * didn't already do it, or if there was an error. */
+		if (ack || err)
 			netlink_ack(skb, nlh, err, NULL);
 
 		nlh = nlmsg_next(nlh, &len);
-- 
2.43.0



