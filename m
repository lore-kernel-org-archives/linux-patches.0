Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E00A35B632;
	Fri,  4 Sep 2026 06:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502412; cv=none; b=Wt7Aif5/lTo5gc/NzkaZ+L6n/fwRnbwzfPfmBA1R49hw/t2OZXfvlsoA5jE63W6shB2v1DyWTfYe/+8dw7vB3sPos/ifryHiAjJDQb/LuvaX3RuevnrbDsmQhpyeyIR/F223+LcuDn9E3TdbqpuJTCAjlGyb89KuL6AoJsNHvhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502412; c=relaxed/simple;
	bh=Y2NDTbD46EOucbZn77ART7hCFZMtxlXNWYi+PKU9UhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWDfE/c8Bk3NErrfvPMOJihgvZRnMSu5obKxkjB5OkbPY/I5jv/CuNrWmkf1NmQOYDPlLReP/Z+tG+S0oHcpKohl2PQeqPfmfAgK8QFUYjCM5tU8rHeyiHVJzc9Ih3BGa8C1pBSauxM6HPEGVVMil+lwRhoH8XB72zTAx/EV6x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lG1xQJo7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lG1xQJo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A655E1F00A3D;
	Fri,  4 Sep 2026 06:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502411;
	bh=8JL3MXMj+328uj8v5BiZ7MXA/dAtt92MAqEi0IXzOrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lG1xQJo78Gx87RaRrKww2FURrHT1QPBV/MifH/SUt5jJhFV015CVy3zY2YbuxV9jD
	 2/pkAj1YtamaSNoWD5sban34tVQ2ha0c9EvcBY9Ukq3/rk5ZtpHV+PgJJrs7i05WWj
	 +wySwn2ULrEAsrboSyV/30wW/dAQVwBcp3ebeE5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Varu <harshitvaru666@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 198/403] mptcp: fix uninitialized local_id in syncookie MP_JOIN reconstruction
Date: Fri,  4 Sep 2026 07:00:01 +0200
Message-ID: <20260904045739.357163657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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


