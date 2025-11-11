Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFCE2701DC;
	Tue, 11 Nov 2025 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825134; cv=none; b=MhPaB3F7yMrG6Wzm011Z7LPS0svw8WzZUPxcYUxl6MSiPN7InZc4iB1yw8VRek7Ya7iVMV2GpUUqyOaj+M6wVcOXeAP7dKzajyOZkSS/99StqrHvQheAKOrV9N+d/sPRqvKyaUJFDQbXfCxj91owBd3KxQuYaV7uH8zPLukH3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825134; c=relaxed/simple;
	bh=f+Ew/xtN9Zt8HsbYYkqg6xAZ7cLAZh9jT4Tkydkt6WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWshZIAA9DEnOnOjvGuMsELTn5H9WtQ93nkz+tZsZ8IkBqqIIDl1nxvqjsP0LwwnTqD8C2yMr3mIvUqsvV2GdwvWn/dP7SxggEUo7Wi0wLTQC9Cfy3x1qkO+gx9UjW8Cw8QPFNC79kQxWes+NZXAH/TzvhCToHGcsBO5yyQoETU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYj3F/Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYj3F/Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BD1C4CEFB;
	Tue, 11 Nov 2025 01:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825134;
	bh=f+Ew/xtN9Zt8HsbYYkqg6xAZ7cLAZh9jT4Tkydkt6WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYj3F/ZuE3EGnt4W3I4woR/LBSKEz5xeUi3qDZpFDo4LoPWrHL4+Gm+Qh9A2FDywe
	 vLfZeaZBDesQrva20FSu2k6hJd4quQ+P9gK3Eh/IzNnFTUVKlJOAwNOjyoeGacpVIV
	 zvcy2hYDnHcZ59AUHnHfCeIJi/vSPSQE5yNAOyHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 676/849] ksmbd: use sock_create_kern interface to create kernel socket
Date: Tue, 11 Nov 2025 09:44:06 +0900
Message-ID: <20251111004552.763297568@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1009cb324fd51..43401d09c9db4 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -473,12 +473,13 @@ static int create_socket(struct interface *iface)
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



