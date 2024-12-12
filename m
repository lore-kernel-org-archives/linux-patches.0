Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA9223E94;
	Thu, 12 Dec 2024 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020361; cv=none; b=RIKl+Jr2vZkhJopAP9y/tuGWDyNJQLqdyMZIXqj1kUvxWpPBfaAJLDEbSPBIylOHfgM9ayXbAK3vZQZJpsqkdkXpcc1ikAcDQe6KKmyQsORptGerfRnrmDrs6/uu8pc+4soiy5W6KUEiJaAduI/3Yx9I9UIQcmkd+vwe3uKXl0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020361; c=relaxed/simple;
	bh=IehZTnUj2/4WtXHZPeKiBZbd4T4LWbne+ezo2uFd0lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocvVQG64h5FQtANOiQfy+otmJZ6zt9H7vwgAnuYrGkYH36NHw0cT359WUOH1jPTZQlL5+ZQWk3pnLbXysqBprMdt9qgUrT4pztIA2HyTvXtGDw8FHvEruxttxLBpaoy1zhtAWgFWvjUpdAFMYFDQXsJ2oUbjs22+IPmlnXL82ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoTdLLvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoTdLLvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E443C4AF09;
	Thu, 12 Dec 2024 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020361;
	bh=IehZTnUj2/4WtXHZPeKiBZbd4T4LWbne+ezo2uFd0lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PoTdLLvPG3xv4ZrCfbYtRqi54Y08foTnzjTU91OdoBcIor7Mf+hcMbiVzaAA2aCx6
	 ajVENQPZyXfKCT6TENH91iQ2Py8Bzl1GOANf7LklczVHwsaqq9xoIM6n5rcTeymW6e
	 +TOUjBNxDnVaOD9HN5JiNoVlr4n/x2JlPbnZ7azE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Liu Jian <liujian56@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 447/772] sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport
Date: Thu, 12 Dec 2024 15:56:32 +0100
Message-ID: <20241212144408.392331207@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 190dae11f634a..b9dc8e197dde8 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1130,6 +1130,7 @@ static void xs_sock_reset_state_flags(struct rpc_xprt *xprt)
 	clear_bit(XPRT_SOCK_WAKE_WRITE, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_DISCONNECT, &transport->sock_state);
 	clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
+	clear_bit(XPRT_SOCK_UPD_TIMEOUT, &transport->sock_state);
 }
 
 static void xs_run_error_worker(struct sock_xprt *transport, unsigned int nr)
-- 
2.43.0



