Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481131D366;
	Wed, 30 Sep 2026 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791742; cv=none; b=HBKp3SGBAcqEElj8b6acZ1FcGWaGvvSVmYOdznV1pgZZjXjHaj3FBWLMpmJLbP2GbkaE4uwvAyn6hc+cIBhT+e9tbMQvPe/MUAkymFZ5i0+ZvOY7a5cQTxfFyM76KxbwFnk+d7ZTsTz++ZJQ9+9GgAEecOO4njQ0xn+pTDMN48c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791742; c=relaxed/simple;
	bh=FN9YlYrn01kvvlR2aNLAiteI2haA4ARnsOm7Iyezwbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YppbOWXQLZMdJYmvJPcL4INjhucaA7yOE/HO5nZsGivQdtQc1uBz8v+94u+NI5jN2aL0diIn4p/5aDhhZTVONa9oNcncm8HE2/HszFFw+NUjK8GMrPw4iUBFLribyiKWlYwjJWL/dn/tLuJdcMt7h/wDLXSvWRZWtiC0VqEnLeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Slt+BkhK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Slt+BkhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4941F000FF;
	Wed, 30 Sep 2026 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791741;
	bh=ElsJ1K0LtZoRpvphJQuzpskUcfs5Al9otLcrTN7/104=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Slt+BkhKHHhLdYUXvoQST7h1NoKdy2+8t2+QiFdBmtgmmdfNnknsLW2B4sgthI1ks
	 ImCCmCzH7w3uBh/8TD03g/nJWQ83pc1+HPMTyrxutGMZ3SzS4Shqty03AgVsWD6qmp
	 4MjE9UB1JYq/ASjHDlDg5u/LibDG7T1iAat2fRPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 407/752] mptcp: syncookies: remember the request backup flag
Date: Wed, 30 Sep 2026 17:24:37 +0200
Message-ID: <20260930152407.084828403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit b76c0e28b392620dfbaf92cdeedbf115820b44cb upstream.

Instead of using an uninitialised bit when copying the info in
subflow_ulp_clone().

To fix this, no need to extend the join_entry structure: backup is
coming from struct mptcp_subflow_request_sock, only one bit. Do the same
here by using one bit for both.

Fixes: efd340bf3d77 ("mptcp: distinguish rcv vs sent backup flag in requests")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-3-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/syncookies.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mptcp/syncookies.c
+++ b/net/mptcp/syncookies.c
@@ -26,7 +26,8 @@ struct join_entry {
 	u32 local_nonce;
 	u8 join_id;
 	u8 local_id;
-	u8 backup;
+	u8 backup:1,
+	   request_bkup:1;
 	u8 valid;
 };
 
@@ -63,6 +64,7 @@ static void mptcp_join_store_state(struc
 	entry->remote_nonce = subflow_req->remote_nonce;
 	entry->local_nonce = subflow_req->local_nonce;
 	entry->backup = subflow_req->backup;
+	entry->request_bkup = subflow_req->request_bkup;
 	entry->join_id = subflow_req->remote_id;
 	entry->local_id = subflow_req->local_id;
 	entry->valid = 1;
@@ -117,6 +119,7 @@ bool mptcp_token_join_cookie_init_state(
 	subflow_req->remote_nonce = e->remote_nonce;
 	subflow_req->local_nonce = e->local_nonce;
 	subflow_req->backup = e->backup;
+	subflow_req->request_bkup = e->request_bkup;
 	subflow_req->remote_id = e->join_id;
 	subflow_req->local_id = e->local_id;
 	subflow_req->token = e->token;


