Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9A81F8904;
	Tue,  3 Dec 2024 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239999; cv=none; b=Rdi8MBOkRbFJHlcJfCGvoAcrxo7M4CiIrGLtiEnMpGCXJdsMYSPbRvDB5LOGqqfXIxScY+Lz/5YPcjJvmilNN2FUS7oILs1RvFYdWcBtrAKtukPqu8uegiaQPM79FlA6qQVb6ehfbSVaprG06yre8iKYQkq7N+2IxPB8L4nYDx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239999; c=relaxed/simple;
	bh=8ltC9vGGrLx/JC3p0blwVN4KU6ejosvbhxthyniKuDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3xF/O97J0wwnfOsReZYFyAp+oXlhyWpFBiJokIW9nmn0+Z9i+EfoBtJkDC475UBHzRG0M7dsj6syyrVEpToSvX4nM+x7KzE1+SimJ8R5GU0NjAMoqE0F7l7MOnBFUlkjymhMHPlBZgOquDWCaVElBNDHDEjLI/XDrhC03pghsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmIxmpLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmIxmpLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92E7C4CECF;
	Tue,  3 Dec 2024 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239998;
	bh=8ltC9vGGrLx/JC3p0blwVN4KU6ejosvbhxthyniKuDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmIxmpLXVWjm0nff3VbksloE+egyj8Tjf5kDvQLQxsyjCBkmduGrWvSUVs/qAv3ex
	 gbdQQStaC8cTi7dO6DeqV7vmjXjP0YK6xCdDkG+oRWRycum2uxXAuu76cBTDTLcdHt
	 49QIMTimiBxsSmUDBdkkkL1tjwIOJaw7ExYmsRpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Liu Jian <liujian56@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 806/817] sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport
Date: Tue,  3 Dec 2024 15:46:18 +0100
Message-ID: <20241203144027.913769870@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



