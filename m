Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7AD1AB6C9;
	Tue,  3 Dec 2024 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242810; cv=none; b=AeXUdhccmWBm/qVtIvyLdRvXD2S/oZWwLP4Ux5lRuS8SKbTONG9CcvfMMaisKwKC/HoPeLawv4IDYcxBBSJYBftNOidv44oEpXhy3tgihhQKm4h+FLpN+zxW/xWPUJ9PzNvEoeBmFLc8HMSSL9uH47Z3ohfPpn9wGWXkRpYxKLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242810; c=relaxed/simple;
	bh=dl5Xq0CjSigA7PNgk6z6NkfHFaP0C78bQf0C5OOj9qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfO+D/aCbb+WtDluyOXZcbYS3ttY+QnIFOjCg7b0TSQ57BQbUdXTajGL85xDGKlwIJfndX/aQF8Dukk5AA8iObO4ERDDlJ03d5vqgC4oFR4nl6wiLvbpjErQ7h6jVVuF7hL/CyaC7jlVRriBV8Hl7GPFxb6ooW4l/3lneQPdISU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifWVTw1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifWVTw1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84367C4CECF;
	Tue,  3 Dec 2024 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242810;
	bh=dl5Xq0CjSigA7PNgk6z6NkfHFaP0C78bQf0C5OOj9qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifWVTw1tsDdWC6N3OvfEL0biaySNctX3jnbk5WOJKNmafW0nYax3w8keuPx8JETrf
	 G4Ok9cZ/t+1TQOJEY6gBOCh05Pl+4tPa/rh1WmriqOcecK583Uah7eoUg2DPD4R3M+
	 9fsXfaxdUc71t66o0nX2dSoXPEof+r0qiRp8pems=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Liu Jian <liujian56@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 815/826] sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport
Date: Tue,  3 Dec 2024 15:49:02 +0100
Message-ID: <20241203144815.546326607@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1326fbf45a347..539cdda2093e5 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1198,6 +1198,7 @@ static void xs_sock_reset_state_flags(struct rpc_xprt *xprt)
 	clear_bit(XPRT_SOCK_WAKE_WRITE, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_DISCONNECT, &transport->sock_state);
 	clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
+	clear_bit(XPRT_SOCK_UPD_TIMEOUT, &transport->sock_state);
 }
 
 static void xs_run_error_worker(struct sock_xprt *transport, unsigned int nr)
-- 
2.43.0



