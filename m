Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8835D28F93A;
	Wed, 23 Apr 2025 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422396; cv=none; b=SaglFmv134/ab+rfN1F9cxF8Qu4nb9tfPs5v2VlnFILV6zRMUZPwYQnv+ChijlYs4sLIhpZD/DllBrFz63jtIBYpQKBFkvcWCuDl2bLtGfc5VIa6jGgwY6Lad3cyaXceK7tgzytdvVDsbaJZ/BtxmMfhvRDCSnHZwUFADDrK7+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422396; c=relaxed/simple;
	bh=EjzYxBrbWJYK0VYWSWoR8pG5mXnAnA3djs/5nrtKors=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/qlFe8NLh0QGrdqdDD61tkOrWqpL/pVrFeyaWmw9J2HQSPcn9QKWJtwWqiRVHwbTBBhQKXnNPOwscsXbknFKc7JNeIixbtFeJmEbaMGCv7YdtiwGxpE8h43ybFALbAniNEOmCE2nmznP/a6BLVUp63hslfuvGj0+CwRflNDee4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxRu1pWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxRu1pWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C958C4CEE3;
	Wed, 23 Apr 2025 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422396;
	bh=EjzYxBrbWJYK0VYWSWoR8pG5mXnAnA3djs/5nrtKors=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxRu1pWDfy0RF4A5c202s/6AeyyEW5g+wLXz/kU0P6BpFBWKkqlhw2CDD9j4lB6Xi
	 S6Cg7icbz4fht+YyfZ3uhqQ2CmSDQPS+QpVlMsAStIr0aDKMetV1FF7iEiaEZPEugO
	 dj7bQcleMIYtQANJL9o3F94xa4J5wDZx1MjtRd54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangsheng Hou <xiangsheng.hou@mediatek.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 335/393] virtiofs: add filesystem context source name check
Date: Wed, 23 Apr 2025 16:43:51 +0200
Message-ID: <20250423142657.173409450@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1430,6 +1430,9 @@ static int virtio_fs_get_tree(struct fs_
 	unsigned int virtqueue_size;
 	int err = -EIO;
 
+	if (!fsc->source)
+		return invalf(fsc, "No source specified");
+
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.


