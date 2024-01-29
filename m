Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6331273748;
	Mon, 29 Jan 2024 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548543; cv=none; b=IuuOpBas/0aiM709WiCNEmNZXXBZDf+BgYjBhfEizErnaA6QmI9t0ikTHFwtgQE7GWpZYnb0FTbekKB4WI+viQmOsgtI6IiosJLNxicC+Db14ZX0Q0BGiiIddLgfL+SmOa0iswHSKC1FAVHMSwGuSYjcmUSYNcbXSWX9R1S2rHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548543; c=relaxed/simple;
	bh=GfVrHMERLr/v5madS4hNMGRgMUYeU3eBSlwpnon1Wnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqDfP83r/2ZI27/Z2olTCJ9dWg3xOmk3PO7DdbUE3h2aSf2yOV1lFA20xN1boRtxgzUFiXHCsM4y9GMnJ/i/VbSJa3xEjbSoHxb++CktGFwmJk4tNDhaI73zdbMuLTM4bcTXnq+FWK8MvBTtWinnI48CQjeRnKcbgZ1e5mDOtxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddJLhmia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddJLhmia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D634C433C7;
	Mon, 29 Jan 2024 17:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548543;
	bh=GfVrHMERLr/v5madS4hNMGRgMUYeU3eBSlwpnon1Wnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddJLhmiaoUQ/wmkIsRdDf8zOjc8ZO5qbX/fUE2BK9O5yitOJBMXX02EptVJCgLWN0
	 W5h5JHXNkNzv/+QcLZHy1HLrAtX3W1vR2idFtM2ILD4BzQblFzSOVWDdAQGHv/ImgV
	 P9rJOmqf8l62n1C2hxDwJ4q3H/I22ScR3nRpmvOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 166/331] cifs: after disabling multichannel, mark tcon for reconnect
Date: Mon, 29 Jan 2024 09:03:50 -0800
Message-ID: <20240129170019.780116532@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

commit 27e1fd343f80168ff456785c2443136b6b7ca3cc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -212,17 +212,21 @@ cifs_mark_tcp_ses_conns_for_reconnect(st
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 
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
 		/* check if iface is still active */
 		spin_lock(&ses->chan_lock);
 		if (!cifs_chan_is_iface_active(ses, server)) {


