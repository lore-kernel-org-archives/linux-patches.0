Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF52513AA2F;
	Tue, 27 Feb 2024 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040849; cv=none; b=CHUPbhOE0Jda9w92OlQbj2I3ntFDdMB4ZfucU28snpEy8FPxPshUcFvmt6/o2jMcryd5hkUt+iFdIO534d8pK/vSjDPh3mYbTzDNBbZ/YHqFAWC3Ur01lcYglqD2LTNXKi5XC2fJYWC/K/jGy6sAARW4kKrzo55AfQdXnmMKAJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040849; c=relaxed/simple;
	bh=BzDjy2fSjXFvXPSkxhDRomyvOqjSA32lZqu5gfTJFQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfMU0KGEViVwFJAJ7LDNEyD/zG5s1VfQ2J3SkszklEbQVOpo4H3iYnakFNyTeR/l8iGuEI84W+0nvp40lkz2BRD7ZdXuY1M8H/60StxLBnzm9vWOhrtj22YW5tfV3m7CEul8+jEDvnq8cxUhEAek8ranKAEn1V1tzPRMrfB6vC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjQe8FKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjQe8FKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7B1C433C7;
	Tue, 27 Feb 2024 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040848;
	bh=BzDjy2fSjXFvXPSkxhDRomyvOqjSA32lZqu5gfTJFQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjQe8FKXUDoC19R6Z7iniATjHQkYAiqeH99dlcSDya3LFlYzNDT18KWKX0JtzFzCZ
	 PVHiilzp7ga17QLrSvK/oMfZjokMf6OdAc/foxruIcZDnoJQrpK1RNafKJpDrz+jt6
	 T7d88FA3gPSpLv0P4G+rjgVVlc8HDzOKulj5IA5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 131/334] cifs: handle cases where multiple sessions share connection
Date: Tue, 27 Feb 2024 14:19:49 +0100
Message-ID: <20240227131634.688663995@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit a39c757bf0596b17482a507f31c3ef0af0d1d2b4 ]

Based on our implementation of multichannel, it is entirely
possible that a server struct may not be found in any channel
of an SMB session.

In such cases, we should be prepared to move on and search for
the server struct in the next session.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 6 ++++++
 fs/smb/client/sess.c    | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 35fe70b872b57..c3d805ecb7f11 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -233,6 +233,12 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
 		/* check if iface is still active */
 		spin_lock(&ses->chan_lock);
+		if (cifs_ses_get_chan_index(ses, server) ==
+		    CIFS_INVAL_CHAN_INDEX) {
+			spin_unlock(&ses->chan_lock);
+			continue;
+		}
+
 		if (!cifs_chan_is_iface_active(ses, server)) {
 			spin_unlock(&ses->chan_lock);
 			cifs_chan_update_iface(ses, server);
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 3b07f54a8567a..9415bcda1d2c6 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -88,7 +88,6 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
 	if (server)
 		cifs_dbg(VFS, "unable to get chan index for server: 0x%llx",
 			 server->conn_id);
-	WARN_ON(1);
 	return CIFS_INVAL_CHAN_INDEX;
 }
 
-- 
2.43.0



