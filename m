Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48D829E11A;
	Sat, 30 May 2026 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165642; cv=none; b=n88CqTZ0jHdAY2VeEA6tRKyAMfMZlhi1y9i6q55X4ixtvVBiSmPo/7wTRXsNvmchR6YAOetfSgYn+9hv5Mojy1J77+uQI9L9dEazHS1Uae23E91joson0+KfSQw9S0BfR71UEe84TgskyLdlFYk/8wVTOppjpCktTeLJndxX+FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165642; c=relaxed/simple;
	bh=y5KL/hVzq91vgUpkDyZnYj+4IQvIKJV6pcCnSYgVyG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbEnz17cWm0qsSvP0BMtSgGiT50oQzoLEJypYbe7dTTTCWR728RiiXnmhEq9QoXPWCaZlIo2jdDN1F3shSo+zPtWy6amEF92eqkTBz0z7kVD/GZo+LI5wPyxP+CalxXct5mvfnvBx/E9KBthIzBLely26K856TOn6VVOdDBhwSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGPTh1h5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGPTh1h5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60EF1F00893;
	Sat, 30 May 2026 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165640;
	bh=F9lWqiR+cFoT583K//jBnxWBHCvaTVP6JZAhIc4rkvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGPTh1h5w5iDyZW2av5XuJj2B/NNjTxSJbXJEgsCcW1PdCKRvpofPA3NN9ve3vcsq
	 q1YeNcbRUOvZQqFcOlNnHKCtk0eY3jRl93DvcPquoWX1U5LGloykZHg6Up5c4OwWVD
	 hbb7MYyvJWUF0vGk1Ez8DbJi+QtIDs5J/JPvsdj8=
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
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/589] rxrpc: fix reference count leak in rxrpc_server_keyring()
Date: Sat, 30 May 2026 17:59:41 +0200
Message-ID: <20260530160227.327357189@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

[ Upstream commit f125846ee79fcae537a964ce66494e96fa54a6de ]

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
[ applied patch to net/rxrpc/key.c instead of net/rxrpc/server_key.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/key.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -933,6 +933,9 @@ int rxrpc_server_keyring(struct rxrpc_so
 
 	_enter("");
 
+	if (rx->securities)
+		return -EINVAL;
+
 	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
 		return -EINVAL;
 


