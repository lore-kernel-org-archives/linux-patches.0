Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C0E4315A;
	Mon, 23 Jun 2025 21:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714934; cv=none; b=dbyTW2A6NzPGywopMqbtV8Z9J/kcHzO/Eqd9tOXTUsjnMG+cze/Nlmsha0bPX/qDltGNUT6A9ZP5LgOH9rAJ1mCeXczRb9hrR7QTOPkGJYCYcNttFTC4W2+YmRsacVRWa11CewvGQm68ObeJqZw8JVhJx0yL2UGxu7m/KPLrP9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714934; c=relaxed/simple;
	bh=xrfLNXMuref17AUYcZqr8r2enXQ19HeUZ/mXhtAwx+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pnx4Ihvvp+f9/7upq2lTOTuJyH4MTDBFM36fN8r82MFbdvnmpato1k2ynu1T2fMuAdWKr+D7EY6Dqy/X/Z/fhdDcJ1NtbXG9z/pjJplQqCoOqyfPjbWBRYTDBYshBIzPPfRvQmFdur906c0FT/EwdOGDpDKWCmYgbdTmkj65BA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpmrPZyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpmrPZyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852A0C4CEEA;
	Mon, 23 Jun 2025 21:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714933;
	bh=xrfLNXMuref17AUYcZqr8r2enXQ19HeUZ/mXhtAwx+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpmrPZyjP4mQs1eV/KOiKyr/OsKUrbVS5QeXo+045Ez+kIXkQ6BFP6qt+xhVGbjFB
	 7rQ91ZS/Kw5FDo5mkg0/UFw/qfuDz3Vy1u+tX5j7MGUEj4caBkQXx9/Ir0wFPewG3j
	 v4sUUzo77WmfCe/cOYZZaYD1mth52ZUjedWV5NZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 145/414] cifs: dns resolution is needed only for primary channel
Date: Mon, 23 Jun 2025 15:04:42 +0200
Message-ID: <20250623130645.678499835@linuxfoundation.org>
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

commit b4f60a053a2534c3e510ba0c1f8727566adf8317 upstream.

When calling cifs_reconnect, before the connection to the
server is reestablished, the code today does a DNS resolution and
updates server->dstaddr.

However, this is not necessary for secondary channels. Secondary
channels use the interface list returned by the server to decide
which address to connect to. And that happens after tcon is reconnected
and server interfaces are requested.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -408,7 +408,8 @@ static int __cifs_reconnect(struct TCP_S
 		try_to_freeze();
 		cifs_server_lock(server);
 
-		if (!cifs_swn_set_server_dstaddr(server)) {
+		if (!cifs_swn_set_server_dstaddr(server) &&
+		    !SERVER_IS_CHAN(server)) {
 			/* resolve the hostname again to make sure that IP address is up-to-date */
 			rc = reconn_set_ipaddr_from_hostname(server);
 			cifs_dbg(FYI, "%s: reconn_set_ipaddr_from_hostname: rc=%d\n", __func__, rc);


