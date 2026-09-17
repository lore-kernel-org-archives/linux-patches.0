Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD86274650;
	Thu, 17 Sep 2026 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660514; cv=none; b=BrbDFpIaoM97WA4lddHrp8tIIShBSblEHbfi3fkEZ6N/qrDVhm+i2G0XM3Vt1L8NQoGXcWkK5fRSCt5VYBEWOMqOko4mQONxsVgEznGe42x161ZqpByPqhC31ZRxza5E+OCIg8S3L+9aLW7Z/dRZSNMXC5qYvdY6vq+cYnb5dNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660514; c=relaxed/simple;
	bh=9N8Bso3JFPxIspGirAZxPa/VDO01Ba3CqLQD44P1sZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlk09QZ1HVAeJAAuG0K/JK4U2Q7W/N1CEp3/PfZLGMeLNKKQKdk7A+QZFhXjb7baWtz9hNRBwwX5zria1kQ+xT553gB0ukEZadlh30F+7WRWPd0nNWthRY+QvDEzsaXx+yDEH8hwCHBq6wPsCz1+VrhpcRk2WyMkJdeo2kp4NuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0mnOX8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0mnOX8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B741F000FF;
	Thu, 17 Sep 2026 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660512;
	bh=icj8S+51peWmWfaKn0ZLO3hUG2+Q4Mv9TiH7Tp9nVdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0mnOX8SQTuXGK1QrnlpdsUzxAO3dt+ejybCLRx29OeDuR+yrV8Cu+Z9NcvF+b7Hv
	 FHoVGJ9y1tUpNnU9JXY3Zpt0MLTkmM9dl7zmQUEPnEawnTnj4IDUDhCoGwZYsJcghl
	 gG7S6KOiUC8o+6ufW22hsDOuLVfTublLhsxN4giY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 615/733] mptcp: syncookies: remember the request backup flag
Date: Thu, 17 Sep 2026 16:15:23 +0100
Message-ID: <20260917151407.835115528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


