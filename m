Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF001DED49;
	Wed,  6 Nov 2024 12:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895517; cv=none; b=LtlLWeRvDpVh4G1vM8xqSBOkeb0UTwxR29M/r2rwez5qcNkgUvNYDr4Ee5wPpwN3BYS8COpHTqSd9+bvt8gjei3JqNgNUQHAC8Z0oAF85LhaVh6YA21lmzjtNfbUusiFi63dvP92Ttdf0TSgojkT63zTWYKhx1MLQRbb733r7IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895517; c=relaxed/simple;
	bh=GmmL+9Qb9fKSeJKovpJxELbrLGtqO3uabcXZVryclB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vta+B/DZlYo7OfD6BtPGnsx5K4hMlaMb8zoTlnSWUz6/qklHI2D3skgWjVRNDw0OYcqB1/IUdMoYERcSUB/0GsQNA5EOBGLup9Dy2OnWuBEfFExONo2nV2m/rSyn6HdK+ovFHpVHLabJ7nOzgqtpc8YzKS/kxyXHcDUjPorugpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPmOOEMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPmOOEMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77EFC4CECD;
	Wed,  6 Nov 2024 12:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895517;
	bh=GmmL+9Qb9fKSeJKovpJxELbrLGtqO3uabcXZVryclB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPmOOEMJXYsa20Oy8wSMKn/Fl2cqfcPfLlI4aIpDH2rjBMyVMMx+5apA8N+fCX3dF
	 h7dYZB62ymDkCiCyFrB6iEqkOYMLDvlq/ky/lau6pF8WPDONe8AX7pu5ew2v/0se5Z
	 Fz3J6+oVvXfpNXamOkDCZ77MaXRgZ77bKxLj7D3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/350] media: videobuf2-core: clear memory related fields in __vb2_plane_dmabuf_put()
Date: Wed,  6 Nov 2024 13:02:51 +0100
Message-ID: <20241106120326.941436343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 50015a2ea5ce0..98719aa986bb9 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -281,6 +281,10 @@ static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
 	p->mem_priv = NULL;
 	p->dbuf = NULL;
 	p->dbuf_mapped = 0;
+	p->bytesused = 0;
+	p->length = 0;
+	p->m.fd = 0;
+	p->data_offset = 0;
 }
 
 /*
@@ -1169,10 +1173,6 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 
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



