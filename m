Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3316418A34;
	Fri,  4 Sep 2026 05:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499365; cv=none; b=XojqSuvYtvhJ6UmM7JRLxM5qOd0Kq7fdWuyPv25vJCOc9E8kneou9LNc/8EjYDcgxw+ox0xhYCbdTr/6x45u0row5X/g2JxVbwCDtmMua9skWacBo7ZZkIxVVxOBtfYhVD4ZyGI0hXPW8P79KVaKHLdHDdgDCDCh2TMEz5bKHcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499365; c=relaxed/simple;
	bh=h5F79EE3sUgGZYJM0yVLnZIe6rSNPOYH6Be4BUVJM0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aY3yRU/2Dok5UQNTIMoR14/+b2vadf7CrBWAMbhkeeeUfSCcVk+yERHbQJ4kreT9Q19Iqg1q0AlWm+ZxYqR6bDA/1iVXpb4zmN9X1hBpHinmJsoDLhb9YaqnAxhQy84Qxwx/Hgvjjh9sH6Ca/00qAkHaZLyBk4cklzsPrTwvEk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxGnaBfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxGnaBfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E35C1F00A3D;
	Fri,  4 Sep 2026 05:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499363;
	bh=cU1Rd3cuP7MOOouCDSmn4BwU+x/q+Wp4JIIWuV1ij70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxGnaBfFnvgy5QrnP7+XgxvGqNV38FXc4N/4cSbQd4MKIeXKCOGsnKpFABAyd4Q+f
	 oomw0jnXHUpxRjgqL0Gog4w5fyG5i1ECsvdbOog9dW3sk+izjfcqVKNADIU7RjaP5t
	 eV2rReTVwY7ClyRvVGL/1fo1nSFLBvzZCAv+39BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 390/713] svcrdma: Clear sc_cm_id when ADDR_CHANGE replacement fails
Date: Fri,  4 Sep 2026 06:55:58 +0200
Message-ID: <20260904045812.565634391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 01500306e1d50de7ca7a2cdcdfa28ac0523eb747 upstream.

When svc_rdma_listen_handler() handles RDMA_CM_EVENT_ADDR_CHANGE,
it creates a replacement listener cm_id and returns 1, telling
the CM core to destroy the old one. If the replacement allocation
fails, sc_cm_id still points at the old cm_id that the CM core is
about to destroy. Any subsequent dereference of sc_cm_id --
such as svc_rdma_detach()'s rdma_disconnect() call -- is a
use-after-free.

NULL sc_cm_id on the failure path and guard svc_rdma_detach()'s
rdma_disconnect() call against NULL so that the listener can
be torn down safely when the server shuts down.

Fixes: d1b586e75ec6 ("svcrdma: Handle ADDR_CHANGE CM event properly")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-5-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -325,6 +325,7 @@ static int svc_rdma_listen_handler(struc
 		if (IS_ERR(listen_id)) {
 			pr_err("Listener dead, address change failed for device %s\n",
 				cma_id->device->name);
+			cma_xprt->sc_cm_id = NULL;
 		} else
 			cma_xprt->sc_cm_id = listen_id;
 		return 1;
@@ -614,7 +615,8 @@ static void svc_rdma_detach(struct svc_x
 	struct svcxprt_rdma *rdma =
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
 
-	rdma_disconnect(rdma->sc_cm_id);
+	if (rdma->sc_cm_id)
+		rdma_disconnect(rdma->sc_cm_id);
 
 	/*
 	 * Most close paths go through svc_rdma_xprt_deferred_close(),


