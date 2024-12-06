Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B531527AC;
	Fri,  6 Dec 2024 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497990; cv=none; b=HPmgS3uJO4BqhqYiZ+0rxsjKc2RfEbEQMwuHLil9d7iAdv7ptEVBNPI/q128sj5dHehdK5BDpaF6vQlliNzJRsEdBjx1Zip7BPCw87wrGhUW8yzFImHkopvNqF1kjzbAsf/R2ZN6p7nTYh2hDb8L4OP7uJpPlsv1lXnPCnJjUpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497990; c=relaxed/simple;
	bh=0PGzdFV03C8OBb8Cy1TcnKT1cOI1NSbDuSZl2bshiI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUFGkY6z752B5RPLBHtlw9KC64+4KB6s/1kn6XV6KyrSBHOFuxNa80oc4Su8rAL7OgE18zB17LzKZ1d57yYipsFL8lqPomFUwHHVSj+ZdW0xCJlAdaFILIfCED/pC6VRCNFJosC6eXo2a8xp/1d8LWHcAeX/FJM9w0qUGpoL6VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckR79gnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckR79gnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D32CC4CED1;
	Fri,  6 Dec 2024 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497990;
	bh=0PGzdFV03C8OBb8Cy1TcnKT1cOI1NSbDuSZl2bshiI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckR79gnKDfXNFcRaTpxgTppdsmq8lI+RJURNYWMp/EfVW7kYHOGcp/gmdKaji4ek5
	 5q6Mvhl2o0oaNOLgMtVtWeSwauwr3cFCdwLIybVKWQ8yYhS8QNd3u0Jua4sFmlp3Lg
	 ysle3X/Jb37/dTjaUeq2VifZDh4bcuOr7VEDba9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 422/676] rxrpc: Improve setsockopt() handling of malformed user input
Date: Fri,  6 Dec 2024 15:34:01 +0100
Message-ID: <20241206143709.829837357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 02020056647017e70509bb58c3096448117099e1 ]

copy_from_sockptr() does not return negative value on error; instead, it
reports the number of bytes that failed to copy. Since it's deprecated,
switch to copy_safe_from_sockptr().

Note: Keeping the `optlen != sizeof(unsigned int)` check as
copy_safe_from_sockptr() by itself would also accept
optlen > sizeof(unsigned int). Which would allow a more lenient handling
of inputs.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/af_rxrpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index fa8aec78f63d7..205e0d4d048ea 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -661,9 +661,10 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EISCONN;
 			if (rx->sk.sk_state != RXRPC_UNBOUND)
 				goto error;
-			ret = copy_from_sockptr(&min_sec_level, optval,
-				       sizeof(unsigned int));
-			if (ret < 0)
+			ret = copy_safe_from_sockptr(&min_sec_level,
+						     sizeof(min_sec_level),
+						     optval, optlen);
+			if (ret)
 				goto error;
 			ret = -EINVAL;
 			if (min_sec_level > RXRPC_SECURITY_MAX)
-- 
2.43.0



