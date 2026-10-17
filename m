Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899483822B7;
	Sat, 17 Oct 2026 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254937; cv=none; b=huRX0C7/AqGLbQurtDghc15V8IskskK61VArsPZ5UY5SpnohNNO6ZYrkOwIe1ihM3+QXEb5gKgD3s43VSF5y5C0tin30qlFPokHb2SvPtj2k6MdXKhL92ZYw8zMhORXMVFbs850zmAwEvtWUa09R56BNoHG17W2p8CZL33LFZBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254937; c=relaxed/simple;
	bh=T8LD23wBhu8YCZQb245b+VkievsiRSMm4zwGmHr8I2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4V1HJro7a/HkuXcT3PZfx94O2QENfVGSQg5tVOCrSMLtViTGkdaGn21lQ+8MaviBNvpa92nePeUZElCH4JZfmNT7DofsvlrlKMBu0dZqKvRvfyacI7VDvcnvgKO9vBHE3gRHe1dzE3DkCHxG3S7N7wyBLTvof/tieiN0mTe0ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tdnafmho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tdnafmho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14E71F000C4;
	Sat, 17 Oct 2026 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254936;
	bh=aiQrVxS4W5YDhv/hvWjevDstGt4p/mJz0a1hLBcPFg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdnafmhohLY4+nOn4GJcZR8dtYCvpOEQnXImU6VjGuUcniQalfmJEDot0XmFZ9aEe
	 of/lIhLHf8AENGdPnMoiIEFR84kcziTz8p5A0s+a+aGPWPu1lMnuYInqXJRoVUxGO7
	 QSS++jAo7sfXRO9/UiRXkkUH9crow64tb3IAWSQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Breno Leitao <leitao@debian.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 604/869] net: add getsockopt_iter callback to proto_ops
Date: Sat, 17 Oct 2026 17:57:25 +0200
Message-ID: <20261017160052.528143968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 67fab22a7adcec0279b9b057eb3dc669e32834f0 ]

Add a new getsockopt_iter callback to struct proto_ops that uses
sockopt_t, a type-safe wrapper around iov_iter. This provides a clean
interface for socket option operations that works with both user and
kernel buffers.

The sockopt_t type encapsulates an iov_iter and an optlen field.

The optlen field, although not suggested by Linus, serves as both input
(buffer size) and output (returned data size), allowing callbacks to
return random values independent of the bytes written via
copy_to_iter(), so, keep it separated from iov_iter.count.

This is preparatory work for removing the SOL_SOCKET level restriction
from io_uring getsockopt operations.

Keep in mind that both iter_out and iter_in always point to the same
data at all times, and we just have two of them to make the callback
implementation sane.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260408-getsockopt-v3-1-061bb9cb355d@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ca2c4c264986 ("Bluetooth: L2CAP: access chan->conn safely in get/setsockopt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/net.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index b75bc534c1b35..c6d92428c71a5 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -23,9 +23,30 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/sockptr.h>
+#include <linux/uio.h>
 
 #include <uapi/linux/net.h>
 
+/**
+ * struct sockopt - socket option value container
+ * @iter_in: iov_iter for reading optval with the content from the caller.
+ *	     Use copy_from_iter() given this iov direction is ITER_SOURCE
+ * @iter_out: iov_iter for protocols to update optval data to userspace
+ *	      Use _copy_to_iter() given iov direction is ITER_DEST
+ * @optlen: serves as both input (buffer size) and output (returned data size).
+ *
+ * Type-safe wrapper for socket option data that works with both
+ * user and kernel buffers.
+ *
+ * The optlen field allows callbacks to return a specific length value
+ * independent of the bytes written via copy_to_iter().
+ */
+typedef struct sockopt {
+	struct iov_iter iter_in;
+	struct iov_iter iter_out;
+	int optlen;
+} sockopt_t;
+
 struct poll_table_struct;
 struct pipe_inode_info;
 struct inode;
@@ -194,6 +215,8 @@ struct proto_ops {
 				      unsigned int optlen);
 	int		(*getsockopt)(struct socket *sock, int level,
 				      int optname, char __user *optval, int __user *optlen);
+	int		(*getsockopt_iter)(struct socket *sock, int level,
+					   int optname, sockopt_t *opt);
 	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
 	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
 				      size_t total_len);
-- 
2.53.0



