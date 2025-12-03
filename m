Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9526C315D47;
	Wed,  3 Dec 2025 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776531; cv=none; b=rCe5ML/1iVxLlZYxnBslzTrIAOwh+5WonObZSndhbTvOZLGr875rXe7lMmvhPZ4Qe8gkGufF7sH/PDPG+L9bCWZMz3lJ6NuktxdOhwt8D9YHLVwTVel4WnHZms+to+V4mis/KkLeMD5XNl2bUv+/3KOK8GRT2Wi7+VWZQXnmUhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776531; c=relaxed/simple;
	bh=9EsmEcOmkMKes6HKHi55lz/txN8t73sCgE+kRcXGcYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izH0JIXAM5Au3VwFqBjZauJFhbqEep8Q38zEpVAzm9wciAtYAuDd5B0vIC2AgSysoBEhoQjuODtaEbUtvIVX/KkpgpNGuXUwwmv1rVzRHHsqOnKLrwVogdqUTCY68PDJTHMXikG822fflUd+01khEs6Df0vxnJbO8n9EBnTznVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1NrItgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1NrItgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D29C4CEF5;
	Wed,  3 Dec 2025 15:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776531;
	bh=9EsmEcOmkMKes6HKHi55lz/txN8t73sCgE+kRcXGcYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1NrItgbOJkjjvIXAoxJAiucDpALdheYGcgHPNobJu74ODqFjjonRPdEz2vBRiB9V
	 7CkVedfcIoAKGyU+y+nVucmhAokkiRb9CLLdC0DL39yLjlmpwwwUFrJJVdk2nHJXd7
	 pImcA4Ss+7vQPkVTewTtApibip0iUk4ek4z20Br8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/300] sctp: Hold sock lock while iterating over address list
Date: Wed,  3 Dec 2025 16:26:12 +0100
Message-ID: <20251203152406.844665359@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



