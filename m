Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDC035C6B3;
	Tue, 21 Jul 2026 21:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670599; cv=none; b=QAtnxDNdc/EdCkmVtoEFzpFp07r4wlIUSzm+2hvElFDFHQdYt+XVIQoeyb0Sg942GQjKZIcn2EWEOadGqjTmHA/PfJYAngc19OyaInMiWvUa+Pc1Ih/7srB/Sp5JxeDoc7N1PSDehJ3yrALR92ILVdsqvHC0yfG+wls8UpUx284=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670599; c=relaxed/simple;
	bh=ZaqRvXMcchgZkY32AjcrbHOE2Ne6rl0vbR9oC+TxC5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foISLz8/zFz4NY2MfiPnHrrDxpayBWarnPNzt6n4ZdheLi9G/LNG5q94ZACjsxlC000yxpqMvAFaazxk3XY4WnlBCUlJwg6zpBVD275t9NInOIob5kQZD4GwgnZeGHKlz/Ck5JnHExEXGvpMVd8jgO1z9Jf4WAq6+wtIB1f56PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3U/OEzK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3U/OEzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422361F000E9;
	Tue, 21 Jul 2026 21:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670597;
	bh=D6xEKu0HaKnMDHlkTNRB506JqURCd6n9FYPS/LxzsYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3U/OEzK+rLeLyMy9C9koNwnn8GLw2Aqh1OwrEfYQj2uIG1cbrv9+L+Q0yzj+D8nr
	 ga3CgBktrnkUZBblifUrqp6UAD0eBXVwpC0mAV/NarAmDVb2FTA4TeKSLd+MzfFk6c
	 Pth1yzJOVOAARd0TsMs0vrRaZIXCCAl07CxA+phM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0994/1067] cifs: after disabling multichannel, mark tcon for reconnect
Date: Tue, 21 Jul 2026 17:26:35 +0200
Message-ID: <20260721152446.796241128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 27e1fd343f80168ff456785c2443136b6b7ca3cc ]

Once the server disables multichannel for an active multichannel
session, on the following reconnect, the client would reduce
the number of channels to 1. However, it could be the case that
the tree connect was active on one of these disabled channels.
This results in an unrecoverable state.

This change fixes that by making sure that whenever a channel
is being terminated, the session and tcon are marked for
reconnect too. This could mean a few redundant tree connect
calls to the server, but considering that this is not a frequent
event, we should be okay.

Fixes: ee1d21794e55 ("cifs: handle when server stops supporting multichannel")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: ec457f9afe5a ("smb: client: resolve SWN tcon from live registrations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -256,17 +256,21 @@ cifs_mark_tcp_ses_conns_for_reconnect(st
 	/* If server is a channel, select the primary channel */
 	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
 
+	/*
+	 * if the server has been marked for termination, there is a
+	 * chance that the remaining channels all need reconnect. To be
+	 * on the safer side, mark the session and trees for reconnect
+	 * for this scenario. This might cause a few redundant session
+	 * setup and tree connect requests, but it is better than not doing
+	 * a tree connect when needed, and all following requests failing
+	 */
+	if (server->terminate) {
+		mark_smb_session = true;
+		server = pserver;
+	}
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
-		/*
-		 * if channel has been marked for termination, nothing to do
-		 * for the channel. in fact, we cannot find the channel for the
-		 * server. So safe to exit here
-		 */
-		if (server->terminate)
-			break;
-
 		spin_lock(&ses->ses_lock);
 		if (ses->ses_status == SES_EXITING) {
 			spin_unlock(&ses->ses_lock);


