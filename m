Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A438D21D3DD;
	Mon, 23 Jun 2025 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714899; cv=none; b=cVqtGZHhDg0xv3EGFSGKO6bLd2vNSI10kli5A5FimgnXF9ZAKDtt8LHpYAolH9ViiDrGEZvOb9Pre4d2YwBaqq5j9/s0OQfv/kgVU/xEtTHEKVw0d3SFPV94kvL782+jGd0MMqph4djSmuHPytfpxXl/t/GGfz+dJ4JckNX466A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714899; c=relaxed/simple;
	bh=nflgTGHayodM3S76F3G7dDw9DDRbOOjiIPfJdplUi+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp7Y68WVj+qSYJc2X/Pxx6fi4mW0yltfn+Jp5tNKAruD0CQcGj6Uhdgv3LhpECCYWlxz/8XpQoHZp4Es8QOjPwfVBKAqQqFTzKxRVjy0Ig8n8hzwgpaO7VjKvTSB1ZUSm0YsyrSYmAvtNSxxYHLMPA37i6gkunAt17n8O+9NPRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1V7p/tra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1V7p/tra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC37C4CEED;
	Mon, 23 Jun 2025 21:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714899;
	bh=nflgTGHayodM3S76F3G7dDw9DDRbOOjiIPfJdplUi+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1V7p/tracVUEd6QHQ2emIZhlZCIrxSQk7SqWFswai+jo0iy1IWiNey91wtFC/PbAE
	 M9HhpfPMhX/IbJmjGd6SQkECk0EhlWo3va6hQJl83z5f1Qc+hA0BMPl2h6kNNde1Vl
	 CRA6X+Bp8YIGlx3+UUTMDV5rGKB8Kckg2zq2WFtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 143/414] cifs: reset connections for all channels when reconnect requested
Date: Mon, 23 Jun 2025 15:04:40 +0200
Message-ID: <20250623130645.630229846@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


