Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280D01E2834;
	Wed, 25 Feb 2026 01:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984027; cv=none; b=R73fgE1+Nu6vO5mORlwCqvs4GiT3dMrsaxjK5U34LsgWIII3HZ4uROAekPs2mZAPfvziGd7yixYRgNNjJu9AlA2hQiy30zk0mtDiYhXDzWAkojUbI+9eMaRq9wi1hASB4H2FAnMfCDdd67Tb+AagnosmVsWSriT3Oem/FLK+TuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984027; c=relaxed/simple;
	bh=tCFPXmX9QyxRJSa8af2oCH1KjlIDsprq4UjolVIxtkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMyGb5QtsK0korQstkjqtSI4pO2TU7Ml10KnpUTbzV/7Q3aCCTaTOh3oAeV8Mv0GMHKxS+VjAUrDOHlWvCk9z2/RRZ8g2RPg0wgb1E6L6Nx4RfFzKRWdm0crJdeByuxXySVJy6xOScVlf1GUsQiXilNk9kdTvXWgz9T76mgtTJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oC4jtvIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oC4jtvIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF63EC116D0;
	Wed, 25 Feb 2026 01:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984027;
	bh=tCFPXmX9QyxRJSa8af2oCH1KjlIDsprq4UjolVIxtkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oC4jtvINcEjq/peJebKUTpleRKRgyR1LJnUc6MVRoPbaaYtjw5zt5lmR9OhbHffBy
	 lqW3oGXJNopYLtAbvFApZG2N7ABESmLBt3S0jTT7JITYjq/jWGNfkRLCpn1tMI8pz5
	 nlj2FCzKmNSg1KNa0JKcvJFnW8/JzbtikBE/fQpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 272/641] xdrgen: Initialize data pointer for zero-length items
Date: Tue, 24 Feb 2026 17:19:58 -0800
Message-ID: <20260225012355.385232588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



