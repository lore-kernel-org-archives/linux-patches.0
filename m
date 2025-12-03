Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7D3313558;
	Wed,  3 Dec 2025 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778026; cv=none; b=ZHGqcxIMRkx5SfYg3nt2lCu05SRpD7lVAn9pItnCmsIHHFqnPgKCpsbDmFNklm9+kBJfTe5GPRhWigkoV8GG4U9U/83LH7iqDVWxFC9wRnBzqkC7h7nRHjp9DLLuNcpTO+YcuXBLbEHIVG3NV9A3YBtNQKzH1gvsjO+73hl04kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778026; c=relaxed/simple;
	bh=yeSnQGbFi4tH0JyonIdbUDdmz2cHsHIXHeVGvKE2JP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYCFFheuWmmQ8OFLLe5Bh+q+MEIVjvTZkFLVYQJZAofDrgAOunGZY3SdTIhgQ44Pzs/WTprrqaYTzhv4LCQ7a+x0B+9k0k7qjeSiWixHt4Lw8z8J6dUL81S/4aQMayaapVDeDlwP+OdaJYBy5Nj/i7Hm03lNPUpG7xqVXQSpr78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ey+fc3so; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ey+fc3so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C56C4CEF5;
	Wed,  3 Dec 2025 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778026;
	bh=yeSnQGbFi4tH0JyonIdbUDdmz2cHsHIXHeVGvKE2JP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ey+fc3soMrvRw4Z/z6SATRNa0L5KX8HLNwfaj/SbPa86bT0AnAHzH8ERzy0bOQzpA
	 p6hKZldlt6jlgl7b7RThYPQuO2f5DLrFbF9z1R0EdwVsFvNwuTZRmKe8jlev3o7KBK
	 cg8yW8ly/v/GwKoUULovHE5rcp6L5fMfYH3l0dEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/392] sctp: Hold sock lock while iterating over address list
Date: Wed,  3 Dec 2025 16:26:11 +0100
Message-ID: <20251203152422.318518677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wiehler <stefan.wiehler@nokia.com>

[ Upstream commit f1fc201148c7e684c10a72b6a3375597f28d1ef6 ]

Move address list traversal in inet_assoc_attr_size() under the sock
lock to avoid holding the RCU read lock.

Suggested-by: Xin Long <lucien.xin@gmail.com>
Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20251028161506.3294376-4-stefan.wiehler@nokia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/diag.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 3631a32d96b07..2cf5ee7a698e2 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -230,14 +230,15 @@ struct sctp_comm_param {
 	bool net_admin;
 };
 
-static size_t inet_assoc_attr_size(struct sctp_association *asoc)
+static size_t inet_assoc_attr_size(struct sock *sk,
+				   struct sctp_association *asoc)
 {
 	int addrlen = sizeof(struct sockaddr_storage);
 	int addrcnt = 0;
 	struct sctp_sockaddr_entry *laddr;
 
 	list_for_each_entry_rcu(laddr, &asoc->base.bind_addr.address_list,
-				list)
+				list, lockdep_sock_is_held(sk))
 		addrcnt++;
 
 	return	  nla_total_size(sizeof(struct sctp_info))
@@ -263,11 +264,14 @@ static int sctp_sock_dump_one(struct sctp_endpoint *ep, struct sctp_transport *t
 	if (err)
 		return err;
 
-	rep = nlmsg_new(inet_assoc_attr_size(assoc), GFP_KERNEL);
-	if (!rep)
+	lock_sock(sk);
+
+	rep = nlmsg_new(inet_assoc_attr_size(sk, assoc), GFP_KERNEL);
+	if (!rep) {
+		release_sock(sk);
 		return -ENOMEM;
+	}
 
-	lock_sock(sk);
 	if (ep != assoc->ep) {
 		err = -EAGAIN;
 		goto out;
-- 
2.51.0



