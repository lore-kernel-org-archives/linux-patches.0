Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D3C3FD956;
	Sat, 12 Sep 2026 17:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232906; cv=none; b=oRFSj/4eoeOBHkpz07jwEUJRHC9JZOuIRFJ5GIjdWOWFSjb1mc8DqwgeiRAjOQyRb9CbR7d11oVhn5S+xGSkcDdEH4h9Lav1MNbS7803GTde2AtnR5nw5Ix9yTib0f1bLfquvOpsR+xhyrVL2Uu7y5I4jkXW+SpI2zqNNPRGa9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232906; c=relaxed/simple;
	bh=WLAEdU7SPqc755UuAJnxlDvDo/vCkitfzbNm2AcziK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+nb2I38UAE85VS6hmhXEY3eiDSa6jyubNsiZD3z1oTKmB6teq7EIV1CEAGpkQySDrtxnYn7GoZ5t+NW+YxuDA15dfAlNLX5QS/Fwun3hOcJ6IctpjJa//HuYw7CSLogjFqCGWgTC+qM5ftczItiDqFbVMYxUFLewehz1dkAkyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R08Gkr1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R08Gkr1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D614D1F000FF;
	Sat, 12 Sep 2026 17:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232905;
	bh=eueAruCu4iPJwcpk60kWNDATmg4/AevEw7hcfKnN29w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R08Gkr1tF4G8zySe7uZ5U76PyAZd3xOi6USeFgPmf/iZQd5mEf50pBsXXMBdKd3uQ
	 Fba3IidCcQ4XbgBz3+pMmx9UpazRn163yNR/3siBdtQSoON5x5jKezWjVn/ycCO33E
	 Plgck5xNsiFjl7ugGzErdYkCQCYPiMDrLnYKr5qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Varu <harshitvaru666@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 105/935] mptcp: fix uninitialized local_id in syncookie MP_JOIN reconstruction
Date: Sat, 12 Sep 2026 08:52:15 +0200
Message-ID: <20260912065529.228475151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Harshit Varu <harshitvaru666@gmail.com>

commit b878dfdd12d7a5b8722a78d35e313506140ca3d9 upstream.

mptcp_token_join_cookie_init_state() restores remote_nonce, local_nonce,
backup, join_id, token and msk from the saved cookie entry when rebuilding
the request socket for a MP_JOIN 4th-ACK handled under SYN cookies, but it
does not restore local_id, even though the SYN path saved it.
subflow_ulp_clone() then reads that uninitialized field and stores it as
the joined subflow's address-ID. Because the request-sock slab is
SLAB_TYPESAFE_BY_RCU and not zeroed on allocation, the value is the stale
byte of a previously freed request socket, which an off-path peer can
influence by sending concurrent MP_JOIN SYNs. This corrupts the path
manager's id-based subflow bookkeeping for the connection.

Restore subflow_req->local_id from the cookie entry, as done for the other
fields.

Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
Cc: stable@vger.kernel.org
Signed-off-by: Harshit Varu <harshitvaru666@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260815115205.197151-1-harshitvaru666@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/syncookies.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/syncookies.c
+++ b/net/mptcp/syncookies.c
@@ -118,6 +118,7 @@ bool mptcp_token_join_cookie_init_state(
 	subflow_req->local_nonce = e->local_nonce;
 	subflow_req->backup = e->backup;
 	subflow_req->remote_id = e->join_id;
+	subflow_req->local_id = e->local_id;
 	subflow_req->token = e->token;
 	subflow_req->msk = msk;
 	spin_unlock_bh(&join_entry_locks[i]);


