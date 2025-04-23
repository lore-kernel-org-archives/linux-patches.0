Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBAE285412;
	Wed, 23 Apr 2025 15:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421038; cv=none; b=r2MkSeZWiW4jmzQWUt27bsrBDYUoq+SbBtLox6FP+MDFJkJ/Tm809VQKIFWJ2EdKbfQgywrro6pYbtZZFH+IdT7inY1UFehohOhqO7BbIjCNEvh7w3728vzsNAJ5suwMPpORjGLkH48hzzz1Ijq1QeRv2jG/TI50JNnIKyelFUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421038; c=relaxed/simple;
	bh=/p7a+dxa2JfrKbs1epw8818vB8gIwODhvIMbTbELN5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od7gal2uLrWxPLEjx4AU6IVlTpQ/skt97aCBQKbSKlomubvi64lNr1uVeCnLpwgk2TtNJBwuFHudJ+rMlQX2lAJ88U9ihP+g4yCOgXkkwhuRH/Dh+/SdtsYVFS1gbr+owLrDevXYxtnUrUM5meDSuc/pwXjqgL3vtG2Oh+tfT6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/wksn8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/wksn8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FCEC4CEE2;
	Wed, 23 Apr 2025 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421038;
	bh=/p7a+dxa2JfrKbs1epw8818vB8gIwODhvIMbTbELN5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/wksn8maO/8sOJD3XpCeEcVLjT1JHLsj0uwjo/PCWRookLEVUOiuJqK81f0FgfKZ
	 ZWJOG9TNY8p45YRghRcbb/vC7kKAxI9JhSAg1pU1m8GGN1AMkmmLnClcDEwohhOjVi
	 fHx1zxLQl6w/BI2M9OiGB5NsqQoIEfcUy0tHetWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 146/241] ksmbd: Prevent integer overflow in calculation of deadtime
Date: Wed, 23 Apr 2025 16:43:30 +0200
Message-ID: <20250423142626.518757454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit a93ff742820f75bf8bb3fcf21d9f25ca6eb3d4c6 upstream.

The user can set any value for 'deadtime'. This affects the arithmetic
expression 'req->deadtime * SMB_ECHO_INTERVAL', which is subject to
overflow. The added check makes the server behavior more predictable.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_ipc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -310,7 +310,11 @@ static int ipc_server_config_on_startup(
 	server_conf.signing = req->signing;
 	server_conf.tcp_port = req->tcp_port;
 	server_conf.ipc_timeout = req->ipc_timeout * HZ;
-	server_conf.deadtime = req->deadtime * SMB_ECHO_INTERVAL;
+	if (check_mul_overflow(req->deadtime, SMB_ECHO_INTERVAL,
+					&server_conf.deadtime)) {
+		ret = -EINVAL;
+		goto out;
+	}
 	server_conf.share_fake_fscaps = req->share_fake_fscaps;
 	ksmbd_init_domain(req->sub_auth);
 
@@ -337,6 +341,7 @@ static int ipc_server_config_on_startup(
 	server_conf.bind_interfaces_only = req->bind_interfaces_only;
 	ret |= ksmbd_tcp_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
 					req->ifc_list_sz);
+out:
 	if (ret) {
 		pr_err("Server configuration error: %s %s %s\n",
 		       req->netbios_name, req->server_string,


