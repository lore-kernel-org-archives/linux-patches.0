Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8CA1F3FFE;
	Tue, 21 Jan 2025 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482771; cv=none; b=u1d1Z+JbOWPWNkHbcTriuNUkm3/VYt0koaEvE9nabYj30PSjSZOJwDADbHpRcaRkW03MS1NnwJ1fDnGu5AikSAqCPlrkXmpDexux7xyJ7Q+mzsnWCxdI4WI5jxzxytsYCuIfyxF+5QqID9a+kHuRUpDbXiJ7wYPCwyAhUEwQPDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482771; c=relaxed/simple;
	bh=iFzBgWtzABx0FeXN5jeQnkVpVumIA9oyn5CPGxkmC8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toseVw+GXeHJtr8a6JL3iUpIq8O189rldS/u3AOJbwdiyb1cA7AvaOqA6l4cEm+x/lqXgMq7B2FF02PoVs2qJWjq8a+RI4wjl49FKt7xA0jAOYDXTO6jcQDsVM3RItLfmIGwlHx/uk7s8xvG23OaXd6SjNeExVVqUdcKmjvLemk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCPnOlox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCPnOlox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACE1C4CEDF;
	Tue, 21 Jan 2025 18:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482770;
	bh=iFzBgWtzABx0FeXN5jeQnkVpVumIA9oyn5CPGxkmC8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCPnOloxcxy05zS4tQKiAYil8cS+LWFhN1Q8p6IrhR6ierZNnl8ohWeZjUKTIoGO4
	 BWGMfp7vSw+7clRTKvKeWfN+QxNfGaXGYx7GraLY68GC/QxSJYMyaOM9JPt9mTyew4
	 XlEIVQ1XiIYfx3/9qcPDSpji5mYu0LnKMi53q1H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 37/64] vsock: reset socket state when de-assigning the transport
Date: Tue, 21 Jan 2025 18:52:36 +0100
Message-ID: <20250121174522.968434294@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -485,6 +485,15 @@ int vsock_assign_transport(struct vsock_
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


