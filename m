Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE511D5ABA;
	Wed, 25 Feb 2026 01:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983212; cv=none; b=NaGO1Wtu2XxGbZ1atOqBFmU/tOEVJcfbMUzBra6lCQQpXDwixeIuAj0zdg0yC/zU3lBJFfkIwmIXqTh1w8UK3f0t9pVKoTqV2OmTSJXvcofXjU7lctJtteIix8WvPaNPJFmUkh/+nW6yLMUXLaKHRtH9o6LfoyQRwpaDv2kpM6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983212; c=relaxed/simple;
	bh=Ppo/N4+2Hs/UqJNmmm/0twJcI1VZ7MTnBhCOO5ff5Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3+s5W5wCl2Y5nvEpsCF/qyApuZowELJG2Zf6Z6uW0f5N4D/0UTwSiRAISuirNBAx/VpgQcjwILmFy2svr6rM2EyBMaSeF8edIijgqdyTI8xUZRE2MvdZ5Fj3RQjIKtIwge1it2KpifWiaAnDR0HAb8syoGGysgHwdWX1UHLU1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgEAVzT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgEAVzT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF99C116D0;
	Wed, 25 Feb 2026 01:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983212;
	bh=Ppo/N4+2Hs/UqJNmmm/0twJcI1VZ7MTnBhCOO5ff5Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgEAVzT5zfN5tXomlawusggIMaW5rfmeWjMNWauND79lQm2sOKjPPctNKYA4uFDW6
	 Zoz4nHtnwJGDkpPfs9j6m2S7MBZAqF0oxRKcm6z9paywQh5mY08cor7mBkgP3R4o14
	 WZo+zycdkBRqWbzPX1AebOj0GxCrfHeerMCKxYew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 361/781] xdrgen: Initialize data pointer for zero-length items
Date: Tue, 24 Feb 2026 17:17:50 -0800
Message-ID: <20260225012408.538095029@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



