Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E19280A50;
	Wed, 23 Apr 2025 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420519; cv=none; b=J6DF6gmxlxsQaWIXz54WAlr7cOWxGVpB6VVqwkWogIy+X/xfAZ3cB9El+T0bqUxyTcehCacpOZImWtVRs2vW3x0+ccekz0wBFpLedmBTQxKnb3tuZ4pX5PC3TR7+W4qU8VFnGSup6j2cGBbD9GO4x8cPvZVW8Ndk+1gd03XJ6VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420519; c=relaxed/simple;
	bh=X3grnDL+sWPLAirMM2dsOpYlYQ/MkxRPe7sT1lVhLSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1E4ME3xNdTdnQBPcqLYiipO4NWC6XjSdakR6ANM3qrmP3BomZglxOvZukfRi8mwt58J42NVIalYCWFPFnSg0LjwAKE7WviprFcMvnH6z0dGTDwhUPvNzRq845C89o95HvknTGvbV2t5slsiJlPT/e+WJn7dELPan1vmpSKphgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwM/8Gk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwM/8Gk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2298C4CEE2;
	Wed, 23 Apr 2025 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420519;
	bh=X3grnDL+sWPLAirMM2dsOpYlYQ/MkxRPe7sT1lVhLSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwM/8Gk/xtn3UNVRsUQeY0m6ryke+YPzoWNiEpYGeSs8+mWGPy5gM/V3LlpUe4iCm
	 D3I2zptZaRQLyELuif22vzl6m5M7+Z11R+xS6fid+D4wL5IJOooUlfoJ4DlcpvYbhV
	 2JQEbfwTw4k+g8WwBgxtxekHBJKvKx+CUEngW7YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 124/223] ksmbd: Prevent integer overflow in calculation of deadtime
Date: Wed, 23 Apr 2025 16:43:16 +0200
Message-ID: <20250423142622.154304623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
 
@@ -336,6 +340,7 @@ static int ipc_server_config_on_startup(
 	ret |= ksmbd_set_work_group(req->work_group);
 	ret |= ksmbd_tcp_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
 					req->ifc_list_sz);
+out:
 	if (ret) {
 		pr_err("Server configuration error: %s %s %s\n",
 		       req->netbios_name, req->server_string,


