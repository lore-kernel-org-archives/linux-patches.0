Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E901D5146;
	Tue, 15 Oct 2024 13:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998386; cv=none; b=a8tOjZMPNPe+gsZCsidjKzIFgkNioti5hQhX2CQlVvZOxdY+09czh3Gvos4iATDZQ0stZKtFdT3iAhDYxTJsq8VLGEiI3ajZ04Oer8VCyTtkXFmoMj1qsdtNofoLRvtZXZOrJ1zy4yWZphlKmUyjWV5hlxXGA6TMxgwqRm3ErUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998386; c=relaxed/simple;
	bh=k4WyfpZNvkj/wxOzz14iTeWvI8M8qwUu8+jmVr5ihiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvrfqmJ6KfnOVqRnTiAAK0dI+w/gBvuGoBZsUlntJRkJtLx8HSOVAZ1OOLUxYipN/n8cTw64PD3BmAjyH9iV0P9fd5SXrWEfWLSDco0rrliI2LlH59Tlwl6sM2sfw7/4pbEvfOyphII9GZIuDnTtd06zrG04Z8l694i3RbjXrcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtGLVn/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtGLVn/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4052C4CEC6;
	Tue, 15 Oct 2024 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998386;
	bh=k4WyfpZNvkj/wxOzz14iTeWvI8M8qwUu8+jmVr5ihiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtGLVn/RtLBGysas2a5kS3i+iUJy4tqpaSNaioeYJwXd3QD6DdBsNmEk6gpqUI2hp
	 0jHKuu2rogWqFzCsrAGuZCkWDUbcyJDSm0ggV7qjiaTIUMIBGZ+pf+4Z4fKfcgkT1f
	 g+jFdj3SkOXsejA/icC9/m/1DoiijhG0KE26qVmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 462/518] media: videobuf2-core: clear memory related fields in __vb2_plane_dmabuf_put()
Date: Tue, 15 Oct 2024 14:46:06 +0200
Message-ID: <20241015123934.837293610@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Yunke Cao <yunkec@chromium.org>

[ Upstream commit 6a9c97ab6b7e85697e0b74e86062192a5ffffd99 ]

Clear vb2_plane's memory related fields in __vb2_plane_dmabuf_put(),
including bytesused, length, fd and data_offset.

Remove the duplicated code in __prepare_dmabuf().

Signed-off-by: Yunke Cao <yunkec@chromium.org>
Acked-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 3bafde87a1257..78ad2b278da4c 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -301,6 +301,10 @@ static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
 	p->mem_priv = NULL;
 	p->dbuf = NULL;
 	p->dbuf_mapped = 0;
+	p->bytesused = 0;
+	p->length = 0;
+	p->m.fd = 0;
+	p->data_offset = 0;
 }
 
 /*
@@ -1278,10 +1282,6 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
 
 		/* Release previously acquired memory if present */
 		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
-		vb->planes[plane].bytesused = 0;
-		vb->planes[plane].length = 0;
-		vb->planes[plane].m.fd = 0;
-		vb->planes[plane].data_offset = 0;
 
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, attach_dmabuf,
-- 
2.43.0



