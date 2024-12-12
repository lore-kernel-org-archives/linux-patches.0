Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882F72236EB;
	Thu, 12 Dec 2024 17:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025528; cv=none; b=HOcQORnN8epGUCuTdYoV3MnYU2obYM0cyoOJIvI1esg+HL3bMO32wVsApL06PlimY1e6n+kfCRVSsHnG5rxPp92ZAeEq5pWzh0OpP5+/PPDXNTHrY1TTTVsns5hySlNtqe+4MchHAC0GDmasETHVxsrKqu0Nfz5u93wXnzOX2PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025528; c=relaxed/simple;
	bh=OH1iEOmlPetx07PDoMqaegqVVGOh7HZDJ0aerlqGoJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oy7BHaPLlkaTwsQTtpXLFI+8Ab4KTafWwIzFNqLTLAYkMynIQkrjx3bP5ucMolO5ecHTMuJA4pu1xtc0I0aoQapZ5+o9v1gkvSB1f3J17NXPTBuWhdD0wSjAtuuNTCAMjmdSUDpntOz1sAOBzyB7LBdSnS9x/K4xftme3B1yObg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUqqbDsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUqqbDsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAC2C4CECE;
	Thu, 12 Dec 2024 17:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025528;
	bh=OH1iEOmlPetx07PDoMqaegqVVGOh7HZDJ0aerlqGoJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUqqbDsakZMKXBAUTYeYolFtuY+3ak6KC7WSPTmQM6RO3h+OtXZ4ctRlVb/oPXdZi
	 1NZuoMsZ0lWNoCTkTENWAKVWgzVetxk8K6a1HuWfsnJo9OFtKnCMdJmM+I2U2Ev7ap
	 M0IfDASWlgQVViP3ENOrZPkORu542CF5Fo2BOI78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Liu Jian <liujian56@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/321] sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport
Date: Thu, 12 Dec 2024 16:01:57 +0100
Message-ID: <20241212144237.840860715@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fde3fb7387d0d..15a75e86c8943 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1241,6 +1241,7 @@ static void xs_sock_reset_state_flags(struct rpc_xprt *xprt)
 	clear_bit(XPRT_SOCK_WAKE_WRITE, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_DISCONNECT, &transport->sock_state);
 	clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
+	clear_bit(XPRT_SOCK_UPD_TIMEOUT, &transport->sock_state);
 }
 
 static void xs_run_error_worker(struct sock_xprt *transport, unsigned int nr)
-- 
2.43.0



