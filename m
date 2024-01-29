Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B9A6FDF8;
	Mon, 29 Jan 2024 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548483; cv=none; b=IqSe7m3YYV6c04S4QfYMq60ORYdxUFH/71Jtdy04vHx0/Po0jaQnGGjjMxp6YSzo1Y4+vjZK8BfDBR8tCJ13r/1t+Z4wKwyF+9sqViRCfsfz6foxVSyyxOAkfte4c/27Y6HaRfq3WalQ7tcMVrNfkUXT9XpGzWb9uTLGS+b3RSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548483; c=relaxed/simple;
	bh=kSPfkoGpoTHCjVq6jogB+IiEDz6ls1TNjX7CrAWhJpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdwceB23thrCZf6lk9JMARrZsWXJOWTyVWtuZr4hnDYtiqWUJY6hV1narFnUspD2uInGtjCDABGgDCFK1LEEC1pMVaNPefjyULwRfKVF0qgMdmWeP937T1ANk7SBG5RkVOa07g2lKex8Bd3kok07eC4v6ZLqGQUNYq9Q6yJU63w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woHqWWmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woHqWWmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BF9C43390;
	Mon, 29 Jan 2024 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548483;
	bh=kSPfkoGpoTHCjVq6jogB+IiEDz6ls1TNjX7CrAWhJpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woHqWWmpnDlfEKFqYzsxcqlPoTaGrjg7OlXsBUCU3vRUZJr/b0tX/agLawSAGZQme
	 qIwtpho7CkbB8iiAj9dlc+TS5cDz4uyQ3zCicOAjK4prmpU5svtdZchtWfYEPgMkZx
	 FCqAv+k0U68FtZPz57rR83TOob8c9Lw8bJ3OlqRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 103/331] media: videobuf2-dma-sg: fix vmap callback
Date: Mon, 29 Jan 2024 09:02:47 -0800
Message-ID: <20240129170017.950165654@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 608ca5a60ee47b48fec210aeb7a795a64eb5dcee upstream.

For dmabuf import users to be able to use the vaddr from another
videobuf2-dma-sg source, the exporter needs to set a proper vaddr on
vb2_dma_sg_dmabuf_ops_vmap callback. This patch adds vmap on map if
buf->vaddr was not set.

Cc: stable@kernel.org
Fixes: 7938f4218168 ("dma-buf-map: Rename to iosys-map")
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Acked-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -487,9 +487,15 @@ vb2_dma_sg_dmabuf_ops_end_cpu_access(str
 static int vb2_dma_sg_dmabuf_ops_vmap(struct dma_buf *dbuf,
 				      struct iosys_map *map)
 {
-	struct vb2_dma_sg_buf *buf = dbuf->priv;
+	struct vb2_dma_sg_buf *buf;
+	void *vaddr;
 
-	iosys_map_set_vaddr(map, buf->vaddr);
+	buf = dbuf->priv;
+	vaddr = vb2_dma_sg_vaddr(buf->vb, buf);
+	if (!vaddr)
+		return -EINVAL;
+
+	iosys_map_set_vaddr(map, vaddr);
 
 	return 0;
 }


