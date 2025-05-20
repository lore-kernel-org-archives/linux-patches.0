Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61C7253F3A;
	Tue, 20 May 2025 14:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750510; cv=none; b=IcB70npRLKVdlPCmGIWI1L7MNRaxepPyWbHHk46+XFu1BzI6ZgJ5+ThBfGctlc9FKVniFNoIfSVG3a3b80XUwOsu1Z1b1BZKT68oWOUHR43xmmAsTrRsPAw1/nETxjgNFx1dxb5UdDJ9qy1e6ha76RfyQCerC9ucFNj8XIcP4DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750510; c=relaxed/simple;
	bh=VEGaStB4Qc8jmzrLSKD8Njd1lysmikoLaljm3QF1diE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEhJaQTUULhVL3US4/sEvmWK/5JhsYtiJLbSNtUg8XSt6G7nJrGDJTN4CghaxQsiC0+nEUgh2anTsvRVNEsPJHwW/Nf3sqi3M1TTyrritELeubtfilY+rhyh/JwIf1pPxGthiY/FA3kxJc0QVrxhvQmKxolgeZH2YSf/M4hoCEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzKkWMeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzKkWMeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE5AC4CEE9;
	Tue, 20 May 2025 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750510;
	bh=VEGaStB4Qc8jmzrLSKD8Njd1lysmikoLaljm3QF1diE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzKkWMeI2eGAEl9quqjltDcQ+f6UX87NId/J6EBOWTLUWl0ByXzr0mjRoZibBGaDD
	 Iuq7RCUmou2TpC0K0xXSw681bLSEqVlY4oxYj79kAUW0mhB7ZRXHiFTTTjyoKZrQIv
	 PuJyAymPgbZrk0GuIWba024xzri4rv9EMvdXdp+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e76d52dadc089b9d197f@syzkaller.appspotmail.com,
	syzbot+1065a199625a388fce60@syzkaller.appspotmail.com,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 031/145] net: mctp: Dont access ifa_index when missing
Date: Tue, 20 May 2025 15:50:01 +0200
Message-ID: <20250520125811.786242241@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit f11cf946c0a92c560a890d68e4775723353599e1 ]

In mctp_dump_addrinfo, ifa_index can be used to filter interfaces, but
only when the struct ifaddrmsg is provided. Otherwise it will be
comparing to uninitialised memory - reproducible in the syzkaller case from
dhcpd, or busybox "ip addr show".

The kernel MCTP implementation has always filtered by ifa_index, so
existing userspace programs expecting to dump MCTP addresses must
already be passing a valid ifa_index value (either 0 or a real index).

BUG: KMSAN: uninit-value in mctp_dump_addrinfo+0x208/0xac0 net/mctp/device.c:128
 mctp_dump_addrinfo+0x208/0xac0 net/mctp/device.c:128
 rtnl_dump_all+0x3ec/0x5b0 net/core/rtnetlink.c:4380
 rtnl_dumpit+0xd5/0x2f0 net/core/rtnetlink.c:6824
 netlink_dump+0x97b/0x1690 net/netlink/af_netlink.c:2309

Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Reported-by: syzbot+e76d52dadc089b9d197f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68135815.050a0220.3a872c.000e.GAE@google.com/
Reported-by: syzbot+1065a199625a388fce60@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/681357d6.050a0220.14dd7d.000d.GAE@google.com/
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20250508-mctp-addr-dump-v2-1-c8a53fd2dd66@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 8e0724c56723d..7c0dcf3df3196 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -117,11 +117,18 @@ static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	struct net_device *dev;
 	struct ifaddrmsg *hdr;
 	struct mctp_dev *mdev;
-	int ifindex, rc;
-
-	hdr = nlmsg_data(cb->nlh);
-	// filter by ifindex if requested
-	ifindex = hdr->ifa_index;
+	int ifindex = 0, rc;
+
+	/* Filter by ifindex if a header is provided */
+	if (cb->nlh->nlmsg_len >= nlmsg_msg_size(sizeof(*hdr))) {
+		hdr = nlmsg_data(cb->nlh);
+		ifindex = hdr->ifa_index;
+	} else {
+		if (cb->strict_check) {
+			NL_SET_ERR_MSG(cb->extack, "mctp: Invalid header for addr dump request");
+			return -EINVAL;
+		}
+	}
 
 	rcu_read_lock();
 	for_each_netdev_dump(net, dev, mcb->ifindex) {
-- 
2.39.5



