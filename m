Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401951A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/nYHRWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02ECC433C8;
	Mon,  9 Oct 2023 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857732;
	bh=7uXor8R0i0YmiSd9QHoAXzDjDxsq2vjH5VCPCaXliIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/nYHRWnfQVyICyz2+1UTogmaX2VLJhAspL4KFmHsq8Oi1A8Is5slcmmBGnwQ5cxq
	 P4Vh2ymbnWZ0/tHO1PiIZ7XnfooGCtG1OjlNVl0D3ReW4v5wAPOA61DYdYGG/18m6z
	 UtTPxdP84+xO2udBgUpH2ME2nTVYar9cpxLu5VDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/162] netlink: split up copies in the ack construction
Date: Mon,  9 Oct 2023 15:01:52 +0200
Message-ID: <20231009130126.532421086@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 738136a0e3757a8534df3ad97d6ff6d7f429f6c1 ]

Clean up the use of unsafe_memcpy() by adding a flexible array
at the end of netlink message header and splitting up the header
and data copies.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d0f95894fda7 ("netlink: annotate data-races around sk->sk_err")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netlink.h        | 21 +++++++++++++++++++++
 include/uapi/linux/netlink.h |  2 ++
 net/netlink/af_netlink.c     | 29 ++++++++++++++++++++---------
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 6bfa972f2fbf2..a686c9041ddc0 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -937,6 +937,27 @@ static inline struct nlmsghdr *nlmsg_put(struct sk_buff *skb, u32 portid, u32 se
 	return __nlmsg_put(skb, portid, seq, type, payload, flags);
 }
 
+/**
+ * nlmsg_append - Add more data to a nlmsg in a skb
+ * @skb: socket buffer to store message in
+ * @size: length of message payload
+ *
+ * Append data to an existing nlmsg, used when constructing a message
+ * with multiple fixed-format headers (which is rare).
+ * Returns NULL if the tailroom of the skb is insufficient to store
+ * the extra payload.
+ */
+static inline void *nlmsg_append(struct sk_buff *skb, u32 size)
+{
+	if (unlikely(skb_tailroom(skb) < NLMSG_ALIGN(size)))
+		return NULL;
+
+	if (NLMSG_ALIGN(size) - size)
+		memset(skb_tail_pointer(skb) + size, 0,
+		       NLMSG_ALIGN(size) - size);
+	return __skb_put(skb, NLMSG_ALIGN(size));
+}
+
 /**
  * nlmsg_put_answer - Add a new callback based netlink message to an skb
  * @skb: socket buffer to store message in
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index e2ae82e3f9f71..5da0da59bf010 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -48,6 +48,7 @@ struct sockaddr_nl {
  * @nlmsg_flags: Additional flags
  * @nlmsg_seq:   Sequence number
  * @nlmsg_pid:   Sending process port ID
+ * @nlmsg_data:  Message payload
  */
 struct nlmsghdr {
 	__u32		nlmsg_len;
@@ -55,6 +56,7 @@ struct nlmsghdr {
 	__u16		nlmsg_flags;
 	__u32		nlmsg_seq;
 	__u32		nlmsg_pid;
+	__u8		nlmsg_data[];
 };
 
 /* Flags values */
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 387e430a35ccc..4ddb2ed7706ad 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2443,19 +2443,24 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		flags |= NLM_F_ACK_TLVS;
 
 	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
-	if (!skb) {
-		NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
-		sk_error_report(NETLINK_CB(in_skb).sk);
-		return;
-	}
+	if (!skb)
+		goto err_bad_put;
 
 	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
-			NLMSG_ERROR, payload, flags);
+			NLMSG_ERROR, sizeof(*errmsg), flags);
+	if (!rep)
+		goto err_bad_put;
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
-	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
-					 ? nlh->nlmsg_len : sizeof(*nlh),
-		      /* Bounds checked by the skb layer. */);
+	errmsg->msg = *nlh;
+
+	if (!(flags & NLM_F_CAPPED)) {
+		if (!nlmsg_append(skb, nlmsg_len(nlh)))
+			goto err_bad_put;
+
+		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
+		       nlmsg_len(nlh));
+	}
 
 	if (tlvlen)
 		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
@@ -2463,6 +2468,12 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	nlmsg_end(skb, rep);
 
 	nlmsg_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid);
+
+	return;
+
+err_bad_put:
+	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
+	sk_error_report(NETLINK_CB(in_skb).sk);
 }
 EXPORT_SYMBOL(netlink_ack);
 
-- 
2.40.1



