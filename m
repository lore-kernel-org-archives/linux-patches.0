Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D0B335079;
	Fri, 17 Oct 2025 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715481; cv=none; b=A4rrh0QuOHRZIUYoZTWaBZPxYL6VHjwNa8+qU2VZTLRLJKPjXRAH4XXshEEFhCZnu6qhjvQrAj4pr8ptH3hem2lyTdrlIPitM3t01BI7tIruzDkLrKCe2GgP6oYun/0wncldRWK+X6ag5W2B0fz73PktXSyCepbMoprT8idiv6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715481; c=relaxed/simple;
	bh=lnLXixg1OtyVQ0IzuxGfDk6VNsGQ14Ck6vODmIuzUwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ji+AjIOdk+DUYU9f14BqKG2MhZs2z2YJwwgSXVYKOmfwe0owYahre3b8ys8ml2lFfaTC+mSRvEf+O2IBMpvpJ/Ne9MD5t11SKR5dAXr684HLNw/YLINsIgRl1Ev6wA8/LKKDBQJogTcUnGD3WGoVsrQ97EEqMte31w5pTl7/XVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtLdLbMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtLdLbMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA8BC4CEE7;
	Fri, 17 Oct 2025 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715481;
	bh=lnLXixg1OtyVQ0IzuxGfDk6VNsGQ14Ck6vODmIuzUwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtLdLbMP9RPx9y/OuH/fgHsO7F/0hZNPqFDepfddJob5l/su3O7jE9o82Qpu9pAyT
	 nN3lAnP0pNENH6l60VcaRSxMmqgxSq8JQbIaP2Y7g7EFKSZqUmbIgSgjG3+iMmYQ/l
	 W7KxJmY7ceRNO8c+533An3eEKBEw2cgM4P02q6ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilles BULOZ <gilles.buloz@kontron.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.17 230/371] ipmi: Rework user message limit handling
Date: Fri, 17 Oct 2025 16:53:25 +0200
Message-ID: <20251017145210.404491917@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit b52da4054ee0bf9ecb44996f2c83236ff50b3812 upstream.

The limit on the number of user messages had a number of issues,
improper counting in some cases and a use after free.

Restructure how this is all done to handle more in the receive message
allocation routine, so all refcouting and user message limit counts
are done in that routine.  It's a lot cleaner and safer.

Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
Closes: https://lore.kernel.org/lkml/aLsw6G0GyqfpKs2S@mail.minyard.net/
Fixes: 8e76741c3d8b ("ipmi: Add a limit on the number of users that may use IPMI")
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Corey Minyard <corey@minyard.net>
Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |  420 +++++++++++++++++-------------------
 1 file changed, 200 insertions(+), 220 deletions(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -38,7 +38,9 @@
 
 #define IPMI_DRIVER_VERSION "39.2"
 
-static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
+static struct ipmi_recv_msg *ipmi_alloc_recv_msg(struct ipmi_user *user);
+static void ipmi_set_recv_msg_user(struct ipmi_recv_msg *msg,
+				   struct ipmi_user *user);
 static int ipmi_init_msghandler(void);
 static void smi_work(struct work_struct *t);
 static void handle_new_recv_msgs(struct ipmi_smi *intf);
@@ -955,7 +957,6 @@ static int deliver_response(struct ipmi_
 		 * risk.  At this moment, simply skip it in that case.
 		 */
 		ipmi_free_recv_msg(msg);
-		atomic_dec(&msg->user->nr_msgs);
 	} else {
 		/*
 		 * Deliver it in smi_work.  The message will hold a
@@ -1616,8 +1617,7 @@ int ipmi_set_gets_events(struct ipmi_use
 		}
 
 		list_for_each_entry_safe(msg, msg2, &msgs, link) {
-			msg->user = user;
-			kref_get(&user->refcount);
+			ipmi_set_recv_msg_user(msg, user);
 			deliver_local_response(intf, msg);
 		}
 	}
@@ -2288,22 +2288,15 @@ static int i_ipmi_request(struct ipmi_us
 	int run_to_completion = READ_ONCE(intf->run_to_completion);
 	int rv = 0;
 
-	if (user) {
-		if (atomic_add_return(1, &user->nr_msgs) > max_msgs_per_user) {
-			/* Decrement will happen at the end of the routine. */
-			rv = -EBUSY;
-			goto out;
-		}
-	}
-
-	if (supplied_recv)
+	if (supplied_recv) {
 		recv_msg = supplied_recv;
-	else {
-		recv_msg = ipmi_alloc_recv_msg();
-		if (recv_msg == NULL) {
-			rv = -ENOMEM;
-			goto out;
-		}
+		recv_msg->user = user;
+		if (user)
+			atomic_inc(&user->nr_msgs);
+	} else {
+		recv_msg = ipmi_alloc_recv_msg(user);
+		if (IS_ERR(recv_msg))
+			return PTR_ERR(recv_msg);
 	}
 	recv_msg->user_msg_data = user_msg_data;
 
@@ -2314,8 +2307,7 @@ static int i_ipmi_request(struct ipmi_us
 		if (smi_msg == NULL) {
 			if (!supplied_recv)
 				ipmi_free_recv_msg(recv_msg);
-			rv = -ENOMEM;
-			goto out;
+			return -ENOMEM;
 		}
 	}
 
@@ -2326,10 +2318,6 @@ static int i_ipmi_request(struct ipmi_us
 		goto out_err;
 	}
 
-	recv_msg->user = user;
-	if (user)
-		/* The put happens when the message is freed. */
-		kref_get(&user->refcount);
 	recv_msg->msgid = msgid;
 	/*
 	 * Store the message to send in the receive message so timeout
@@ -2358,8 +2346,10 @@ static int i_ipmi_request(struct ipmi_us
 
 	if (rv) {
 out_err:
-		ipmi_free_smi_msg(smi_msg);
-		ipmi_free_recv_msg(recv_msg);
+		if (!supplied_smi)
+			ipmi_free_smi_msg(smi_msg);
+		if (!supplied_recv)
+			ipmi_free_recv_msg(recv_msg);
 	} else {
 		dev_dbg(intf->si_dev, "Send: %*ph\n",
 			smi_msg->data_size, smi_msg->data);
@@ -2369,9 +2359,6 @@ out_err:
 	if (!run_to_completion)
 		mutex_unlock(&intf->users_mutex);
 
-out:
-	if (rv && user)
-		atomic_dec(&user->nr_msgs);
 	return rv;
 }
 
@@ -3862,7 +3849,7 @@ static int handle_ipmb_get_msg_cmd(struc
 	unsigned char            chan;
 	struct ipmi_user         *user = NULL;
 	struct ipmi_ipmb_addr    *ipmb_addr;
-	struct ipmi_recv_msg     *recv_msg;
+	struct ipmi_recv_msg     *recv_msg = NULL;
 
 	if (msg->rsp_size < 10) {
 		/* Message not big enough, just ignore it. */
@@ -3883,9 +3870,8 @@ static int handle_ipmb_get_msg_cmd(struc
 	rcvr = find_cmd_rcvr(intf, netfn, cmd, chan);
 	if (rcvr) {
 		user = rcvr->user;
-		kref_get(&user->refcount);
-	} else
-		user = NULL;
+		recv_msg = ipmi_alloc_recv_msg(user);
+	}
 	rcu_read_unlock();
 
 	if (user == NULL) {
@@ -3915,47 +3901,41 @@ static int handle_ipmb_get_msg_cmd(struc
 		 * causes it to not be freed or queued.
 		 */
 		rv = -1;
-	} else {
-		recv_msg = ipmi_alloc_recv_msg();
-		if (!recv_msg) {
-			/*
-			 * We couldn't allocate memory for the
-			 * message, so requeue it for handling
-			 * later.
-			 */
-			rv = 1;
-			kref_put(&user->refcount, free_ipmi_user);
-		} else {
-			/* Extract the source address from the data. */
-			ipmb_addr = (struct ipmi_ipmb_addr *) &recv_msg->addr;
-			ipmb_addr->addr_type = IPMI_IPMB_ADDR_TYPE;
-			ipmb_addr->slave_addr = msg->rsp[6];
-			ipmb_addr->lun = msg->rsp[7] & 3;
-			ipmb_addr->channel = msg->rsp[3] & 0xf;
+	} else if (!IS_ERR(recv_msg)) {
+		/* Extract the source address from the data. */
+		ipmb_addr = (struct ipmi_ipmb_addr *) &recv_msg->addr;
+		ipmb_addr->addr_type = IPMI_IPMB_ADDR_TYPE;
+		ipmb_addr->slave_addr = msg->rsp[6];
+		ipmb_addr->lun = msg->rsp[7] & 3;
+		ipmb_addr->channel = msg->rsp[3] & 0xf;
 
-			/*
-			 * Extract the rest of the message information
-			 * from the IPMB header.
-			 */
-			recv_msg->user = user;
-			recv_msg->recv_type = IPMI_CMD_RECV_TYPE;
-			recv_msg->msgid = msg->rsp[7] >> 2;
-			recv_msg->msg.netfn = msg->rsp[4] >> 2;
-			recv_msg->msg.cmd = msg->rsp[8];
-			recv_msg->msg.data = recv_msg->msg_data;
+		/*
+		 * Extract the rest of the message information
+		 * from the IPMB header.
+		 */
+		recv_msg->recv_type = IPMI_CMD_RECV_TYPE;
+		recv_msg->msgid = msg->rsp[7] >> 2;
+		recv_msg->msg.netfn = msg->rsp[4] >> 2;
+		recv_msg->msg.cmd = msg->rsp[8];
+		recv_msg->msg.data = recv_msg->msg_data;
 
-			/*
-			 * We chop off 10, not 9 bytes because the checksum
-			 * at the end also needs to be removed.
-			 */
-			recv_msg->msg.data_len = msg->rsp_size - 10;
-			memcpy(recv_msg->msg_data, &msg->rsp[9],
-			       msg->rsp_size - 10);
-			if (deliver_response(intf, recv_msg))
-				ipmi_inc_stat(intf, unhandled_commands);
-			else
-				ipmi_inc_stat(intf, handled_commands);
-		}
+		/*
+		 * We chop off 10, not 9 bytes because the checksum
+		 * at the end also needs to be removed.
+		 */
+		recv_msg->msg.data_len = msg->rsp_size - 10;
+		memcpy(recv_msg->msg_data, &msg->rsp[9],
+		       msg->rsp_size - 10);
+		if (deliver_response(intf, recv_msg))
+			ipmi_inc_stat(intf, unhandled_commands);
+		else
+			ipmi_inc_stat(intf, handled_commands);
+	} else {
+		/*
+		 * We couldn't allocate memory for the message, so
+		 * requeue it for handling later.
+		 */
+		rv = 1;
 	}
 
 	return rv;
@@ -3968,7 +3948,7 @@ static int handle_ipmb_direct_rcv_cmd(st
 	int                      rv = 0;
 	struct ipmi_user         *user = NULL;
 	struct ipmi_ipmb_direct_addr *daddr;
-	struct ipmi_recv_msg     *recv_msg;
+	struct ipmi_recv_msg     *recv_msg = NULL;
 	unsigned char netfn = msg->rsp[0] >> 2;
 	unsigned char cmd = msg->rsp[3];
 
@@ -3977,9 +3957,8 @@ static int handle_ipmb_direct_rcv_cmd(st
 	rcvr = find_cmd_rcvr(intf, netfn, cmd, 0);
 	if (rcvr) {
 		user = rcvr->user;
-		kref_get(&user->refcount);
-	} else
-		user = NULL;
+		recv_msg = ipmi_alloc_recv_msg(user);
+	}
 	rcu_read_unlock();
 
 	if (user == NULL) {
@@ -4001,44 +3980,38 @@ static int handle_ipmb_direct_rcv_cmd(st
 		 * causes it to not be freed or queued.
 		 */
 		rv = -1;
-	} else {
-		recv_msg = ipmi_alloc_recv_msg();
-		if (!recv_msg) {
-			/*
-			 * We couldn't allocate memory for the
-			 * message, so requeue it for handling
-			 * later.
-			 */
-			rv = 1;
-			kref_put(&user->refcount, free_ipmi_user);
-		} else {
-			/* Extract the source address from the data. */
-			daddr = (struct ipmi_ipmb_direct_addr *)&recv_msg->addr;
-			daddr->addr_type = IPMI_IPMB_DIRECT_ADDR_TYPE;
-			daddr->channel = 0;
-			daddr->slave_addr = msg->rsp[1];
-			daddr->rs_lun = msg->rsp[0] & 3;
-			daddr->rq_lun = msg->rsp[2] & 3;
+	} else if (!IS_ERR(recv_msg)) {
+		/* Extract the source address from the data. */
+		daddr = (struct ipmi_ipmb_direct_addr *)&recv_msg->addr;
+		daddr->addr_type = IPMI_IPMB_DIRECT_ADDR_TYPE;
+		daddr->channel = 0;
+		daddr->slave_addr = msg->rsp[1];
+		daddr->rs_lun = msg->rsp[0] & 3;
+		daddr->rq_lun = msg->rsp[2] & 3;
 
-			/*
-			 * Extract the rest of the message information
-			 * from the IPMB header.
-			 */
-			recv_msg->user = user;
-			recv_msg->recv_type = IPMI_CMD_RECV_TYPE;
-			recv_msg->msgid = (msg->rsp[2] >> 2);
-			recv_msg->msg.netfn = msg->rsp[0] >> 2;
-			recv_msg->msg.cmd = msg->rsp[3];
-			recv_msg->msg.data = recv_msg->msg_data;
-
-			recv_msg->msg.data_len = msg->rsp_size - 4;
-			memcpy(recv_msg->msg_data, msg->rsp + 4,
-			       msg->rsp_size - 4);
-			if (deliver_response(intf, recv_msg))
-				ipmi_inc_stat(intf, unhandled_commands);
-			else
-				ipmi_inc_stat(intf, handled_commands);
-		}
+		/*
+		 * Extract the rest of the message information
+		 * from the IPMB header.
+		 */
+		recv_msg->recv_type = IPMI_CMD_RECV_TYPE;
+		recv_msg->msgid = (msg->rsp[2] >> 2);
+		recv_msg->msg.netfn = msg->rsp[0] >> 2;
+		recv_msg->msg.cmd = msg->rsp[3];
+		recv_msg->msg.data = recv_msg->msg_data;
+
+		recv_msg->msg.data_len = msg->rsp_size - 4;
+		memcpy(recv_msg->msg_data, msg->rsp + 4,
+		       msg->rsp_size - 4);
+		if (deliver_response(intf, recv_msg))
+			ipmi_inc_stat(intf, unhandled_commands);
+		else
+			ipmi_inc_stat(intf, handled_commands);
+	} else {
+		/*
+		 * We couldn't allocate memory for the message, so
+		 * requeue it for handling later.
+		 */
+		rv = 1;
 	}
 
 	return rv;
@@ -4152,7 +4125,7 @@ static int handle_lan_get_msg_cmd(struct
 	unsigned char            chan;
 	struct ipmi_user         *user = NULL;
 	struct ipmi_lan_addr     *lan_addr;
-	struct ipmi_recv_msg     *recv_msg;
+	struct ipmi_recv_msg     *recv_msg = NULL;
 
 	if (msg->rsp_size < 12) {
 		/* Message not big enough, just ignore it. */
@@ -4173,9 +4146,8 @@ static int handle_lan_get_msg_cmd(struct
 	rcvr = find_cmd_rcvr(intf, netfn, cmd, chan);
 	if (rcvr) {
 		user = rcvr->user;
-		kref_get(&user->refcount);
-	} else
-		user = NULL;
+		recv_msg = ipmi_alloc_recv_msg(user);
+	}
 	rcu_read_unlock();
 
 	if (user == NULL) {
@@ -4206,49 +4178,44 @@ static int handle_lan_get_msg_cmd(struct
 		 * causes it to not be freed or queued.
 		 */
 		rv = -1;
-	} else {
-		recv_msg = ipmi_alloc_recv_msg();
-		if (!recv_msg) {
-			/*
-			 * We couldn't allocate memory for the
-			 * message, so requeue it for handling later.
-			 */
-			rv = 1;
-			kref_put(&user->refcount, free_ipmi_user);
-		} else {
-			/* Extract the source address from the data. */
-			lan_addr = (struct ipmi_lan_addr *) &recv_msg->addr;
-			lan_addr->addr_type = IPMI_LAN_ADDR_TYPE;
-			lan_addr->session_handle = msg->rsp[4];
-			lan_addr->remote_SWID = msg->rsp[8];
-			lan_addr->local_SWID = msg->rsp[5];
-			lan_addr->lun = msg->rsp[9] & 3;
-			lan_addr->channel = msg->rsp[3] & 0xf;
-			lan_addr->privilege = msg->rsp[3] >> 4;
+	} else if (!IS_ERR(recv_msg)) {
+		/* Extract the source address from the data. */
+		lan_addr = (struct ipmi_lan_addr *) &recv_msg->addr;
+		lan_addr->addr_type = IPMI_LAN_ADDR_TYPE;
+		lan_addr->session_handle = msg->rsp[4];
+		lan_addr->remote_SWID = msg->rsp[8];
+		lan_addr->local_SWID = msg->rsp[5];
+		lan_addr->lun = msg->rsp[9] & 3;
+		lan_addr->channel = msg->rsp[3] & 0xf;
+		lan_addr->privilege = msg->rsp[3] >> 4;
 
-			/*
-			 * Extract the rest of the message information
-			 * from the IPMB header.
-			 */
-			recv_msg->user = user;
-			recv_msg->recv_type = IPMI_CMD_RECV_TYPE;
-			recv_msg->msgid = msg->rsp[9] >> 2;
-			recv_msg->msg.netfn = msg->rsp[6] >> 2;
-			recv_msg->msg.cmd = msg->rsp[10];
-			recv_msg->msg.data = recv_msg->msg_data;
+		/*
+		 * Extract the rest of the message information
+		 * from the IPMB header.
+		 */
+		recv_msg->recv_type = IPMI_CMD_RECV_TYPE;
+		recv_msg->msgid = msg->rsp[9] >> 2;
+		recv_msg->msg.netfn = msg->rsp[6] >> 2;
+		recv_msg->msg.cmd = msg->rsp[10];
+		recv_msg->msg.data = recv_msg->msg_data;
 
-			/*
-			 * We chop off 12, not 11 bytes because the checksum
-			 * at the end also needs to be removed.
-			 */
-			recv_msg->msg.data_len = msg->rsp_size - 12;
-			memcpy(recv_msg->msg_data, &msg->rsp[11],
-			       msg->rsp_size - 12);
-			if (deliver_response(intf, recv_msg))
-				ipmi_inc_stat(intf, unhandled_commands);
-			else
-				ipmi_inc_stat(intf, handled_commands);
-		}
+		/*
+		 * We chop off 12, not 11 bytes because the checksum
+		 * at the end also needs to be removed.
+		 */
+		recv_msg->msg.data_len = msg->rsp_size - 12;
+		memcpy(recv_msg->msg_data, &msg->rsp[11],
+		       msg->rsp_size - 12);
+		if (deliver_response(intf, recv_msg))
+			ipmi_inc_stat(intf, unhandled_commands);
+		else
+			ipmi_inc_stat(intf, handled_commands);
+	} else {
+		/*
+		 * We couldn't allocate memory for the message, so
+		 * requeue it for handling later.
+		 */
+		rv = 1;
 	}
 
 	return rv;
@@ -4270,7 +4237,7 @@ static int handle_oem_get_msg_cmd(struct
 	unsigned char         chan;
 	struct ipmi_user *user = NULL;
 	struct ipmi_system_interface_addr *smi_addr;
-	struct ipmi_recv_msg  *recv_msg;
+	struct ipmi_recv_msg  *recv_msg = NULL;
 
 	/*
 	 * We expect the OEM SW to perform error checking
@@ -4299,9 +4266,8 @@ static int handle_oem_get_msg_cmd(struct
 	rcvr = find_cmd_rcvr(intf, netfn, cmd, chan);
 	if (rcvr) {
 		user = rcvr->user;
-		kref_get(&user->refcount);
-	} else
-		user = NULL;
+		recv_msg = ipmi_alloc_recv_msg(user);
+	}
 	rcu_read_unlock();
 
 	if (user == NULL) {
@@ -4314,48 +4280,42 @@ static int handle_oem_get_msg_cmd(struct
 		 */
 
 		rv = 0;
-	} else {
-		recv_msg = ipmi_alloc_recv_msg();
-		if (!recv_msg) {
-			/*
-			 * We couldn't allocate memory for the
-			 * message, so requeue it for handling
-			 * later.
-			 */
-			rv = 1;
-			kref_put(&user->refcount, free_ipmi_user);
-		} else {
-			/*
-			 * OEM Messages are expected to be delivered via
-			 * the system interface to SMS software.  We might
-			 * need to visit this again depending on OEM
-			 * requirements
-			 */
-			smi_addr = ((struct ipmi_system_interface_addr *)
-				    &recv_msg->addr);
-			smi_addr->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
-			smi_addr->channel = IPMI_BMC_CHANNEL;
-			smi_addr->lun = msg->rsp[0] & 3;
-
-			recv_msg->user = user;
-			recv_msg->user_msg_data = NULL;
-			recv_msg->recv_type = IPMI_OEM_RECV_TYPE;
-			recv_msg->msg.netfn = msg->rsp[0] >> 2;
-			recv_msg->msg.cmd = msg->rsp[1];
-			recv_msg->msg.data = recv_msg->msg_data;
+	} else if (!IS_ERR(recv_msg)) {
+		/*
+		 * OEM Messages are expected to be delivered via
+		 * the system interface to SMS software.  We might
+		 * need to visit this again depending on OEM
+		 * requirements
+		 */
+		smi_addr = ((struct ipmi_system_interface_addr *)
+			    &recv_msg->addr);
+		smi_addr->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+		smi_addr->channel = IPMI_BMC_CHANNEL;
+		smi_addr->lun = msg->rsp[0] & 3;
+
+		recv_msg->user_msg_data = NULL;
+		recv_msg->recv_type = IPMI_OEM_RECV_TYPE;
+		recv_msg->msg.netfn = msg->rsp[0] >> 2;
+		recv_msg->msg.cmd = msg->rsp[1];
+		recv_msg->msg.data = recv_msg->msg_data;
 
-			/*
-			 * The message starts at byte 4 which follows the
-			 * Channel Byte in the "GET MESSAGE" command
-			 */
-			recv_msg->msg.data_len = msg->rsp_size - 4;
-			memcpy(recv_msg->msg_data, &msg->rsp[4],
-			       msg->rsp_size - 4);
-			if (deliver_response(intf, recv_msg))
-				ipmi_inc_stat(intf, unhandled_commands);
-			else
-				ipmi_inc_stat(intf, handled_commands);
-		}
+		/*
+		 * The message starts at byte 4 which follows the
+		 * Channel Byte in the "GET MESSAGE" command
+		 */
+		recv_msg->msg.data_len = msg->rsp_size - 4;
+		memcpy(recv_msg->msg_data, &msg->rsp[4],
+		       msg->rsp_size - 4);
+		if (deliver_response(intf, recv_msg))
+			ipmi_inc_stat(intf, unhandled_commands);
+		else
+			ipmi_inc_stat(intf, handled_commands);
+	} else {
+		/*
+		 * We couldn't allocate memory for the message, so
+		 * requeue it for handling later.
+		 */
+		rv = 1;
 	}
 
 	return rv;
@@ -4413,8 +4373,8 @@ static int handle_read_event_rsp(struct
 		if (!user->gets_events)
 			continue;
 
-		recv_msg = ipmi_alloc_recv_msg();
-		if (!recv_msg) {
+		recv_msg = ipmi_alloc_recv_msg(user);
+		if (IS_ERR(recv_msg)) {
 			mutex_unlock(&intf->users_mutex);
 			list_for_each_entry_safe(recv_msg, recv_msg2, &msgs,
 						 link) {
@@ -4435,8 +4395,6 @@ static int handle_read_event_rsp(struct
 		deliver_count++;
 
 		copy_event_into_recv_msg(recv_msg, msg);
-		recv_msg->user = user;
-		kref_get(&user->refcount);
 		list_add_tail(&recv_msg->link, &msgs);
 	}
 	mutex_unlock(&intf->users_mutex);
@@ -4452,8 +4410,8 @@ static int handle_read_event_rsp(struct
 		 * No one to receive the message, put it in queue if there's
 		 * not already too many things in the queue.
 		 */
-		recv_msg = ipmi_alloc_recv_msg();
-		if (!recv_msg) {
+		recv_msg = ipmi_alloc_recv_msg(NULL);
+		if (IS_ERR(recv_msg)) {
 			/*
 			 * We couldn't allocate memory for the
 			 * message, so requeue it for handling
@@ -4868,12 +4826,10 @@ static void smi_work(struct work_struct
 
 		list_del(&msg->link);
 
-		if (refcount_read(&user->destroyed) == 0) {
+		if (refcount_read(&user->destroyed) == 0)
 			ipmi_free_recv_msg(msg);
-		} else {
-			atomic_dec(&user->nr_msgs);
+		else
 			user->handler->ipmi_recv_hndl(msg, user->handler_data);
-		}
 	}
 	mutex_unlock(&intf->user_msgs_mutex);
 
@@ -5190,27 +5146,51 @@ static void free_recv_msg(struct ipmi_re
 		kfree(msg);
 }
 
-static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
+static struct ipmi_recv_msg *ipmi_alloc_recv_msg(struct ipmi_user *user)
 {
 	struct ipmi_recv_msg *rv;
 
+	if (user) {
+		if (atomic_add_return(1, &user->nr_msgs) > max_msgs_per_user) {
+			atomic_dec(&user->nr_msgs);
+			return ERR_PTR(-EBUSY);
+		}
+	}
+
 	rv = kmalloc(sizeof(struct ipmi_recv_msg), GFP_ATOMIC);
-	if (rv) {
-		rv->user = NULL;
-		rv->done = free_recv_msg;
-		atomic_inc(&recv_msg_inuse_count);
+	if (!rv) {
+		if (user)
+			atomic_dec(&user->nr_msgs);
+		return ERR_PTR(-ENOMEM);
 	}
+
+	rv->user = user;
+	rv->done = free_recv_msg;
+	if (user)
+		kref_get(&user->refcount);
+	atomic_inc(&recv_msg_inuse_count);
 	return rv;
 }
 
 void ipmi_free_recv_msg(struct ipmi_recv_msg *msg)
 {
-	if (msg->user && !oops_in_progress)
+	if (msg->user && !oops_in_progress) {
+		atomic_dec(&msg->user->nr_msgs);
 		kref_put(&msg->user->refcount, free_ipmi_user);
+	}
 	msg->done(msg);
 }
 EXPORT_SYMBOL(ipmi_free_recv_msg);
 
+static void ipmi_set_recv_msg_user(struct ipmi_recv_msg *msg,
+				   struct ipmi_user *user)
+{
+	WARN_ON_ONCE(msg->user); /* User should not be set. */
+	msg->user = user;
+	atomic_inc(&user->nr_msgs);
+	kref_get(&user->refcount);
+}
+
 static atomic_t panic_done_count = ATOMIC_INIT(0);
 
 static void dummy_smi_done_handler(struct ipmi_smi_msg *msg)


