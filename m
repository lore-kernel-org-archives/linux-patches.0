Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B7D1B32D9;
	Thu, 15 Aug 2024 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730953; cv=none; b=S5MhXzVVRxHIUPCvJU/q3LoEVw1qxdc6jf9Qp3LUJlfvTC2Pzn8Rt7EwXX6iy40LGeUtVjGv/IM33mjZquCmVZH/w0JLS0wTe+QD+KyTagLwHBcu5SOqSa0MkMDx9l4LTofvMozZKPOu/gaH8c32pZ7N445ioAPUDvTmbHQr+8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730953; c=relaxed/simple;
	bh=leZhJWtvw4rBYeR3QFyIHWlo3i3+Q572wjH6U9D1KHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgJCDwQBMUzLi1GiAwaOmtH1SCBct5O84/yYtdO0gUQXb7amZCfuPvo+KEpVA6Qwftmumd3rLfQMhpgDZPV3PdfJHVPRHjLgHLzyvTtw6FZT/XIg6HqeRafAtOqVslEXTjnC+Q7SwJQ/b580/EazDO+Q0DhjcHvqifNfd6w98h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRfnInnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRfnInnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA52EC32786;
	Thu, 15 Aug 2024 14:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730953;
	bh=leZhJWtvw4rBYeR3QFyIHWlo3i3+Q572wjH6U9D1KHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRfnInnXOPkKoTwHzC4ciWsbbge5qNOpZkxKMYFn0eaOq+cZjvYGD2M5fMCzuCpUv
	 XLgEaEdY0lDP1VY+qtycIkE8MgLhOB7+6etAty5l3VtZfiW4YVPww5UKCUy1UQrF9P
	 YZn59maW6FoSSe3NrLn7bqwjCzoG2N3yNZ8s9JXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 44/67] net: add copy_safe_from_sockptr() helper
Date: Thu, 15 Aug 2024 15:25:58 +0200
Message-ID: <20240815131840.008697510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6309863b31dd80317cd7d6824820b44e254e2a9c ]

copy_from_sockptr() helper is unsafe, unless callers
did the prior check against user provided optlen.

Too many callers get this wrong, lets add a helper to
fix them and avoid future copy/paste bugs.

Instead of :

   if (optlen < sizeof(opt)) {
       err = -EINVAL;
       break;
   }
   if (copy_from_sockptr(&opt, optval, sizeof(opt)) {
       err = -EFAULT;
       break;
   }

Use :

   err = copy_safe_from_sockptr(&opt, sizeof(opt),
                                optval, optlen);
   if (err)
       break;

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240408082845.3957374-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7a87441c9651 ("nfc: llcp: fix nfc_llcp_setsockopt() unsafe copies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sockptr.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index bae5e2369b4f7..1c1a5d926b171 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -50,11 +50,36 @@ static inline int copy_from_sockptr_offset(void *dst, sockptr_t src,
 	return 0;
 }
 
+/* Deprecated.
+ * This is unsafe, unless caller checked user provided optlen.
+ * Prefer copy_safe_from_sockptr() instead.
+ */
 static inline int copy_from_sockptr(void *dst, sockptr_t src, size_t size)
 {
 	return copy_from_sockptr_offset(dst, src, 0, size);
 }
 
+/**
+ * copy_safe_from_sockptr: copy a struct from sockptr
+ * @dst:   Destination address, in kernel space. This buffer must be @ksize
+ *         bytes long.
+ * @ksize: Size of @dst struct.
+ * @optval: Source address. (in user or kernel space)
+ * @optlen: Size of @optval data.
+ *
+ * Returns:
+ *  * -EINVAL: @optlen < @ksize
+ *  * -EFAULT: access to userspace failed.
+ *  * 0 : @ksize bytes were copied
+ */
+static inline int copy_safe_from_sockptr(void *dst, size_t ksize,
+					 sockptr_t optval, unsigned int optlen)
+{
+	if (optlen < ksize)
+		return -EINVAL;
+	return copy_from_sockptr(dst, optval, ksize);
+}
+
 static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,
 		const void *src, size_t size)
 {
-- 
2.43.0



