Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DA116EB6D;
	Tue, 18 Jun 2024 12:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715417; cv=none; b=WakBCAZomZScMFBWSgsSXf6lIAN7q8eyauyeWCPYOAKXVuCTnEoe7M9nhPrbtiDbm0uEnAzGzSiXy87jbndlqRLXwawf4cr6wJ6tbwtTJYFWDI/fc5hkkeEpJYHFqXdWV2ZXhT6HFhF//w8lmUDaTslRwEWSKIjDbmxwzq9IFog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715417; c=relaxed/simple;
	bh=DhXQPNYqm59htBLuVt//3frGscvJCyb708hwZJIpt6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAuyz6aLIehipYKUBAlkheuxzuE6818IOvuVQm5zoGF43IAaa4r8Af+u4YS5U/E0ZgXxsVijQRpKxQ8MlBLNirdNl2PjA399zk8pc88KBEGzR4+rcbX3da1vQFeJHPrbSPyxDlUqIA4+5h2hbqGEjCXsjTZKv0+xttb/f7mXT5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSI8mU9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSI8mU9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C90C3277B;
	Tue, 18 Jun 2024 12:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715416;
	bh=DhXQPNYqm59htBLuVt//3frGscvJCyb708hwZJIpt6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSI8mU9YC2dWgm9KSeW2O7VWZZkfTpojyPf+YQKXgvEi5u+MGcB1jNB1LjAXcntAL
	 mCWZ3jzIjEqT6x5W2f9ymounXyjUl0A6c8ij5uhz5jZj+LaAIPo1erzWA37xCDVQms
	 rtltgO/ASGzTMmvxbrRakIomHHbtWO+BpZcSwUkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 301/770] lockd: Common NLM XDR helpers
Date: Tue, 18 Jun 2024 14:32:34 +0200
Message-ID: <20240618123418.883515319@linuxfoundation.org>
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

[ Upstream commit a6a63ca5652ea05637ecfe349f9e895031529556 ]

Add a .h file containing xdr_stream-based XDR helpers common to both
NLMv3 and NLMv4.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcxdr.h | 151 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)
 create mode 100644 fs/lockd/svcxdr.h

diff --git a/fs/lockd/svcxdr.h b/fs/lockd/svcxdr.h
new file mode 100644
index 0000000000000..c69a0bb76c940
--- /dev/null
+++ b/fs/lockd/svcxdr.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Encode/decode NLM basic data types
+ *
+ * Basic NLMv3 XDR data types are not defined in an IETF standards
+ * document.  X/Open has a description of these data types that
+ * is useful.  See Chapter 10 of "Protocols for Interworking:
+ * XNFS, Version 3W".
+ *
+ * Basic NLMv4 XDR data types are defined in Appendix II.1.4 of
+ * RFC 1813: "NFS Version 3 Protocol Specification".
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2020, Oracle and/or its affiliates.
+ */
+
+#ifndef _LOCKD_SVCXDR_H_
+#define _LOCKD_SVCXDR_H_
+
+static inline bool
+svcxdr_decode_stats(struct xdr_stream *xdr, __be32 *status)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(xdr, XDR_UNIT);
+	if (!p)
+		return false;
+	*status = *p;
+
+	return true;
+}
+
+static inline bool
+svcxdr_encode_stats(struct xdr_stream *xdr, __be32 status)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT);
+	if (!p)
+		return false;
+	*p = status;
+
+	return true;
+}
+
+static inline bool
+svcxdr_decode_string(struct xdr_stream *xdr, char **data, unsigned int *data_len)
+{
+	__be32 *p;
+	u32 len;
+
+	if (xdr_stream_decode_u32(xdr, &len) < 0)
+		return false;
+	if (len > NLM_MAXSTRLEN)
+		return false;
+	p = xdr_inline_decode(xdr, len);
+	if (!p)
+		return false;
+	*data_len = len;
+	*data = (char *)p;
+
+	return true;
+}
+
+/*
+ * NLM cookies are defined by specification to be a variable-length
+ * XDR opaque no longer than 1024 bytes. However, this implementation
+ * limits their length to 32 bytes, and treats zero-length cookies
+ * specially.
+ */
+static inline bool
+svcxdr_decode_cookie(struct xdr_stream *xdr, struct nlm_cookie *cookie)
+{
+	__be32 *p;
+	u32 len;
+
+	if (xdr_stream_decode_u32(xdr, &len) < 0)
+		return false;
+	if (len > NLM_MAXCOOKIELEN)
+		return false;
+	if (!len)
+		goto out_hpux;
+
+	p = xdr_inline_decode(xdr, len);
+	if (!p)
+		return false;
+	cookie->len = len;
+	memcpy(cookie->data, p, len);
+
+	return true;
+
+	/* apparently HPUX can return empty cookies */
+out_hpux:
+	cookie->len = 4;
+	memset(cookie->data, 0, 4);
+	return true;
+}
+
+static inline bool
+svcxdr_encode_cookie(struct xdr_stream *xdr, const struct nlm_cookie *cookie)
+{
+	__be32 *p;
+
+	if (xdr_stream_encode_u32(xdr, cookie->len) < 0)
+		return false;
+	p = xdr_reserve_space(xdr, cookie->len);
+	if (!p)
+		return false;
+	memcpy(p, cookie->data, cookie->len);
+
+	return true;
+}
+
+static inline bool
+svcxdr_decode_owner(struct xdr_stream *xdr, struct xdr_netobj *obj)
+{
+	__be32 *p;
+	u32 len;
+
+	if (xdr_stream_decode_u32(xdr, &len) < 0)
+		return false;
+	if (len > XDR_MAX_NETOBJ)
+		return false;
+	p = xdr_inline_decode(xdr, len);
+	if (!p)
+		return false;
+	obj->len = len;
+	obj->data = (u8 *)p;
+
+	return true;
+}
+
+static inline bool
+svcxdr_encode_owner(struct xdr_stream *xdr, const struct xdr_netobj *obj)
+{
+	unsigned int quadlen = XDR_QUADLEN(obj->len);
+	__be32 *p;
+
+	if (xdr_stream_encode_u32(xdr, obj->len) < 0)
+		return false;
+	p = xdr_reserve_space(xdr, obj->len);
+	if (!p)
+		return false;
+	p[quadlen - 1] = 0;	/* XDR pad */
+	memcpy(p, obj->data, obj->len);
+
+	return true;
+}
+
+#endif /* _LOCKD_SVCXDR_H_ */
-- 
2.43.0



