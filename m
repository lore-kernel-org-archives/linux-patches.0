Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EA14BA1F4;
	Thu, 17 Sep 2026 17:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666546; cv=none; b=ev/KgFXZMpzqjjZojtsUiVTMrMTODaGftMI875Hc3otQo3S9Ejy+l/FojRz3iSPSfd7kijX51HWvtVnA/uD8F2VeKr4bB87f6kw5rsHbcFjBP3SyVq1+Do3S/e8gtLFOktm4JObflGJ29bFhR7iUXUe0W8h4+Ggw8HEfj816nFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666546; c=relaxed/simple;
	bh=x5jLzCD8BdBOVpXGmOAmhxtMe3Bd10fMIiZ5NeXoKD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRnyayxL6SN2ZPKD1Q24TUzEjPnuyi95/A/Ch1lL1s76IdK7uqVxyhHQxl8EjocZJ2QPcQBNa7uGI5LvbQJSeefTF5GuCSE7eRhXAQsnHXcHpVgHB9F1vNmbpsO5eUvbyX0HB42cN860RMaXBpFlL0/ELwDtDMDtMICB+9bi0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsXxHQCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsXxHQCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF42A1F00893;
	Thu, 17 Sep 2026 17:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666545;
	bh=ONsRlfqOH553s4YrzBOmQb9iBx4/Z4KjO2AdruiNyC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsXxHQCiJOvwQaJUCUWGq4uas/gNXa4pPpl81yg97qk32wmc9ueApnyDThDGv/tGb
	 qz7nK0FTMfPh8E3I2/BfI3pVK42YPaagxn7jdMBSMjZT/GdNNMVNs72zCiWS3TekU9
	 mJEtn6jpdzErsCzRzIhFeYgTVddhxrP2qT4U6M8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1074/1250] mptcp: syncookies: remember the request backup flag
Date: Thu, 17 Sep 2026 16:14:29 +0100
Message-ID: <20260917151621.249570354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


