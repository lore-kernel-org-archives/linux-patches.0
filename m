Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690CE53365;
	Thu, 12 Dec 2024 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022936; cv=none; b=lKje5MXnhvJemFAz8HtjU1gTwVEZ0CCQ8LhiPnBfDmclKEg3bLk2YZbDR3GBQdk3O5dY422Y2OPKGoZyiXBr10fBrALWcSeoDoxriE2Vn9Jug5hIXGB32TzB201ji6mFfP+CGAn3ZwCR2qVfh2IYwCPsyNPQYdhCBJTN9ihwq0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022936; c=relaxed/simple;
	bh=IB4JHurD6eRJvEvpty2EocuhhkxjHFnkxUKDRmGvSbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFHAb9ARhG0074s3bxh6IUrSG1cCGojgR0s9YGGVeeVFHTmNI5cATI8AIqY7ENiq7wVfXcQnBX7ADFxiV/l0m6FW/0cWRQ7CTnJs48EkI4HqDBSbxrp9xezyHD/LTvGrmQo7lSxvnagrz3w+ChGQt9wupG2Qmy8ncR21hEpNXTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xv1cMR73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xv1cMR73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7715C4CECE;
	Thu, 12 Dec 2024 17:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022936;
	bh=IB4JHurD6eRJvEvpty2EocuhhkxjHFnkxUKDRmGvSbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xv1cMR73VPKOvqaDot6qfyyFSkUsVRlkwmIgp1N0HyQA/nvCUKqW+P+ywFBHXWM8s
	 9ehHk2rqF2mIkVW4EHxCTIIymbUfyMNZAZ+yvJfZTL1Bgj/Y3G0uv43KqqgYhEx8fR
	 hrxDUnUsNcx6vHLwh+zoLOHms3+imfeT4bzatvOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Liu Jian <liujian56@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 373/565] sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport
Date: Thu, 12 Dec 2024 15:59:28 +0100
Message-ID: <20241212144326.369568037@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 06ea4fb2d4532..9e122c20fcc6e 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1143,6 +1143,7 @@ static void xs_sock_reset_state_flags(struct rpc_xprt *xprt)
 	clear_bit(XPRT_SOCK_WAKE_WRITE, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_DISCONNECT, &transport->sock_state);
 	clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
+	clear_bit(XPRT_SOCK_UPD_TIMEOUT, &transport->sock_state);
 }
 
 static void xs_run_error_worker(struct sock_xprt *transport, unsigned int nr)
-- 
2.43.0



