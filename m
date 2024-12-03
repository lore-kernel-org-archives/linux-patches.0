Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7034C1F8904;
	Tue,  3 Dec 2024 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240002; cv=none; b=P7R+UKI5JJ1fVQT8FTn+q7caAVF8ktrsCcnlFdcsgG0ifAGqWAXxSIcrCDISNWtFdWls0pD+hopz+Vbp8nXMJncf5INPLUxLub/FP+RaDu/aWmVrDtxGsRRaQf+TpnNK75lfuG+OMIyGtxJJaKjF0yIWq6UNMIV6dxaq7UrMEKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240002; c=relaxed/simple;
	bh=lMa/mHHPLD4mpmQheRfyj61gmyCSsLMA+hjIuTctc5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKhcRvYccksHIoTaqEhqcY1+Fnx61I0/VK2/grqLIgSNM9wr10C93+1pXdBWMBLjL6fGVYxvWqU8Pu4HnhXCGdW8HU/9oxZTWbkUvoAz19cO4Vz1AmUuqMTOOciPSD8axrB5bTeiL37qfyv2I2fWgRa2mTbay2cNAHnThZutpVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxBGCEsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxBGCEsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38FAC4CED6;
	Tue,  3 Dec 2024 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240001;
	bh=lMa/mHHPLD4mpmQheRfyj61gmyCSsLMA+hjIuTctc5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxBGCEshGfoIyrdGIm+O5NMmPqiHDKnArw9oY1Ba20nzBdfalOtyuh73fLpTIl/wA
	 hsKxRma9tbpNI1lfpkfRSzKHvLMJzhREOxiAslTynHBtIko0VoxUR2BTVEPPpDNwAv
	 rEzfoDkCHgGpxyq2BQyM2+Nl7+dqProkPiLZ3dYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 807/817] SUNRPC: timeout and cancel TLS handshake with -ETIMEDOUT
Date: Tue,  3 Dec 2024 15:46:19 +0100
Message-ID: <20241203144027.953387755@linuxfoundation.org>
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

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit d7bdd849ef1b681da03ac05ca0957b2cbe2d24b6 ]

We've noticed a situation where an unstable TCP connection can cause the
TLS handshake to timeout waiting for userspace to complete it.  When this
happens, we don't want to return from xs_tls_handshake_sync() with zero, as
this will cause the upper xprt to be set CONNECTED, and subsequent attempts
to transmit will be returned with -EPIPE.  The sunrpc machine does not
recover from this situation and will spin attempting to transmit.

The return value of tls_handshake_cancel() can be used to detect a race
with completion:

 * tls_handshake_cancel - cancel a pending handshake
 * Return values:
 *   %true - Uncompleted handshake request was canceled
 *   %false - Handshake request already completed or not found

If true, we do not want the upper xprt to be connected, so return
-ETIMEDOUT.  If false, its possible the handshake request was lost and
that may be the reason for our timeout.  Again we do not want the upper
xprt to be connected, so return -ETIMEDOUT.

Ensure that we alway return an error from xs_tls_handshake_sync() if we
call tls_handshake_cancel().

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Fixes: 75eb6af7acdf ("SUNRPC: Add a TCP-with-TLS RPC transport class")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 539cdda2093e5..43fb96de8ebe5 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2615,11 +2615,10 @@ static int xs_tls_handshake_sync(struct rpc_xprt *lower_xprt, struct xprtsec_par
 	rc = wait_for_completion_interruptible_timeout(&lower_transport->handshake_done,
 						       XS_TLS_HANDSHAKE_TO);
 	if (rc <= 0) {
-		if (!tls_handshake_cancel(sk)) {
-			if (rc == 0)
-				rc = -ETIMEDOUT;
-			goto out_put_xprt;
-		}
+		tls_handshake_cancel(sk);
+		if (rc == 0)
+			rc = -ETIMEDOUT;
+		goto out_put_xprt;
 	}
 
 	rc = lower_transport->xprt_err;
-- 
2.43.0



