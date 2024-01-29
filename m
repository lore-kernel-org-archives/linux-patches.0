Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2974915AADC;
	Mon, 29 Jan 2024 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548083; cv=none; b=Gijdo+845gOwOPOu7CHV8t4qx/FEltycFTvzpJg/xm9vYpRT0GUKB2FZrvGYxWK2pu5diWYhKEK1LF3Nz+iVokSjNT76x4eTaOvgxyJDUvYLvBGQgIQtmL+O9XTDqgPdHL1gPJIeZFoBRiGAube+ANqew8MpbNZ7siH1qLKoS18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548083; c=relaxed/simple;
	bh=J8gVvFo0+78aXBG5r0SRDdfOEErPjIAwV3uqg0qWGoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXWWzmDBkgLxd6XCSou3HCk9Im41FEUzH5Eb5eYybdkcUPB7zfGOYlfzF5gVvtHGLqFHcbSLVJP+XB8/qHssucaLichBwFfpt4RECCaD+NifwgCUsM+llEurvACn26gWWap1/fZVqXOy3KrnFdr35tYtkpaT8qUvJLvtbj4EuaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w43l03HH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w43l03HH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BF2C433F1;
	Mon, 29 Jan 2024 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548083;
	bh=J8gVvFo0+78aXBG5r0SRDdfOEErPjIAwV3uqg0qWGoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w43l03HHRnOyZTgc8A4YwgUL62SRRKlG4qj9gJ55osQXroCMAcvwGTvG7cfpY9rVu
	 DaH9uRc2sPNh9+iWhycCziX1pADAQHf3nivnofwtRsDImQnCJdjbG4HynFgVz3D/2S
	 KvC0ipwBfc+BItbAmSMFZS7z/vDQMmudkefZoPEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.7 096/346] media: videobuf2-dma-sg: fix vmap callback
Date: Mon, 29 Jan 2024 09:02:07 -0800
Message-ID: <20240129170019.226493743@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


