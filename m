Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B767F1E51FA;
	Mon, 23 Jun 2025 21:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713898; cv=none; b=o5sIDiqsW0uCNwJRPk4QXeGCcaqFCG5rwgZvb4YcMykD3cwmraYKAiTLamrAyJu+6WdbLcOt6ol4vTa0diogEIYDAzPUg9VzUpobJoDgmuAKOWCaDva3NavURfNfxFuYe6DFH7pqJtDswD5CnegZcbw9WlHjwE5OWVBlQX5FWjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713898; c=relaxed/simple;
	bh=SEPm7Yy7JCCd8Jg5NmteQFqx2syMuTSXfATI7ug3meU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atG55RAuJqoXCqn7R7jCKWiPby69ootN3nPxauzRAlH+ABSvPtwBTylXmRmUzyAJNlGOuytI/HajCAR6kmWVKYtC3oltU4oD4bTZrNUOfjyHze79XAq8rhkT8iV67zKi8lksRkJ+Yw8JkXND50edChuekWkaAk6ryvYP3bS7MQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwtpDFph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwtpDFph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C85FC4CEEA;
	Mon, 23 Jun 2025 21:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713898;
	bh=SEPm7Yy7JCCd8Jg5NmteQFqx2syMuTSXfATI7ug3meU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwtpDFphtKBszEUCNsgH5HDWSC94cjK9ZF8+Y3fWjKFHipImpKqfm4YLSZKSEs2UW
	 8JNIcvDDK5KUksSUZ1cvjh3y4bQD+1lIWoiH0LslnMSZtv0Wslh8uAALkarCcsmnFW
	 wptkHs/BZTW0YuTBFinBPgUwUHg4fAYK9uGzIyT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 102/290] cifs: reset connections for all channels when reconnect requested
Date: Mon, 23 Jun 2025 15:06:03 +0200
Message-ID: <20250623130630.030514398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 1f396b9bfe39aaf55ea74a7005806164b236653d upstream.

cifs_reconnect can be called with a flag to mark the session as needing
reconnect too. When this is done, we expect the connections of all
channels to be reconnected too, which is not happening today.

Without doing this, we have seen bad things happen when primary and
secondary channels are connected to different servers (in case of cloud
services like Azure Files SMB).

This change would force all connections to reconnect as well, not just
the sessions and tcons.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -393,6 +393,13 @@ static int __cifs_reconnect(struct TCP_S
 	if (!cifs_tcp_ses_needs_reconnect(server, 1))
 		return 0;
 
+	/*
+	 * if smb session has been marked for reconnect, also reconnect all
+	 * connections. This way, the other connections do not end up bad.
+	 */
+	if (mark_smb_session)
+		cifs_signal_cifsd_for_reconnect(server, mark_smb_session);
+
 	cifs_mark_tcp_ses_conns_for_reconnect(server, mark_smb_session);
 
 	cifs_abort_connection(server);


