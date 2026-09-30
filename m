Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70814BD786;
	Wed, 30 Sep 2026 15:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783211; cv=none; b=CF7s/1cVfk08rZi8QgbpJ5lOhvzZ+rBW+xSpCojVNKQhVHqxqrfNDFJCzu95bxfeDM4BhkuLZCUuww9pEI/i22M82knnMQl+idEVAkcKp9KViB/XdQp55Zr0ocTQSKglX/uXCOkAjimcLUfz/ZICaeQH/15pfV2f+NWxTSE4oic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783211; c=relaxed/simple;
	bh=N/f9jYa9AwxA9NjI8gf5t9l1e6kaD941Dj8hCLWKPUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOrKQn4ijsZ6NBvnEDnwAzYUuVEnGoyfalYoexXYnQr9/jRq1eR86f8M41yl4GkSb1bIrGn8FVrYD+OiypSK81jS3mhm+cBW1j2v2yRoN9pwJy5VJmTAqbOd1+YgqOM+AndWXK1h1BioDWK1RLdcDeOYfkinPRghj5XPdXBkeUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/ssaI7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/ssaI7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66351F00899;
	Wed, 30 Sep 2026 15:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783208;
	bh=gryYb4gTUy46kQZupukZXGl5qk/4l/R/P/9aDZBmgnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/ssaI7KQzJwmAYp9DKaL9uPvTDuSUFvfWMpmcO72aVWWzQmuDvHXf+ExeTWwDC0v
	 bfjrYgVin6kHat/4g+mi9819hth3sTEU9KjrqCt7mRVEFmw68Dg5KihMGJPNNr+JmG
	 yhgb+1fUMzECbsnbCQ1U1K1chOJObAlVZsLB1j+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 319/595] mptcp: syncookies: remember the request backup flag
Date: Wed, 30 Sep 2026 17:23:32 +0200
Message-ID: <20260930152354.548852778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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


