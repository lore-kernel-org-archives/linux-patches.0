Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E8F1E522;
	Thu, 30 Jan 2025 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247250; cv=none; b=U7OtU99kCy2t/UcuNBLHhT0F4BO3LJfdfTdnvtcxT6Sye+UD7OjtJ96FA6oOI2JTqEO2qT2aC8gw0IH0GXpviFEwpsY/+Dh6Q5RYtjUBfsPqIi/bewcaUzWwlqbV7X59sSsLI8XINQsWXbB1Zs99n8I2iDt4QrWiU1i5BIsUWfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247250; c=relaxed/simple;
	bh=K65P+ocwixvnyx3XBuIwi/2+IbDb1S+Wc9s5B4pWrzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtdAtg/7y5SsZRS8Mk9o93KE/iHehz35slFznpsh3HSr1jCenNn25P4+WKa4WQbCvvBGDFGjAyNRBUlPA8WuDwjtkJdWfxnLUxDPQtWl7/xDmDUz/hPPYSue2otY6J63K1pfk1+RS64NBTsgfAQlNMgTGhLf3nBZfKvOhomgrvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJExnpo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJExnpo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA41C4CED2;
	Thu, 30 Jan 2025 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247250;
	bh=K65P+ocwixvnyx3XBuIwi/2+IbDb1S+Wc9s5B4pWrzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJExnpo/n72dHxf5TiOm8aB7RH4l41Cgy3s4VwEytXt+dJgMWHivrPBepLoa8QHR2
	 vdEJ0VzYB9B7MLTRdGyzSWPP+el0PS9tW5NUihgYG0rBQJM/KI3rgCPjeeSI0H9iPu
	 1Ti53GfknGDiKpf9Ix+E/Dwot4q6OMsioN07s0KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 094/133] vsock: reset socket state when de-assigning the transport
Date: Thu, 30 Jan 2025 15:01:23 +0100
Message-ID: <20250130140146.310730033@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

commit a24009bc9be60242651a21702609381b5092459e upstream.

Transport's release() and destruct() are called when de-assigning the
vsock transport. These callbacks can touch some socket state like
sock flags, sk_state, and peer_shutdown.

Since we are reassigning the socket to a new transport during
vsock_connect(), let's reset these fields to have a clean state with
the new transport.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -464,6 +464,15 @@ int vsock_assign_transport(struct vsock_
 		 */
 		vsk->transport->release(vsk);
 		vsock_deassign_transport(vsk);
+
+		/* transport's release() and destruct() can touch some socket
+		 * state, since we are reassigning the socket to a new transport
+		 * during vsock_connect(), let's reset these fields to have a
+		 * clean state.
+		 */
+		sock_reset_flag(sk, SOCK_DONE);
+		sk->sk_state = TCP_CLOSE;
+		vsk->peer_shutdown = 0;
 	}
 
 	/* We increase the module refcnt to prevent the transport unloading


