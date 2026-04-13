Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E72224DCF6;
	Mon, 13 Apr 2026 16:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097096; cv=none; b=A1hP40STTtvgYI1sRIfq8qDKwpaIzfWxgxzEOkeE6q/3CDuHL5CX68Qaql+BBWQCKnDpW73+QNMngnw25N/8aAaNtGPQatECsMjPaIUZyzRO0kJ5aRq7VZp575c+zXfebMYR3rLImmfbE/GQQ2WaFGTbAR2Iw5v4XGmX0ot5DkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097096; c=relaxed/simple;
	bh=CX4H1sldVK2LJpwa7P6mgXUXQf4tXyYxu3JLIlzwTB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai3dVf+xEo0j9fp4/VAWnMgx9kQ67jOqmgsmIwsVclHGaW9qLFgwgmTiA6PWFB4DO90sxqKqDZySlEUblvH/CuLXpohDmZJltgxgzfs5VElXr7wq0RKDuYQsQqmbUhG9wMfR5pB3tftiw/7y7zaHh/HMX1g6uc8P3O2p5z8l1XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrEcQfkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrEcQfkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D5EC2BCAF;
	Mon, 13 Apr 2026 16:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097095;
	bh=CX4H1sldVK2LJpwa7P6mgXUXQf4tXyYxu3JLIlzwTB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrEcQfkUbJzEfvfPEBZMhQQs0vTaCZp1mPNxC7arKDErSIgZW8YgdVCexUWTfft8U
	 evkoHWvg1hPuOKuzuffhDTbIssfaLd3bHqtCrZjXFA692uXyDjobgE2lEUATe7WwCE
	 DawsJPngwRY3PEO6lLVMfEAieBp/+LWysLDHgrak=
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
Subject: [PATCH 6.1 53/55] rxrpc: fix reference count leak in rxrpc_server_keyring()
Date: Mon, 13 Apr 2026 18:01:27 +0200
Message-ID: <20260413155726.810367980@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


