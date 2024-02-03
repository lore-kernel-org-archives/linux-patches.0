Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3015710A13;
	Sat,  3 Feb 2024 04:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933765; cv=none; b=jT2tWYdMivWjG2D/R0PRx7eGkgo6q926FKwHMuzsNAYVcgkzV/BcUmDiXUCib7aqvDBwv++6J8lchel59ZfDv6ybVpSL6H9HswCkpGg6zQFeAqRiqg9bRx9JkwQDL4CwxM3vTgSs4jnyumr/Ut7nO63t1fMdeAsMbMzKyeYOZws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933765; c=relaxed/simple;
	bh=wEaJKdRQRdt1Gee4UfBpm8ep8ZYPjpDo01ibyThE5Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXARvdLgMev9LKitFjR0gR0603WVcN1MQBLWiWQ/y/APFxTO+8UBZ7WBg2QtHpJllaaPSQ2dT3hxbRxvueo2jMmV6JMYR+LTvo9cD9iQVJuTMOFc8BEwenomIpUB9vojYd4opKL5QniI0uuPHjdCpA2VLG1vhGNb19TWYZ6tpo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ7zxGuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ7zxGuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3E3C433C7;
	Sat,  3 Feb 2024 04:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933765;
	bh=wEaJKdRQRdt1Gee4UfBpm8ep8ZYPjpDo01ibyThE5Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZ7zxGuMJULTIU18NJeIjueLdUqAfCXwuwu8vmljCtPATXnZTfQUIA94FaVqV1KWH
	 7S12XtGUska7zIOVztXY9DM/r/m+BRnZfyvJQYru2LOZ4/iCBKnLiVbcUEODeIUfKk
	 ciuHAm4l/rHdg0Jh5UbCFzfbz/d3N3dk1Mg7PZnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 057/353] cifs: fix in logging in cifs_chan_update_iface
Date: Fri,  2 Feb 2024 20:02:55 -0800
Message-ID: <20240203035405.604946319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

[ Upstream commit 516eea97f92f1e7271f20835cfe9e73774b0f8cc ]

Recently, cifs_chan_update_iface was modified to not
remove an iface if a suitable replacement was not found.
With that, there were two conditionals that were exactly
the same. This change removes that extra condition check.

Also, fixed a logging in the same function to indicate
the correct message.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 2d3b332a79a1..a16e175731eb 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -440,8 +440,14 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	}
 
 	if (!iface) {
-		cifs_dbg(FYI, "unable to get the interface matching: %pIS\n",
-			 &ss);
+		if (!chan_index)
+			cifs_dbg(FYI, "unable to get the interface matching: %pIS\n",
+				 &ss);
+		else {
+			cifs_dbg(FYI, "unable to find another interface to replace: %pIS\n",
+				 &old_iface->sockaddr);
+		}
+
 		spin_unlock(&ses->iface_lock);
 		return 0;
 	}
@@ -459,10 +465,6 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		iface->weight_fulfilled++;
 
 		kref_put(&old_iface->refcount, release_iface);
-	} else if (old_iface) {
-		/* if a new candidate is not found, keep things as is */
-		cifs_dbg(FYI, "could not replace iface: %pIS\n",
-			 &old_iface->sockaddr);
 	} else if (!chan_index) {
 		/* special case: update interface for primary channel */
 		if (iface) {
-- 
2.43.0



