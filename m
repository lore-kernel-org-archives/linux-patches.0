Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6653B3C11;
	Mon, 23 Mar 2026 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278572; cv=none; b=nRgxTqhpsIbPIGPkIoR6ky+8u9w1qIfwZDIRvm3cuJTJOCf0dU9APrHN4e8Y6BcBih2M8SK9qq4LnbYFtGu16KyX3leTWbVUnv4ulwn715zwWSpans9ikHoHlq+A1NO/DfVIfIF2T+izv0tpcB95iEMITtSURPFMArxiLM/aQ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278572; c=relaxed/simple;
	bh=zQl5uWRGLhPwIITKpP7DgQxYncekM6PP7OxoE71T5S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzeYLML87LMsat7eqLMzUoAQ/oy+720eTVkdseXsNYWMC6EF4M61C62hSj95IJG6J0hyLE4Yhvwr/f3UadcI0vs0pKePv0YEU9iwq5zXVDGncpIrpmZTCNnxSxkJ783RVnb1hZTx2q7xGi9gkSqGfJW36guto9Li/K78g53ALIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRx+DFgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRx+DFgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDB5C4CEF7;
	Mon, 23 Mar 2026 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278571;
	bh=zQl5uWRGLhPwIITKpP7DgQxYncekM6PP7OxoE71T5S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRx+DFgK4np6OBW/+Wpqd5idoRhYS4H4yqAxWZUl/3TTjIgvjeXOVhzUuUrLNgAfh
	 nMwv7WhIV6cfE+Bpjj0R4LWcVyNuznDYWBB14sH/2MnO25OmcXk1WNinOTFHZ3kywh
	 yQujiZWBGx8uwrcuSGCoxWCNo0CGEsjWd444GtbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 350/567] smb: client: fix iface port assignment in parse_server_interfaces
Date: Mon, 23 Mar 2026 14:44:30 +0100
Message-ID: <20260323134542.496854149@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit d4c7210d2f3ea481a6481f03040a64d9077a6172 upstream.

parse_server_interfaces() initializes interface socket addresses with
CIFS_PORT. When the mount uses a non-default port this overwrites the
configured destination port.

Later, cifs_chan_update_iface() copies this sockaddr into server->dstaddr,
causing reconnect attempts to use the wrong port after server interface
updates.

Use the existing port from server->dstaddr instead.

Cc: stable@vger.kernel.org
Fixes: fe856be475f7 ("CIFS: parse and store info on iface queries")
Tested-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -586,6 +586,7 @@ parse_server_interfaces(struct network_i
 	struct iface_info_ipv6 *p6;
 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
 	struct cifs_server_iface tmp_iface;
+	__be16 port;
 	ssize_t bytes_left;
 	size_t next = 0;
 	int nb_iface = 0;
@@ -620,6 +621,15 @@ parse_server_interfaces(struct network_i
 		goto out;
 	}
 
+	spin_lock(&ses->server->srv_lock);
+	if (ses->server->dstaddr.ss_family == AF_INET)
+		port = ((struct sockaddr_in *)&ses->server->dstaddr)->sin_port;
+	else if (ses->server->dstaddr.ss_family == AF_INET6)
+		port = ((struct sockaddr_in6 *)&ses->server->dstaddr)->sin6_port;
+	else
+		port = cpu_to_be16(CIFS_PORT);
+	spin_unlock(&ses->server->srv_lock);
+
 	while (bytes_left >= (ssize_t)sizeof(*p)) {
 		memset(&tmp_iface, 0, sizeof(tmp_iface));
 		/* default to 1Gbps when link speed is unset */
@@ -640,7 +650,7 @@ parse_server_interfaces(struct network_i
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
 			/* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these */
-			addr4->sin_port = cpu_to_be16(CIFS_PORT);
+			addr4->sin_port = port;
 
 			cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
 				 &addr4->sin_addr);
@@ -654,7 +664,7 @@ parse_server_interfaces(struct network_i
 			/* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore these */
 			addr6->sin6_flowinfo = 0;
 			addr6->sin6_scope_id = 0;
-			addr6->sin6_port = cpu_to_be16(CIFS_PORT);
+			addr6->sin6_port = port;
 
 			cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
 				 &addr6->sin6_addr);


