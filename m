Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FE1338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301794; cv=none; b=rIXogsyN5EH/3XHxqqsiH+o+OQ5De6E53n6wPhj6qtUmHEquvKXhqkQjnfJZnWdS9Jp+mmL0RQjFnFoGRybOWK1EhnIUr3U7fuiOTfprKu+rfvYww1NS4FPcEXib2Hkl2Nuhdv/7Ifo5ryc+g4yCuht7gP8U72WiagVsOsZg4a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301794; c=relaxed/simple;
	bh=sFWn+EMAatgc7zjbsy8Y2e2zDf/3AnVLzVbXOmXBje8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWsyKkQ00h0np7bTOiY9BTo7HpVDTDLurlAlaCVvfvGGQYZdxF41nfMHOqDf0y+NOExTKzosAoc5A6zc0e3ER8s0YEulJeOXoATXnUDSdSHKkwHJ9Hw2Be2hp8TsshKoPQaNcPQyNzcKwaCHF24Sb+ceChRvIcuItxbBMb45tg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/Mob2zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/Mob2zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31679C116D0;
	Sat, 28 Feb 2026 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301794;
	bh=sFWn+EMAatgc7zjbsy8Y2e2zDf/3AnVLzVbXOmXBje8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/Mob2zvvTHzDYrVUgXqKiNcUiR+QaK3dXEbf/OW197RcLDyCpg5ldStQ0QcxoKQa
	 gtXDiufJxN2ysfvQcfjaGC8RX50FhxOanmqG6C1zrRb9fYTh1p1VaHjKi8X/93XroX
	 kq3yINL9wAOUszj7shOKJtuaMKi9ffFNmru2DvsaQPkatBxITtRN02YO4cGukuEvAl
	 0BEQGrIUaSTDOcgF5q6bcBmZ98MNqIWcBHP6EumoTHtO/HxWnkPxLE0o1czWA0VFq8
	 gZ0IKix5P9tQx7gTN7WE1BKhZD8p+nBxwPtGmpzQkl40KNnyN/YzhpZk4xpA2NvEiu
	 pswzDVcwC7yvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/385] xdrgen: Initialize data pointer for zero-length items
Date: Sat, 28 Feb 2026 12:57:07 -0500
Message-ID: <20260228180011.1568201-205-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 27b0fcae8f535fb882b1876227a935dcfdf576aa ]

The xdrgen decoders for strings and opaque data had an
optimization that skipped calling xdr_inline_decode() when the
item length was zero. This left the data pointer uninitialized,
which could lead to unpredictable behavior when callers access
it.

Remove the zero-length check and always call xdr_inline_decode().
When passed a length of zero, xdr_inline_decode() returns the
current buffer position, which is valid and matches the behavior
of hand-coded XDR decoders throughout the kernel.

Fixes: 4b132aacb076 ("tools: Add xdrgen")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdrgen/_builtins.h | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/include/linux/sunrpc/xdrgen/_builtins.h b/include/linux/sunrpc/xdrgen/_builtins.h
index 66ca3ece951ab..a5ab75d2db044 100644
--- a/include/linux/sunrpc/xdrgen/_builtins.h
+++ b/include/linux/sunrpc/xdrgen/_builtins.h
@@ -188,12 +188,10 @@ xdrgen_decode_string(struct xdr_stream *xdr, string *ptr, u32 maxlen)
 		return false;
 	if (unlikely(maxlen && len > maxlen))
 		return false;
-	if (len != 0) {
-		p = xdr_inline_decode(xdr, len);
-		if (unlikely(!p))
-			return false;
-		ptr->data = (unsigned char *)p;
-	}
+	p = xdr_inline_decode(xdr, len);
+	if (unlikely(!p))
+		return false;
+	ptr->data = (unsigned char *)p;
 	ptr->len = len;
 	return true;
 }
@@ -219,12 +217,10 @@ xdrgen_decode_opaque(struct xdr_stream *xdr, opaque *ptr, u32 maxlen)
 		return false;
 	if (unlikely(maxlen && len > maxlen))
 		return false;
-	if (len != 0) {
-		p = xdr_inline_decode(xdr, len);
-		if (unlikely(!p))
-			return false;
-		ptr->data = (u8 *)p;
-	}
+	p = xdr_inline_decode(xdr, len);
+	if (unlikely(!p))
+		return false;
+	ptr->data = (u8 *)p;
 	ptr->len = len;
 	return true;
 }
-- 
2.51.0

