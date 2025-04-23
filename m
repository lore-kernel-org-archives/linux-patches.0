Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4DD1F193C;
	Wed, 23 Apr 2025 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420466; cv=none; b=BDGdcIi7H07BVozBTQcPDqUxw2fvKcWjJAdBmHQp/DVdhyR4QkRdRi1upuYWkfQ+dZY0LcLMoZ36/IiZSv8jzL+7FG00+4dOkWeJ1cA9llD5OMuMaJK6AGtGUs4pQ+fpLlhI+Cp+uBxpF9spAQ4t+djn6V52KIUYiy6oeLTGBHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420466; c=relaxed/simple;
	bh=DZzMKOD+Adys665PKV175Zi8jxMKGgCr5tcmLvVnY9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1cNyBMnVCK/Ck9ISCv9uuj4iIvMw/2RcmpypCS6fV3CbFlS/PYHYMzuoxA+BkWnvzm/papizGRhnumUYwlcz0PTteU2BUVNpJqklpgAoaf2MLJrnYfTw3ReG7/devyOQuUJB0IJyYCBU+YMeEkkgee8e2exVcx5sj1y4pUko9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGE3hDOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGE3hDOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4216EC4CEE2;
	Wed, 23 Apr 2025 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420466;
	bh=DZzMKOD+Adys665PKV175Zi8jxMKGgCr5tcmLvVnY9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGE3hDOMTx1bKQ8dvFofAptqiKetXpXGDUl5r1Bxstzma1ToK08kbkO7XkumtDq8c
	 BZp7zHAhg6S5QIGxEyZ+XQI8glvvKkmWwtaKqNQttJ5OipWUNUwskADzB1kFwCwRbU
	 U0d0RmZfceIutYtgZh9VYjkqbU7SjwwHpKtaVCT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangsheng Hou <xiangsheng.hou@mediatek.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 134/223] virtiofs: add filesystem context source name check
Date: Wed, 23 Apr 2025 16:43:26 +0200
Message-ID: <20250423142622.550126221@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xiangsheng Hou <xiangsheng.hou@mediatek.com>

commit a94fd938df2b1628da66b498aa0eeb89593bc7a2 upstream.

In certain scenarios, for example, during fuzz testing, the source
name may be NULL, which could lead to a kernel panic. Therefore, an
extra check for the source name should be added.

Fixes: a62a8ef9d97d ("virtio-fs: add virtiofs filesystem")
Cc: <stable@vger.kernel.org> # all LTS kernels
Signed-off-by: Xiangsheng Hou <xiangsheng.hou@mediatek.com>
Link: https://lore.kernel.org/20250407115111.25535-1-xiangsheng.hou@mediatek.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/virtio_fs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1663,6 +1663,9 @@ static int virtio_fs_get_tree(struct fs_
 	unsigned int virtqueue_size;
 	int err = -EIO;
 
+	if (!fsc->source)
+		return invalf(fsc, "No source specified");
+
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.


