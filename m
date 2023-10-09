Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2B21A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksoXqCRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67B3C433C7;
	Mon,  9 Oct 2023 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857830;
	bh=iJsIOUxRpamJR8dHTkE+cemzuMh/XRuLCKwPNzTxxmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksoXqCRVsSoL+mq6pLDMVZ2uhzFsiU51vgZHwVfihjKHUElJTjkxqUeS0Rw33aRQL
	 vY5cX37oJnd7gU7blbd3mULqg1wQ2B4fCkEAXTdCZnQd9nMp0wdAbVE8+jxLq+3Wkr
	 gnKUow4Enl341UHMGzHJX7QLi/awDMMkZ7GK9Clg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 162/162] netlink: remove the flex array from struct nlmsghdr
Date: Mon,  9 Oct 2023 15:02:23 +0200
Message-ID: <20231009130127.396225121@linuxfoundation.org>
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

commit c73a72f4cbb47672c8cc7f7d7aba52f1cb15baca upstream.

I've added a flex array to struct nlmsghdr in
commit 738136a0e375 ("netlink: split up copies in the ack construction")
to allow accessing the data easily. It leads to warnings with clang,
if user space wraps this structure into another struct and the flex
array is not at the end of the container.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/all/20221114023927.GA685@u2004-local/
Link: https://lore.kernel.org/r/20221118033903.1651026-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/netlink.h |    2 --
 net/netlink/af_netlink.c     |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -48,7 +48,6 @@ struct sockaddr_nl {
  * @nlmsg_flags: Additional flags
  * @nlmsg_seq:   Sequence number
  * @nlmsg_pid:   Sending process port ID
- * @nlmsg_data:  Message payload
  */
 struct nlmsghdr {
 	__u32		nlmsg_len;
@@ -56,7 +55,6 @@ struct nlmsghdr {
 	__u16		nlmsg_flags;
 	__u32		nlmsg_seq;
 	__u32		nlmsg_pid;
-	__u8		nlmsg_data[];
 };
 
 /* Flags values */
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2458,7 +2458,7 @@ void netlink_ack(struct sk_buff *in_skb,
 		if (!nlmsg_append(skb, nlmsg_len(nlh)))
 			goto err_bad_put;
 
-		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
+		memcpy(nlmsg_data(&errmsg->msg), nlmsg_data(nlh),
 		       nlmsg_len(nlh));
 	}
 


