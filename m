Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771D52139BF;
	Tue, 12 Nov 2024 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407691; cv=none; b=lrXrwxlRRxw+0pRapijbJo2z2Dcyz06eHUZEM26/Wv00e3GsBCGBhSf4UmbPbx5aRYO4ogqPyBWryquM42KYKzhwYCwdTq62TS/cbhQqQ+KgKKblSn0gI+FEye6mupPRO16CfCbmjrvKbQ9Op2k/hAAg3GJ9/qFneukCccpdXC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407691; c=relaxed/simple;
	bh=a7ntimQ3RXGds6+4u3zq4N3g+xrg9UIU4/Q/6XLbzTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzYcTL0QJ0D33WsKau929Eb/pFJh9pCdaMKAU8yyVP63zPFPeCnahB4e3LQIDzFKpXkQnV6tnWPcvUPvp6tgjHrutSW5XR0okA/+NTkIXhuGXwWIc3+NZINkQapT/ylGxMbg5Zb/7bEd7CJ7sZFvEGgexySEp51OlgzZvosdloE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeWrNAZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeWrNAZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9231C4CECD;
	Tue, 12 Nov 2024 10:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407691;
	bh=a7ntimQ3RXGds6+4u3zq4N3g+xrg9UIU4/Q/6XLbzTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeWrNAZImMoFAIHfxgRYtqyKV0gtO/WhfziId13UDHyxasE+5mZwx8IYabR9ckCk4
	 UbpjbYJMYEABRTsZcOJHsRXNaIYysDXthOsu/jac1Fa8tEw9a7M9UJBSgL55nafZKh
	 dQBsL7UARcr7jpzy9Tk+Pz72dzgfkeZI4y/lVKxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/119] sunrpc: handle -ENOTCONN in xs_tcp_setup_socket()
Date: Tue, 12 Nov 2024 11:20:34 +0100
Message-ID: <20241112101849.712094561@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 10f0740234f0b157b41bdc7e9c3555a9b86c1599 ]

xs_tcp_finish_connecting() can return -ENOTCONN but the switch statement
in xs_tcp_setup_socket() treats that as an unhandled error.

If we treat it as a known error it would propagate back to
call_connect_status() which does handle that error code.  This appears
to be the intention of the commit (given below) which added -ENOTCONN as
a return status for xs_tcp_finish_connecting().

So add -ENOTCONN to the switch statement as an error to pass through to
the caller.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1231050
Link: https://access.redhat.com/discussions/3434091
Fixes: 01d37c428ae0 ("SUNRPC: xprt_connect() don't abort the task if the transport isn't bound")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index c1fe2a6ea7976..50490b1e8a0d0 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2440,6 +2440,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	case -EHOSTUNREACH:
 	case -EADDRINUSE:
 	case -ENOBUFS:
+	case -ENOTCONN:
 		break;
 	default:
 		printk("%s: connect returned unhandled error %d\n",
-- 
2.43.0



