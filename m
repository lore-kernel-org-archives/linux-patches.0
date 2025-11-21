Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB3E33C526;
	Fri, 21 Nov 2025 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732939; cv=none; b=mgbbEoXrl7b8AM3hazVghsmMpLxWGCKJA+YV1DeHU291cdjyEXGoZk+84U5mkxo5CXWQba0d7JVeCP4hODVKQqppwCFeIUWKcQ/95L5Pohmx0K2kVbSdkqpf/JGFAGGYZOccRFG247iShBj56cfut8NahlbtbV+xjVwTAmxMgW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732939; c=relaxed/simple;
	bh=VhGdg3U9sumP4Ki+NAI7VtwcV83U/JHbnZHZgXdAozQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMYk5QoID+5Y49NyIxp1OwxsbgcjEgzypJFNucUm2absu3WdXdjlx+wNuG33ppiKFsWeAL3KH0Ljxo8CNssgHqZt2qAT3+x2CaPA74KR2A+w8gMJ2oz36eJgRGc3D4C/N/dPuo7En+L2U+9k3Wqj5ANwt76ga6nH+E2PGODlh/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCAJWVY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCAJWVY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6934C4CEF1;
	Fri, 21 Nov 2025 13:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732938;
	bh=VhGdg3U9sumP4Ki+NAI7VtwcV83U/JHbnZHZgXdAozQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCAJWVY+nCydgoayDIC6+Pa50Jx/H11cv/klW/DXP78m5ho192pL0ghQ6HmSSLVcB
	 SjjbcQwgTqtXB+un/zK1JiAPvo1mSbvkMpdrL1kpHK52+XbTaT0ukuiy+AIEtv4hTI
	 ogkmJ0oFHTK6ezcCLdJr3RVlxcSMyD9tBysI7YV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 295/529] ksmbd: use sock_create_kern interface to create kernel socket
Date: Fri, 21 Nov 2025 14:09:54 +0100
Message-ID: <20251121130241.524400317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3677ca67b9791481af16d86e47c3c7d1f2442f95 ]

we should use sock_create_kern() if the socket resides in kernel space.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 665d21d40e7a1..279a61d0dcc6b 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -476,12 +476,13 @@ static int create_socket(struct interface *iface)
 	struct socket *ksmbd_socket;
 	bool ipv4 = false;
 
-	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
+	ret = sock_create_kern(current->nsproxy->net_ns, PF_INET6, SOCK_STREAM,
+			IPPROTO_TCP, &ksmbd_socket);
 	if (ret) {
 		if (ret != -EAFNOSUPPORT)
 			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
-		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
-				  &ksmbd_socket);
+		ret = sock_create_kern(current->nsproxy->net_ns, PF_INET,
+				SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
 		if (ret) {
 			pr_err("Can't create socket for ipv4: %d\n", ret);
 			goto out_clear;
-- 
2.51.0



