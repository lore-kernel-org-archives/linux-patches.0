Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177A2280CFB;
	Mon, 13 Apr 2026 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098479; cv=none; b=KmF3D7zRKsJQsZ+KeZWltQR5O80qvLaZQAnRqhW6hoydYNtGMaT+nkh7qyxa9pVL6r5XnnY8Sy9VjaJjvn3tMLRW0iCJ49g5hZ4hL6mnymv+S72hOYSiJLiBqGSuXWsws6QkT2AsZ68VZYkwxFPKQpzrDnJ/PlMx760Pj1u0jls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098479; c=relaxed/simple;
	bh=E6V/BSPC67bYlXYi4NZ3+lv4WGG2sv5B7WP3msPHLPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdyiulFYlRZP5XNiH0Oab+iI8jPAzrSNNCqNxHfhTdTUH8mXPPlkI7WRQWec3yGtBdCjQ93gF/97Dj3dM0NwNGe2QRaEvf8eQaJpunJVDf5AJOc3HG0mkZyR6nVuQXAh3GA+M1RJKNdo/NVfr3xnmvPHHRPQLKe5x0lmn4f+zzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMOewk9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMOewk9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F354C2BCB6;
	Mon, 13 Apr 2026 16:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098478;
	bh=E6V/BSPC67bYlXYi4NZ3+lv4WGG2sv5B7WP3msPHLPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMOewk9YHClMI9Kmo1zcoIU/6VGpY9xy8cwixdiSssHGjZZKCegEgV6DLeLzHhtSg
	 QwgbeUbDhwGW2FDVY+AnUSghGQB9XA1y8xqmW97YPj5xFMIP5dMBYhBw7jcLkDBo3X
	 J9Mq/kh7/bNDE5ITXQitGo3sqKjKO57GJlTlMkhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 539/570] rxrpc: fix reference count leak in rxrpc_server_keyring()
Date: Mon, 13 Apr 2026 18:01:10 +0200
Message-ID: <20260413155850.636135525@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

commit f125846ee79fcae537a964ce66494e96fa54a6de upstream.

This patch fixes a reference count leak in rxrpc_server_keyring()
by checking if rx->securities is already set.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-15-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/server_key.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -125,6 +125,9 @@ int rxrpc_server_keyring(struct rxrpc_so
 
 	_enter("");
 
+	if (rx->securities)
+		return -EINVAL;
+
 	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
 		return -EINVAL;
 


