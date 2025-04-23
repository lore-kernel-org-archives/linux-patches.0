Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44347292924;
	Wed, 23 Apr 2025 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421150; cv=none; b=pm617h8YWFIwMuLx5Z8SpNUCsV6Z4aniVpPCBB+6PiQGPcC5c6VXX1nEaal8HZcQ2sJ7ugd7npg6uYxHppsaBfYF26+fGJ//ryZ0mFTUWeWBC6UtM5j1smx3AdPur/Emk79Qs50+fqBrCrzs5Io+oFjtCmd6dVEdR0UkSdxhi1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421150; c=relaxed/simple;
	bh=fyxK4pC8hABooZLL0kJLWZ4/zVedanC1dal8t9SQFzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l05PA80OlTwae5hf/54Epxt+Pb3BuGDplJ7R1sih9cGMTV/XE5e3jtRI2eqvBnB8VdUBN1vn0ULFmLxhT2l5I2djhnccsYdQ5Ac23+p3MnclyszEl1F+0p/gEiVDBi/VxPKMYU1yKKK8uBRkMJRVulaGHeFTenQ3UL7EPMGyURs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hl1nvSG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hl1nvSG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D16EC4CEE2;
	Wed, 23 Apr 2025 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421149;
	bh=fyxK4pC8hABooZLL0kJLWZ4/zVedanC1dal8t9SQFzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hl1nvSG+9/Dx9vym27LudTSBBEWoIwo77Y8gVR05ZvQCbbJ4WYpbckT0Oa68QIKTR
	 2JGgIsUSLiCMgCak4nRS1bFjYsgUZwdbCngBU2PSDiEvjKDbgzzPUacPMBx0nK8Rfm
	 wvdPd9Yl3WKqBom4Nc4rxoolbwFMOAt8xFZo/yXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangsheng Hou <xiangsheng.hou@mediatek.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.14 156/241] virtiofs: add filesystem context source name check
Date: Wed, 23 Apr 2025 16:43:40 +0200
Message-ID: <20250423142626.916370239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1670,6 +1670,9 @@ static int virtio_fs_get_tree(struct fs_
 	unsigned int virtqueue_size;
 	int err = -EIO;
 
+	if (!fsc->source)
+		return invalf(fsc, "No source specified");
+
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.


