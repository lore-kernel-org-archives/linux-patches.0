Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766AB1849CB;
	Tue, 18 Jun 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715586; cv=none; b=mE+xPYkGkgYqL4b2trVaQGyHVyo917eoNrcQir2UxCY6CCOev6zePgKpT8OoxT+cvyKQFM9X0FodYtzsH99MftAmX/ZmEMX8Qd3Oc3w+zxPpi1VDF3vFTFxi84gGz7j+T+KxPrwFbYVk66TkfcufD20CzjRKaTYf1zn1evI3wK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715586; c=relaxed/simple;
	bh=q4qPxQuzRtn/xti0gn0h8njn3zOAYufcwKkC7CcnIHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVbJoST+iKRcCV0lQU29qjNAxSqZXokrytjYl1LMR95qq3Oq0FEilQKeSRXAaWshycPe+2Tv8Q+ZJisQsXtXU6RuUvVf+pjqhPbMgfJoAwpO6PyaaCyBttAsP2b910M4gZ0ELzjZBc6TPONysP4PVSUiugkIB6zVIKh2mmQlWQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mv/yWyNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mv/yWyNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFE3C3277B;
	Tue, 18 Jun 2024 12:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715586;
	bh=q4qPxQuzRtn/xti0gn0h8njn3zOAYufcwKkC7CcnIHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mv/yWyNgmSu9zNqFtaLAwKbYFNZRXIdi9wxY/PBgUv3ktKOLTj6jhx/oJ8lz+N+dP
	 mG9QsvimvwgGWNQiPg4PZ02A/4zCFtvYCCw7E3lXvXfkayRTtI44V7mggJhztn2zo8
	 f9hiMnT7tPP+hwE53vd6SdRs9N6F/Qw0/WGMEPkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/770] NLM: Fix svcxdr_encode_owner()
Date: Tue, 18 Jun 2024 14:33:32 +0200
Message-ID: <20240618123421.125646041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 89c485c7a3ecbc2ebd568f9c9c2edf3a8cf7485b ]

Dai Ngo reports that, since the XDR overhaul, the NLM server crashes
when the TEST procedure wants to return NLM_DENIED. There is a bug
in svcxdr_encode_owner() that none of our standard test cases found.

Replace the open-coded function with a call to an appropriate
pre-fabricated XDR helper.

Reported-by: Dai Ngo <Dai.Ngo@oracle.com>
Fixes: a6a63ca5652e ("lockd: Common NLM XDR helpers")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcxdr.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/lockd/svcxdr.h b/fs/lockd/svcxdr.h
index c69a0bb76c940..4f1a451da5ba2 100644
--- a/fs/lockd/svcxdr.h
+++ b/fs/lockd/svcxdr.h
@@ -134,18 +134,9 @@ svcxdr_decode_owner(struct xdr_stream *xdr, struct xdr_netobj *obj)
 static inline bool
 svcxdr_encode_owner(struct xdr_stream *xdr, const struct xdr_netobj *obj)
 {
-	unsigned int quadlen = XDR_QUADLEN(obj->len);
-	__be32 *p;
-
-	if (xdr_stream_encode_u32(xdr, obj->len) < 0)
-		return false;
-	p = xdr_reserve_space(xdr, obj->len);
-	if (!p)
+	if (obj->len > XDR_MAX_NETOBJ)
 		return false;
-	p[quadlen - 1] = 0;	/* XDR pad */
-	memcpy(p, obj->data, obj->len);
-
-	return true;
+	return xdr_stream_encode_opaque(xdr, obj->data, obj->len) > 0;
 }
 
 #endif /* _LOCKD_SVCXDR_H_ */
-- 
2.43.0



