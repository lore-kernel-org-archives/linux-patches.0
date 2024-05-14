Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865C8139CE4;
	Tue, 14 May 2024 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683044; cv=none; b=GViPyKzYT/e4DC2IZcra5DeCJlY23bYyxtQLIfMD2/tUjn97F+mN5KqdCXeexwCZ+G1uiR7Dbue1gTQAoGnHNfFgPI8l0Gp1NcB62gA4OAodcf+MG14VwxaxddlvPuEDBuWK56JNRVK+Sr6GAdqqNV9t8SLssSCeXmxasLwJ4wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683044; c=relaxed/simple;
	bh=wBtC3lwWXy4lNeXMjMd+oWR6yG1tzvee/D1af1tVzxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7wP8fCqF9iw54gxw56x9AjNCcDw0dzRSrN8Qj1fL3ZTt/dwJQ+SlHkECuIRIDv8ADXo7oI4YSzhWIP2jrCp69YfeUXnFCLsa/fSvvZGbtbAgMyOnAYcVh8LH4Xa4oV0LtkGt5AqD3T0diLonNZFrM390FvjzMYeIFldSx//qEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4LF3iYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4LF3iYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDC2C2BD10;
	Tue, 14 May 2024 10:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683044;
	bh=wBtC3lwWXy4lNeXMjMd+oWR6yG1tzvee/D1af1tVzxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4LF3iYdcQwpobnswpNAm49RRHfvtmyDqrHTU99rZXgvOrdi9CTv9nG+q62Kicvnz
	 6fug9LiGkaRcn97+YhNbTkYZtZKcotpmi0VinXvcyUPrEZ5jABnNMwcpnmwR7mFgX8
	 qCuZUSSV2KwdTrqYHHr0VgZMLfndWePXHdSoTFPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 157/336] net: add copy_safe_from_sockptr() helper
Date: Tue, 14 May 2024 12:16:01 +0200
Message-ID: <20240514101044.531949964@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sockptr.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 307961b41541a..317200cd3a603 100644
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
 static inline int copy_struct_from_sockptr(void *dst, size_t ksize,
 		sockptr_t src, size_t usize)
 {
-- 
2.43.0



