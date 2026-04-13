Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EFE3168EE;
	Mon, 13 Apr 2026 16:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099029; cv=none; b=Kze/CNKV7IWe8bTiG8RT+f8iSAirKEvXq/wCblaJdCOO3UWU1afOdgWLmtnM3tm2g8ukRLzX5jGOaHv7RclKdv97tItad5IAIq+5Tpb+vJsn6MsBYkjWpsGMm22OfGZel/9UVHRkmXRMTMjwRozO+evyNLT2VGb6mtbyg1aXXFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099029; c=relaxed/simple;
	bh=xg49LSYJXCYjF/vf/hlBeMy+VQmawpW9gAZZm4ZkpiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO2ws1voxS4AuP7SBgw9KO/19vh5LPLvScMyAECGNfyYdjob9CRIOs0MXv3zoJ94DcXo3D1ViCR8xGHhoBYjKTVzA4ru2dNSGqqoXLiLvwdPAfR5J2v+CdVHoLSuoyQlVPZcrcFxg2pRIMEDSY6+AYoz8rNAqsnI1H6VL8LPtYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bno53rIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bno53rIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D54DC2BCAF;
	Mon, 13 Apr 2026 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099029;
	bh=xg49LSYJXCYjF/vf/hlBeMy+VQmawpW9gAZZm4ZkpiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bno53rIgAN106lSQN+L/y9JbfrE2Tvqp+fph+DaQqe3e+O0lp43XyaSKRWU/iSZot
	 j2XktNqyahFrf51T1NQNhbHkpgbFVk4iL7oWld23htu0dGeL0HKMzQ/6y28S0ZrBNR
	 p2dnDYDu2ZCCC2ybsHxoElkeYjPeKRepjoLHhp4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/491] smb: client: fix iface port assignment in parse_server_interfaces
Date: Mon, 13 Apr 2026 17:57:00 +0200
Message-ID: <20260413155825.603333384@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit d4c7210d2f3ea481a6481f03040a64d9077a6172 ]

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
[ adapted struct types, function signature, lock name, and file path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -437,7 +437,7 @@ smb3_negotiate_rsize(struct cifs_tcon *t
 
 static int
 parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
-			size_t buf_len,
+			size_t buf_len, struct cifs_ses *ses,
 			struct cifs_server_iface **iface_list,
 			size_t *iface_count)
 {
@@ -447,6 +447,7 @@ parse_server_interfaces(struct network_i
 	struct iface_info_ipv4 *p4;
 	struct iface_info_ipv6 *p6;
 	struct cifs_server_iface *info;
+	__be16 port;
 	ssize_t bytes_left;
 	size_t next = 0;
 	int nb_iface = 0;
@@ -493,6 +494,15 @@ parse_server_interfaces(struct network_i
 		goto out;
 	}
 
+	spin_lock(&cifs_tcp_ses_lock);
+	if (ses->server->dstaddr.ss_family == AF_INET)
+		port = ((struct sockaddr_in *)&ses->server->dstaddr)->sin_port;
+	else if (ses->server->dstaddr.ss_family == AF_INET6)
+		port = ((struct sockaddr_in6 *)&ses->server->dstaddr)->sin6_port;
+	else
+		port = cpu_to_be16(CIFS_PORT);
+	spin_unlock(&cifs_tcp_ses_lock);
+
 	info = *iface_list;
 	bytes_left = buf_len;
 	p = buf;
@@ -519,7 +529,7 @@ parse_server_interfaces(struct network_i
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
 			/* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these */
-			addr4->sin_port = cpu_to_be16(CIFS_PORT);
+			addr4->sin_port = port;
 
 			cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
 				 &addr4->sin_addr);
@@ -533,7 +543,7 @@ parse_server_interfaces(struct network_i
 			/* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore these */
 			addr6->sin6_flowinfo = 0;
 			addr6->sin6_scope_id = 0;
-			addr6->sin6_port = cpu_to_be16(CIFS_PORT);
+			addr6->sin6_port = port;
 
 			cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
 				 &addr6->sin6_addr);
@@ -600,7 +610,7 @@ SMB3_request_interfaces(const unsigned i
 		goto out;
 	}
 
-	rc = parse_server_interfaces(out_buf, ret_data_len,
+	rc = parse_server_interfaces(out_buf, ret_data_len, ses,
 				     &iface_list, &iface_count);
 	if (rc)
 		goto out;


