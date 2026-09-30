Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CA950E580;
	Wed, 30 Sep 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785623; cv=none; b=dey6YIugxtV5F6BqVMi0gA71WwvJKmq24d8l7dlbTkGzKIekap7s6G3SNmg6+hfBX8QAVNdd/PXOn2LjbmOY4ZhN9Tk6jWgoHhT3wvhRIr3eTVrsEaVgt7tkiWJCeRmVgycI3LHzkDaFibPrSDDYKhsOrERQWp0svv+y9ygt86c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785623; c=relaxed/simple;
	bh=8iHp3i82YtDeq1YW3ex2vkXQi3FvH05eMlVadMKPqQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0IG/TiNKs9wO6v6ELQ374yJLG2Pvt462ge1tW74u1v8HZFHOzvuZdNnKE9qtgg9mLEvBXVD4ym+w+W/ake3GUAwIimMv2ZbmgzVdcEH4+8OhaafdBgX4ygxDd6SoluW4XK7bI1OZ/+LpD2vrzF9MMNqG4XndHrDQqQXpcwSLbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DijDMpGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DijDMpGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD531F00898;
	Wed, 30 Sep 2026 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785611;
	bh=j0ZeqVh1Jz01TZzvQFzhuFd4QOYRw4ulIgSaxRWYjyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DijDMpGxQTGpwkVlI5RfaZejmKPv3WPX9/sHf7UYbJ+dcw3wsrmlAGTOCDYzjvJz5
	 fiIA0AYHkh5eHHCloRLLsJ8ze/b/2+zo2lshe6KzQtm8DfZs7Cv/Q7I5Lgyy8C709C
	 jDV10jiy/2l9JObexzhuwrf2V0xa4CkBlej5210Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 543/982] mptcp: syncookies: remember the request backup flag
Date: Wed, 30 Sep 2026 17:21:19 +0200
Message-ID: <20260930152428.434892354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


