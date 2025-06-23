Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE75248895;
	Mon, 23 Jun 2025 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684802; cv=none; b=EHona8dU9SQY4snOyqIXHrsImya+iv22rlnPrXQCsAkDJkmtVY/cpV8Q+uGuXoaw4/5i4GBwyci9Gvca+SBJWuQkXKJ3bXJBhjElgyp5Qbh9mBvwVDwO+OlvVOscSEodpOGdHdxkcpRH1aMEX2peVJuJA86wqn9sFDqgniVfxrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684802; c=relaxed/simple;
	bh=YHO95B7Qo0gy1xc/b5Vz8JaiVuYJ9UfiO/zp4RqBWXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAkeGLh4M92pz8N1y3OIIB/NKd+tqQinlFVo1Le4U9bsVc6S91SZ9kg9NhrtE8ambHHpza33U93miOfFa+2vAr1Aiq5XEzbssbjcbTmXu3Z9dlIbNRSR3BlHsgzDFCpfeo+qYjCjLWRQeMg10sO05zytX9hF6vjsqwlFSIrqR4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yl3gnytb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yl3gnytb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D8BC4CEEA;
	Mon, 23 Jun 2025 13:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684802;
	bh=YHO95B7Qo0gy1xc/b5Vz8JaiVuYJ9UfiO/zp4RqBWXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yl3gnytbJEMSO9xHwSq7EoOpPT6pioBOPh3HNKmgaCWT9UFM6v/ztub60g2av0C5z
	 MlFQdY3V80xLaB/xBlHvUEllvEo4u7oao/7rkpcYZleO5+CUtnIFY+2jCPRs0nb7IK
	 bp9BiyKNVYGAl2J/71jM53/eqiVoEle+7Y5zTxeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 175/592] cifs: dns resolution is needed only for primary channel
Date: Mon, 23 Jun 2025 15:02:13 +0200
Message-ID: <20250623130704.440168464@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -392,7 +392,8 @@ static int __cifs_reconnect(struct TCP_S
 		try_to_freeze();
 		cifs_server_lock(server);
 
-		if (!cifs_swn_set_server_dstaddr(server)) {
+		if (!cifs_swn_set_server_dstaddr(server) &&
+		    !SERVER_IS_CHAN(server)) {
 			/* resolve the hostname again to make sure that IP address is up-to-date */
 			rc = reconn_set_ipaddr_from_hostname(server);
 			cifs_dbg(FYI, "%s: reconn_set_ipaddr_from_hostname: rc=%d\n", __func__, rc);


