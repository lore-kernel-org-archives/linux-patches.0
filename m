Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1988A308F35;
	Mon, 13 Oct 2025 15:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368523; cv=none; b=h33WDl7TduvBwxV92HyHeZppz3VSQr7GOrgvTdXNu5rds8OJiyMup/FJv4Y2kuBuiB1ZfobOqjJs0iEt2IMXyb2p2cSUfIRSN/E9ZaXcdt7lk76quGngONt/5Ee+Jzd0U7hIHaymit5Esl2HhX4TDHK8Y67Rqvd9pS5ghYGtZxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368523; c=relaxed/simple;
	bh=XaqWto8Ec7BUVnKtyYK92ZjhlF3ZOZAA174ycmWsc8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlTcVb/hC5axdzXwa7fUc7j0OiiuMvv1NbQWH95FwygS77MsjP0c8YB1L55mxKmd1S+FKB1cv/xrBauZut+c30CnWeI+hdpNELJxxlGydEMDGYQa5neCQtZe0Sa+17wwWl0vB83L6o3AX8drqMkhwJhwRDBT/E6XOHX0suNY0sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWtJnqk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWtJnqk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967BBC4CEE7;
	Mon, 13 Oct 2025 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368523;
	bh=XaqWto8Ec7BUVnKtyYK92ZjhlF3ZOZAA174ycmWsc8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWtJnqk91SvpiKNdI+9URmW2QibURV012xaxDaPqcBxolpIAPzamF/fFaSJ7+5TdE
	 CAovvU+9O4/pDWsJ+MsFHz8qFUfK/ZoB+H/n9VHW5LRFT8KsXMfPlguKPlSIrqmXhO
	 jHL1SmhpXCTuXWeYuM/740Ou9zDziE0qJmOqK44k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/262] netfilter: nfnetlink: reset nlh pointer during batch replay
Date: Mon, 13 Oct 2025 16:45:33 +0200
Message-ID: <20251013144333.127385895@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 09efbac953f6f076a07735f9ba885148d4796235 ]

During a batch replay, the nlh pointer is not reset until the parsing of
the commands. Since commit bf2ac490d28c ("netfilter: nfnetlink: Handle
ACK flags for batch messages") that is problematic as the condition to
add an ACK for batch begin will evaluate to true even if NLM_F_ACK
wasn't used for batch begin message.

If there is an error during the command processing, netlink is sending
an ACK despite that. This misleads userspace tools which think that the
return code was 0. Reset the nlh pointer to the original one when a
replay is triggered.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7784ec094097b..f12d0d229aaa5 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -376,6 +376,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
 	struct netlink_ext_ack extack;
+	struct nlmsghdr *onlh = nlh;
 	LIST_HEAD(err_list);
 	u32 status;
 	int err;
@@ -386,6 +387,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	status = 0;
 replay_abort:
 	skb = netlink_skb_clone(oskb, GFP_KERNEL);
+	nlh = onlh;
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM, NULL);
 
-- 
2.51.0



