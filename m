Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26AB1BDA80;
	Wed, 20 Nov 2024 13:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107695; cv=none; b=IE45dw5KP+OvtIHJEIWfRF0QPsvk041iZIZQSMYiVjmj1QPzNVokAt2W5xhNJ2LPYxgdDXFhmdiNCErO571zCsMbEKjSh8TR8J7FIh4qEH50E+qk0LLMQeDYqKg+QPEwesRUZJMXIW0cjHSUnje7AKiDlv2k1k+aoXMl17juxnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107695; c=relaxed/simple;
	bh=nkuglvUNFKLoPtCTjI3/n7PfKxhbZsfnvpeU6fUfTsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kg9Kp+unvaknsCARXR/zl9U3U0zUn62FsYyqhlKVgXcDyfu1ztv1RI9pZ8R9g3iXMRZmTfuGgGdw+50fBCz08CNdHTeAa6nk0/Uqv/sK4f8KfvfkknfAhigFuUcEwM77WpuCzyOzq1gb8clIUV6c5sdmJ1Src5mXASn+AIJrpx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iy5UdOgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iy5UdOgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A70CC4CECD;
	Wed, 20 Nov 2024 13:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107695;
	bh=nkuglvUNFKLoPtCTjI3/n7PfKxhbZsfnvpeU6fUfTsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iy5UdOgc4KQ2vQ6lggtsXYO84lasd0SxGIkjhSnhqNys9/VN4QfA98MCgiMeaWTl9
	 eTHW3/6XqSVxbhbExIkEFR4cW+KmHY5WU+T0mMb6uYtDdliz8yaSvBZFZPEwQLeuGs
	 7lrCfsCD1kRGxQfbf2gXFtiSJnlr83exj1Hyl8nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 55/73] net: add copy_safe_from_sockptr() helper
Date: Wed, 20 Nov 2024 13:58:41 +0100
Message-ID: <20241120125810.931234007@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sockptr.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -50,11 +50,36 @@ static inline int copy_from_sockptr_offs
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


