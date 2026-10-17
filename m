Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC9F3B7770;
	Sat, 17 Oct 2026 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259779; cv=none; b=L1b/xJHsWCtHLSCjb/DhKqivVvhRq2xy5YIkbAgODqLSuDoy4/QNPeDG8Zeu5ScgeLV7bo+lMzaJWtBVqBVe7zf9wEhS47xm9oK6LNUXBX/10XvcqLfozOWdUdPZsFcv3TPLPdDmWbXQ6u1YcwKYvbXfjCTcsvie1NYNfGbN4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259779; c=relaxed/simple;
	bh=I+ABkncaGdvzYa9RXZp45Ocbp2a2mcu9Ps7CN6x3n8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEr329NYQBjRFxeoe+7o8a0k3evTjTyluI+r4OgMis2kKTssQfKobMqO+kJFVRgX18QKcEGLId//pJn3yFDxynCyjRF9fQNb17C5olus+Z78DMSJubGCLBxaMTZr7fQ5Wooo30v9P8JCjfvmmF35ocyU0u55jQ8UyJ1glPaMO2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4ihky79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4ihky79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC1B1F000C4;
	Sat, 17 Oct 2026 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259777;
	bh=SO3kXsJ0i774xa53HOecBsZU/h6yuch4xM0iUix3wXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4ihky79Ds2EIHNCkjFUOo2px9J/w4ARU2j67/4o9mI0yYsoWuO5sqkxspx6v6MEp
	 LMTMMqZ4dTLCnE2gglE9/4hChgQyYCqmHThtiG3tb3vQtu/kBy/SgKUMXhLwSPEkR0
	 KICx+cp/745zVa6meBE7QNI8TXhlBhCJ0NDgPjMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1320/1674] NFSD: Add simple u32, u64, and bool encoders
Date: Sat, 17 Oct 2026 17:59:52 +0200
Message-ID: <20261017160505.027924595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6cc58291408bea96787d06ca3f5074fdfb3152ca ]

The generic XDR encoders return a length or a negative errno. NFSv4
encoders want to know simply whether the encode ran out of stream
buffer space. The return values for server-side encoding are either
nfs_ok or nfserr_resource.

So far I've found it adds a lot of duplicate code to try to use the
generic XDR encoder utilities when encoding the simple data types in
the NFSv4 operation encoders.

Add a set of NFSv4-specific utilities that handle the basic XDR data
types. These are added in xdr4.h so they might eventually be used by
the callback server and pNFS driver encoders too.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: ca94ba361720 ("nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on racing delegation revoke")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/xdr4.h | 111 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index a83a52b0f5181..c2bc10051b228 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -50,6 +50,117 @@
 #define HAS_CSTATE_FLAG(c, f) ((c)->sid_flags & (f))
 #define CLEAR_CSTATE_FLAG(c, f) ((c)->sid_flags &= ~(f))
 
+/**
+ * nfsd4_encode_bool - Encode an XDR bool type result
+ * @xdr: target XDR stream
+ * @val: boolean value to encode
+ *
+ * Return values:
+ *    %nfs_ok: @val encoded; @xdr advanced to next position
+ *    %nfserr_resource: stream buffer space exhausted
+ */
+static __always_inline __be32
+nfsd4_encode_bool(struct xdr_stream *xdr, bool val)
+{
+	__be32 *p = xdr_reserve_space(xdr, XDR_UNIT);
+
+	if (unlikely(p == NULL))
+		return nfserr_resource;
+	*p = val ? xdr_one : xdr_zero;
+	return nfs_ok;
+}
+
+/**
+ * nfsd4_encode_uint32_t - Encode an XDR uint32_t type result
+ * @xdr: target XDR stream
+ * @val: integer value to encode
+ *
+ * Return values:
+ *    %nfs_ok: @val encoded; @xdr advanced to next position
+ *    %nfserr_resource: stream buffer space exhausted
+ */
+static __always_inline __be32
+nfsd4_encode_uint32_t(struct xdr_stream *xdr, u32 val)
+{
+	__be32 *p = xdr_reserve_space(xdr, XDR_UNIT);
+
+	if (unlikely(p == NULL))
+		return nfserr_resource;
+	*p = cpu_to_be32(val);
+	return nfs_ok;
+}
+
+/**
+ * nfsd4_encode_uint64_t - Encode an XDR uint64_t type result
+ * @xdr: target XDR stream
+ * @val: integer value to encode
+ *
+ * Return values:
+ *    %nfs_ok: @val encoded; @xdr advanced to next position
+ *    %nfserr_resource: stream buffer space exhausted
+ */
+static __always_inline __be32
+nfsd4_encode_uint64_t(struct xdr_stream *xdr, u64 val)
+{
+	__be32 *p = xdr_reserve_space(xdr, XDR_UNIT * 2);
+
+	if (unlikely(p == NULL))
+		return nfserr_resource;
+	put_unaligned_be64(val, p);
+	return nfs_ok;
+}
+
+/**
+ * nfsd4_encode_opaque_fixed - Encode a fixed-length XDR opaque type result
+ * @xdr: target XDR stream
+ * @data: pointer to data
+ * @size: length of data in bytes
+ *
+ * Return values:
+ *    %nfs_ok: @data encoded; @xdr advanced to next position
+ *    %nfserr_resource: stream buffer space exhausted
+ */
+static __always_inline __be32
+nfsd4_encode_opaque_fixed(struct xdr_stream *xdr, const void *data,
+			  size_t size)
+{
+	__be32 *p = xdr_reserve_space(xdr, xdr_align_size(size));
+	size_t pad = xdr_pad_size(size);
+
+	if (unlikely(p == NULL))
+		return nfserr_resource;
+	memcpy(p, data, size);
+	if (pad)
+		memset((char *)p + size, 0, pad);
+	return nfs_ok;
+}
+
+/**
+ * nfsd4_encode_opaque - Encode a variable-length XDR opaque type result
+ * @xdr: target XDR stream
+ * @data: pointer to data
+ * @size: length of data in bytes
+ *
+ * Return values:
+ *    %nfs_ok: @data encoded; @xdr advanced to next position
+ *    %nfserr_resource: stream buffer space exhausted
+ */
+static __always_inline __be32
+nfsd4_encode_opaque(struct xdr_stream *xdr, const void *data, size_t size)
+{
+	size_t pad = xdr_pad_size(size);
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT + xdr_align_size(size));
+	if (unlikely(p == NULL))
+		return nfserr_resource;
+	*p++ = cpu_to_be32(size);
+	memcpy(p, data, size);
+	if (pad)
+		memset((char *)p + size, 0, pad);
+	return nfs_ok;
+}
+
 struct nfsd4_compound_state {
 	struct svc_fh		current_fh;
 	struct svc_fh		save_fh;
-- 
2.53.0



