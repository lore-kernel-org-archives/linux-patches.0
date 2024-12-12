Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F5C13CA81;
	Thu, 12 Dec 2024 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024481; cv=none; b=aRq8470fX6eONfE0FBdTWmXqE9/iza/k3/a0+yoRO4UbRA6sSkWEKgZIBAs6214NVKBf2uHQ9v15PgRM69Gx02sjdzsy/VhrhF12gs5OXuEae0sy4061dQXuiHeOfbiQutZPBl6YRKT4WOIzO4XG+Dl94oifti+ACrLZOXhpX1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024481; c=relaxed/simple;
	bh=i9Kv5qs+1lGMfCu469MKkCDHgHKM8UwVee5bh/k1bTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hufcVoOvqrbHPS+GK+uXpydOgZEIzuTQzv4Wm/7gP3NsAJKDvEGaQz8zl+BTovrVnWgRWNkh6eAcgsI4kvs6ekdiXi1UNjkADBO9r8PpkS4yVoXBJF1BH7TP3yUAUKeK5T63/J+KpEYdo+4VlUBPQ7P8qfrSjmLKLrEJj9UAmJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j47ILGNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j47ILGNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67AEC4CECE;
	Thu, 12 Dec 2024 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024481;
	bh=i9Kv5qs+1lGMfCu469MKkCDHgHKM8UwVee5bh/k1bTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j47ILGNv9jjCmZmTNoIG2ngQrQrwRUAWOTduVIQsyRG4xJqfgw4FNnAiU6WXHBb3D
	 lIokpQ2dNHg15JCdOrEujy0qjW3CiuQ46hKCTspyZI3qDxA2It6OcT2QHRS9jDPbvL
	 oe8odsXsNZYWAwIMQ4wXH1OMI34flB6LYSqEA/LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Liu Jian <liujian56@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/459] sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport
Date: Thu, 12 Dec 2024 16:00:47 +0100
Message-ID: <20241212144305.852023542@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 4db9ad82a6c823094da27de4825af693a3475d51 ]

Since transport->sock has been set to NULL during reset transport,
XPRT_SOCK_UPD_TIMEOUT also needs to be cleared. Otherwise, the
xs_tcp_set_socket_timeouts() may be triggered in xs_tcp_send_request()
to dereference the transport->sock that has been set to NULL.

Fixes: 7196dbb02ea0 ("SUNRPC: Allow changing of the TCP timeout parameters on the fly")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 278d044e1fd4a..79ce634017f9a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1129,6 +1129,7 @@ static void xs_sock_reset_state_flags(struct rpc_xprt *xprt)
 	clear_bit(XPRT_SOCK_WAKE_WRITE, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_DISCONNECT, &transport->sock_state);
 	clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
+	clear_bit(XPRT_SOCK_UPD_TIMEOUT, &transport->sock_state);
 }
 
 static void xs_run_error_worker(struct sock_xprt *transport, unsigned int nr)
-- 
2.43.0



