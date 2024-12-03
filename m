Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FCA1F76B5;
	Tue,  3 Dec 2024 16:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241933; cv=none; b=CCGXybdpMwtKQpW7GvdqevJYP4a5yVvxqoBxVOLm50NH2QEocaLiWXdZzY6ELOvxUt00FeS+klII/FG85d+Tz+KhXxNLY8C7HIexzNBE/7tWqu5TVueEUZHAJwN57q42ovbG8X/cvZxGjKD4mmFkXCuLNix9HCsUnebl/uo2hAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241933; c=relaxed/simple;
	bh=zkHcSAexWKBtFfgRirqIl8k5Cq4FynIUWuT+AzAjNVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRdCUtSJ5BPZb4ixzhbxARZx78REycULXJ0uSfBH7bcZZCA/3jPJ86COnofHIZ9sr99gAF0QMpixSXlZqINVvC7zFDuUuGKJnZ/slgKYIVIlO1+AiejNG4lUykBZD0o6441i74/+0VnwU++nf8fzlmhDa8Dn41zIUQmeh8rc6qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeoyX5/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeoyX5/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C0EC4CECF;
	Tue,  3 Dec 2024 16:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241932;
	bh=zkHcSAexWKBtFfgRirqIl8k5Cq4FynIUWuT+AzAjNVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeoyX5/DnlmqiasKwej/C1z435/bGaf/RzTLzy6w5UiFup7qSjVyV/sLyGJNZdS84
	 LK3u0LTpxEY9Ct+qIx3ldWUNZ8Uh5MabmB8Ut1Xhhsn+nKYOJ0L7f3HMR5zGy4ZS3v
	 k7jvCTtlfDyTdr+bZlpeYTOygiEiQrtP45o6hTAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d4373fa8042c06cefa84@syzkaller.appspotmail.com,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 559/826] netlink: fix false positive warning in extack during dumps
Date: Tue,  3 Dec 2024 15:44:46 +0100
Message-ID: <20241203144805.551446111@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 3bf39fa849ab8ed52abb6715922e6102d3df9f97 ]

Commit under fixes extended extack reporting to dumps.
It works under normal conditions, because extack errors are
usually reported during ->start() or the first ->dump(),
it's quite rare that the dump starts okay but fails later.
If the dump does fail later, however, the input skb will
already have the initiating message pulled, so checking
if bad attr falls within skb->data will fail.

Switch the check to using nlh, which is always valid.

syzbot found a way to hit that scenario by filling up
the receive queue. In this case we initiate a dump
but don't call ->dump() until there is read space for
an skb.

WARNING: CPU: 1 PID: 5845 at net/netlink/af_netlink.c:2210 netlink_ack_tlv_fill+0x1a8/0x560 net/netlink/af_netlink.c:2209
RIP: 0010:netlink_ack_tlv_fill+0x1a8/0x560 net/netlink/af_netlink.c:2209
Call Trace:
 <TASK>
 netlink_dump_done+0x513/0x970 net/netlink/af_netlink.c:2250
 netlink_dump+0x91f/0xe10 net/netlink/af_netlink.c:2351
 netlink_recvmsg+0x6bb/0x11d0 net/netlink/af_netlink.c:1983
 sock_recvmsg_nosec net/socket.c:1051 [inline]
 sock_recvmsg+0x22f/0x280 net/socket.c:1073
 __sys_recvfrom+0x246/0x3d0 net/socket.c:2267
 __do_sys_recvfrom net/socket.c:2285 [inline]
 __se_sys_recvfrom net/socket.c:2281 [inline]
 __x64_sys_recvfrom+0xde/0x100 net/socket.c:2281
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 RIP: 0033:0x7ff37dd17a79

Reported-by: syzbot+d4373fa8042c06cefa84@syzkaller.appspotmail.com
Fixes: 8af4f60472fc ("netlink: support all extack types in dumps")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241119224432.1713040-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f84aad420d446..775d707ec708a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2176,9 +2176,14 @@ netlink_ack_tlv_len(struct netlink_sock *nlk, int err,
 	return tlvlen;
 }
 
+static bool nlmsg_check_in_payload(const struct nlmsghdr *nlh, const void *addr)
+{
+	return !WARN_ON(addr < nlmsg_data(nlh) ||
+			addr - (const void *) nlh >= nlh->nlmsg_len);
+}
+
 static void
-netlink_ack_tlv_fill(struct sk_buff *in_skb, struct sk_buff *skb,
-		     const struct nlmsghdr *nlh, int err,
+netlink_ack_tlv_fill(struct sk_buff *skb, const struct nlmsghdr *nlh, int err,
 		     const struct netlink_ext_ack *extack)
 {
 	if (extack->_msg)
@@ -2190,9 +2195,7 @@ netlink_ack_tlv_fill(struct sk_buff *in_skb, struct sk_buff *skb,
 	if (!err)
 		return;
 
-	if (extack->bad_attr &&
-	    !WARN_ON((u8 *)extack->bad_attr < in_skb->data ||
-		     (u8 *)extack->bad_attr >= in_skb->data + in_skb->len))
+	if (extack->bad_attr && nlmsg_check_in_payload(nlh, extack->bad_attr))
 		WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
 				    (u8 *)extack->bad_attr - (const u8 *)nlh));
 	if (extack->policy)
@@ -2201,9 +2204,7 @@ netlink_ack_tlv_fill(struct sk_buff *in_skb, struct sk_buff *skb,
 	if (extack->miss_type)
 		WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_MISS_TYPE,
 				    extack->miss_type));
-	if (extack->miss_nest &&
-	    !WARN_ON((u8 *)extack->miss_nest < in_skb->data ||
-		     (u8 *)extack->miss_nest > in_skb->data + in_skb->len))
+	if (extack->miss_nest && nlmsg_check_in_payload(nlh, extack->miss_nest))
 		WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_MISS_NEST,
 				    (u8 *)extack->miss_nest - (const u8 *)nlh));
 }
@@ -2232,7 +2233,7 @@ static int netlink_dump_done(struct netlink_sock *nlk, struct sk_buff *skb,
 	if (extack_len) {
 		nlh->nlmsg_flags |= NLM_F_ACK_TLVS;
 		if (skb_tailroom(skb) >= extack_len) {
-			netlink_ack_tlv_fill(cb->skb, skb, cb->nlh,
+			netlink_ack_tlv_fill(skb, cb->nlh,
 					     nlk->dump_done_errno, extack);
 			nlmsg_end(skb, nlh);
 		}
@@ -2491,7 +2492,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	}
 
 	if (tlvlen)
-		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
+		netlink_ack_tlv_fill(skb, nlh, err, extack);
 
 	nlmsg_end(skb, rep);
 
-- 
2.43.0



