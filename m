Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734AF2DC350;
	Tue, 11 Nov 2025 01:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825014; cv=none; b=N5iEAw1Xi8DsKxg2VycizGzXdtkrkB59loiXb284/DmugfC0lmB3i1ARyk78mM8b8F0SjID5uWVKQQLDqbIQqbXkw9mUklFYcjo1a08BdO3wP8Z9ShRXak0fkPa8RahS6mcehmiEmuaTR1nwWUzhoJoIMos7DMZYSiVD7rcA5BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825014; c=relaxed/simple;
	bh=5UHJc8xS4tpAvi/QwURSTz63A2mVm5VFxJYVnLkOGMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP7sj6qH/eSKBFjoX+wpTo/8Edop9Q+W7A2lfPxWzUsbIUKFGFoIbg7nL/y/91qA1X1d4AjFirpdHV4MYe3qu5+NGdAn1UsJMOyElJifcgG8gCUIHBnLrrzimnAkx37w8HEPqLAO0BggmCRzEyToVHHULH3h2k5OL7tjEOgug8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvYekyH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvYekyH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B05C4CEF5;
	Tue, 11 Nov 2025 01:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825014;
	bh=5UHJc8xS4tpAvi/QwURSTz63A2mVm5VFxJYVnLkOGMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvYekyH1pce46s94t4wjUc4R/jMv+rnDQLxOA9rlatGfzgPb84aqNQThBj3o7iPSK
	 01OoeqA2JvRfN0tDppP5KcIGlmCIiev8+dmtIDC4bs3fqoq21mC0L0LPHQIusStHjH
	 Gk0uGWSPBgcvV/Mtug1BkJwg4sXHMMnIwbWr5uYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 525/565] sctp: Hold sock lock while iterating over address list
Date: Tue, 11 Nov 2025 09:46:21 +0900
Message-ID: <20251111004538.775434226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 95e65b9d623b3..5a43f25478d03 100644
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



