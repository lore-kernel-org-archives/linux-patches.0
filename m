Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0F4778C;
	Mon,  1 Apr 2024 16:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989803; cv=none; b=kxY+UtGypg29wOvr8BxSreOdNDK2IMWxlOl1ijDzG4KIjWO2MIrm4RxUwa83TFiVfcUx7GPOgluUlLqx3gNoDSdo+3XQdjZrIsTn/1me9GYaulq+7mN+1zqHF7fe7CkJ9uo/+2wUjW0K7/jN5vZBx058SuLvIkLzO4+H7AyKjJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989803; c=relaxed/simple;
	bh=z5dRyQWJORI2WSUFJcgit4Y43zhaXVt/NILtsyY30BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHEd/PosyGT+domzVJqxzKC5aHiDHHxwkJQLr/jDDVeSCJ8M+KPj5oDY9K1wuguP12UEjks3kmIbRjiuRYKQVLqDEE3abIrDuo9mduhpgiQiX/uh3fbsPfSyIWn4P8JSQ0dlzJTzTwXEPNepDJdSwOPJHMRvjFjZAI8KV4/wbE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLsZilmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLsZilmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465F8C433F1;
	Mon,  1 Apr 2024 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989802;
	bh=z5dRyQWJORI2WSUFJcgit4Y43zhaXVt/NILtsyY30BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLsZilmHFQL0C3n3bFFvH4bxDrsNTwpY6GHvUk8HbFGXpnyna6Diu/P5L3X4ntGnU
	 /+/BNQwi93CeMKr7A11ZoDmvp/8KwjWxJprSa4InxtXtp56s1ALg9qsLXjDB+kOA3K
	 p3frEzjEngEbdlYNcVRYFvebSJMW68ZuKXjsnCEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/396] cifs: do not let cifs_chan_update_iface deallocate channels
Date: Mon,  1 Apr 2024 17:43:27 +0200
Message-ID: <20240401152552.654117978@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

[ Upstream commit 12d1e301bdfd1f2e2f371432dedef7cce8f01c4a ]

cifs_chan_update_iface is meant to check and update the server
interface used for a channel when the existing server interface
is no longer available.

So far, this handler had the code to remove an interface entry
even if a new candidate interface is not available. Allowing
this leads to several corner cases to handle.

This change makes the logic much simpler by not deallocating
the current channel interface entry if a new interface is not
found to replace it with.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 16a57d768111 ("cifs: reduce warning log level for server not advertising interfaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 50 +++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 2fc2fbb260bf0..0d76757528e49 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -438,7 +438,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		cifs_dbg(FYI, "unable to find a suitable iface\n");
 	}
 
-	if (!chan_index && !iface) {
+	if (!iface) {
 		cifs_dbg(FYI, "unable to get the interface matching: %pIS\n",
 			 &ss);
 		spin_unlock(&ses->iface_lock);
@@ -446,7 +446,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	}
 
 	/* now drop the ref to the current iface */
-	if (old_iface && iface) {
+	if (old_iface) {
 		cifs_dbg(FYI, "replacing iface: %pIS with %pIS\n",
 			 &old_iface->sockaddr,
 			 &iface->sockaddr);
@@ -459,44 +459,32 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 		kref_put(&old_iface->refcount, release_iface);
 	} else if (old_iface) {
-		cifs_dbg(FYI, "releasing ref to iface: %pIS\n",
+		/* if a new candidate is not found, keep things as is */
+		cifs_dbg(FYI, "could not replace iface: %pIS\n",
 			 &old_iface->sockaddr);
-
-		old_iface->num_channels--;
-		if (old_iface->weight_fulfilled)
-			old_iface->weight_fulfilled--;
-
-		kref_put(&old_iface->refcount, release_iface);
 	} else if (!chan_index) {
 		/* special case: update interface for primary channel */
-		cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
-			 &iface->sockaddr);
-		iface->num_channels++;
-		iface->weight_fulfilled++;
-	} else {
-		WARN_ON(!iface);
-		cifs_dbg(FYI, "adding new iface: %pIS\n", &iface->sockaddr);
+		if (iface) {
+			cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
+				 &iface->sockaddr);
+			iface->num_channels++;
+			iface->weight_fulfilled++;
+		}
 	}
 	spin_unlock(&ses->iface_lock);
 
-	spin_lock(&ses->chan_lock);
-	chan_index = cifs_ses_get_chan_index(ses, server);
-	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+	if (iface) {
+		spin_lock(&ses->chan_lock);
+		chan_index = cifs_ses_get_chan_index(ses, server);
+		if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+			spin_unlock(&ses->chan_lock);
+			return 0;
+		}
+
+		ses->chans[chan_index].iface = iface;
 		spin_unlock(&ses->chan_lock);
-		return 0;
 	}
 
-	ses->chans[chan_index].iface = iface;
-
-	/* No iface is found. if secondary chan, drop connection */
-	if (!iface && SERVER_IS_CHAN(server))
-		ses->chans[chan_index].server = NULL;
-
-	spin_unlock(&ses->chan_lock);
-
-	if (!iface && SERVER_IS_CHAN(server))
-		cifs_put_tcp_session(server, false);
-
 	return rc;
 }
 
-- 
2.43.0



