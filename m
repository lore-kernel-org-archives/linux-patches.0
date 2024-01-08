Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB32A4BAA8;
	Mon,  8 Jan 2024 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2NvODrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5721C433C8;
	Mon,  8 Jan 2024 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726578;
	bh=xiJJbK7ggrwfeZmtyID9Oy+nxe53Q3x4pWC+wMzR58U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2NvODrqTz3f8rPizTRIfg3krqy6xBMZ7bS3uzvz/FrAoqIaPxU8ydif2eqnbvjfe
	 hs4gxIB6S/PiEHldE1rmR+byrYHO44K9iS4Whta7vT8Ph5srxyPjrSeIK1I4aU1evf
	 z5czSqaUYvVsxn9bgerYJRyRqVArBbRaebBTiAmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 012/124] cifs: cifs_chan_is_iface_active should be called with chan_lock held
Date: Mon,  8 Jan 2024 16:07:18 +0100
Message-ID: <20240108150603.544894710@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

commit 7257bcf3bdc785eabc4eef1f329a59815b032508 upstream.

cifs_chan_is_iface_active checks the channels of a session to see
if the associated iface is active. This should always happen
with chan_lock held. However, these two callers of this function
were missing this locking.

This change makes sure the function calls are protected with
proper locking.

Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
Fixes: fa1d0508bdd4 ("cifs: account for primary channel in the interface list")
Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    7 +++++--
 fs/smb/client/smb2ops.c |    7 ++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -209,10 +209,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(st
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
 		/* check if iface is still active */
-		if (!cifs_chan_is_iface_active(ses, server))
+		spin_lock(&ses->chan_lock);
+		if (!cifs_chan_is_iface_active(ses, server)) {
+			spin_unlock(&ses->chan_lock);
 			cifs_chan_update_iface(ses, server);
+			spin_lock(&ses->chan_lock);
+		}
 
-		spin_lock(&ses->chan_lock);
 		if (!mark_smb_session && cifs_chan_needs_reconnect(ses, server)) {
 			spin_unlock(&ses->chan_lock);
 			continue;
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -782,9 +782,14 @@ SMB3_request_interfaces(const unsigned i
 		goto out;
 
 	/* check if iface is still active */
+	spin_lock(&ses->chan_lock);
 	pserver = ses->chans[0].server;
-	if (pserver && !cifs_chan_is_iface_active(ses, pserver))
+	if (pserver && !cifs_chan_is_iface_active(ses, pserver)) {
+		spin_unlock(&ses->chan_lock);
 		cifs_chan_update_iface(ses, pserver);
+		spin_lock(&ses->chan_lock);
+	}
+	spin_unlock(&ses->chan_lock);
 
 out:
 	kfree(out_buf);


