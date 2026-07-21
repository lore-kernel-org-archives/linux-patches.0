Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEEB35C6B3;
	Tue, 21 Jul 2026 21:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670774; cv=none; b=EC7og7GJs5CFcX8RaFG7B49dxZeAZrCoQRgPvs7FYKj1yjamoUdVfAZunWDIRXAVubMCclhALKr9sOHB2LdNgk4fU03IboC+vJmOs+B40K5t6CskyjguM5ybHtogCcBXydqh61JnGnnq+e1tPtBO156ONMB5aEpxSQfjbWIWs7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670774; c=relaxed/simple;
	bh=JWl9cx9E8fhInoDDJ3lJThegzgaN7ByIZrRlOXp/D7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4r0lGefum7naetZRE+Nj9wkhVY7iRZXOPntuESZGIRDWuh6fcU/ORWY0fAiy1zktaHIh/nv86Cih8//IEEogCn1MBLCbPA9kYAP1ZI23aNIsO4Sg4RBaUt7tv+1RW9hUD8jlDpNALts6L7YkR3ZKEX5rpdLaCiA1HH+1Wl4Ya4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zmubh4XB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zmubh4XB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20EA1F000E9;
	Tue, 21 Jul 2026 21:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670773;
	bh=PhTpcYM6LLBTEe1xOTkSy1Ub6PmSTBWYmFfLsgm9MsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zmubh4XBCENMevdURIMAuTpZNLVZjNo/prC7chEM/AkvLOGHQP11aKmn96eKqh4Yy
	 u8pM3mFdPrHmW4HRDOz5Ppt99HH2ZjuWa8ran+yXTrihYuH7JfFFlfk4KJMpYCgaep
	 NhoiOlZzeL0th0ANVykK14ZGAUPefdDOpFDM65FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 1058/1067] cifs: fix lock ordering while disabling multichannel
Date: Tue, 21 Jul 2026 17:27:39 +0200
Message-ID: <20260721152448.253793660@linuxfoundation.org>
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

commit 5eef12c4e3230f2025dc46ad8c4a3bc19978e5d7 upstream.

The code to handle the case of server disabling multichannel
was picking iface_lock with chan_lock held. This goes against
the lock ordering rules, as iface_lock is a higher order lock
(even if it isn't so obvious).

This change fixes the lock ordering by doing the following in
that order for each secondary channel:
1. store iface and server pointers in local variable
2. remove references to iface and server in channels
3. unlock chan_lock
4. lock iface_lock
5. dec ref count for iface
6. unlock iface_lock
7. dec ref count for server
8. lock chan_lock again

Since this function can only be called in smb2_reconnect, and
that cannot be called by two parallel processes, we should not
have races due to dropping chan_lock between steps 3 and 8.

Fixes: ee1d21794e55 ("cifs: handle when server stops supporting multichannel")
Reported-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -303,28 +303,32 @@ cifs_disable_secondary_channels(struct c
 		iface = ses->chans[i].iface;
 		server = ses->chans[i].server;
 
+		/*
+		 * remove these references first, since we need to unlock
+		 * the chan_lock here, since iface_lock is a higher lock
+		 */
+		ses->chans[i].iface = NULL;
+		ses->chans[i].server = NULL;
+		spin_unlock(&ses->chan_lock);
+
 		if (iface) {
 			spin_lock(&ses->iface_lock);
 			kref_put(&iface->refcount, release_iface);
-			ses->chans[i].iface = NULL;
 			iface->num_channels--;
 			if (iface->weight_fulfilled)
 				iface->weight_fulfilled--;
 			spin_unlock(&ses->iface_lock);
 		}
 
-		spin_unlock(&ses->chan_lock);
-		if (server && !server->terminate) {
-			server->terminate = true;
-			cifs_signal_cifsd_for_reconnect(server, false);
-		}
-		spin_lock(&ses->chan_lock);
-
 		if (server) {
-			ses->chans[i].server = NULL;
+			if (!server->terminate) {
+				server->terminate = true;
+				cifs_signal_cifsd_for_reconnect(server, false);
+			}
 			cifs_put_tcp_session(server, false);
 		}
 
+		spin_lock(&ses->chan_lock);
 	}
 
 done:


