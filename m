Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5201F7543;
	Wed,  6 Nov 2024 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898663; cv=none; b=rv+U/SG58FEK3eI+cjW62O43bp3WRN4/R6VAu5hbVGOB9uZRnEJ2eqQx/fvIOlXykxaDbMPlHE1a4J8jD3/XSJnKQbBtp3x1guuFkmKd4/7uaEvrkP7AeQrN3Ru6At1hgycUgEmJrsoDg9SxESL8UekUWodCK2GTw6oKjVc5OPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898663; c=relaxed/simple;
	bh=Zrwr5dz9GFn9nYSZK6+4GN7bTZjyLjVm7n9ldUCMfzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiPaWUTHxWSzVgPl12iJUbinv+xUET5wR6skx8+d5l45Mx8Xr4chCjNSd7z5kVNRkVhqcdqrkU4XYCZRwr53HETUsihC7CZU1Vn5C9epLRwLm13BTYeq32zMB9K+xGyoRuHREI4TmtNsyx8IKDTeSuxEAJUcMqpajXJ59ci+I1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLbEO8gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLbEO8gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78274C4CECD;
	Wed,  6 Nov 2024 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898662;
	bh=Zrwr5dz9GFn9nYSZK6+4GN7bTZjyLjVm7n9ldUCMfzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLbEO8gt/IgyNGE1CBHcrQo+uWKuKivOSDJiik+rG7TC3B16+7Ax7JI2JJnCwxZ7x
	 aOUVl0bBftLfhep/jjoqcM48TUD0T4S3aw37y5GwRCPPEnxGmWhKE6Bxj8SNEW4kbK
	 NwaHY5UqeNabWxRPZxODrQkigkLBgWH+qK5y0VG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 314/462] media: videobuf2-core: clear memory related fields in __vb2_plane_dmabuf_put()
Date: Wed,  6 Nov 2024 13:03:27 +0100
Message-ID: <20241106120339.281272317@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 13602939906fc..98651c934d4e0 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -282,6 +282,10 @@ static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
 	p->mem_priv = NULL;
 	p->dbuf = NULL;
 	p->dbuf_mapped = 0;
+	p->bytesused = 0;
+	p->length = 0;
+	p->m.fd = 0;
+	p->data_offset = 0;
 }
 
 /*
@@ -1177,10 +1181,6 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
 
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



