Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4E715703E;
	Mon, 29 Jan 2024 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548246; cv=none; b=QkeF3oJ+Uw20selTGrRD2WG6w2TK2QF1SRFvJS+YfQwl17JrtD/S4gJMbl6LhOjAz328/Jz6hJphrtWNVdEo4m+fZ97KuEYBA7Gm8/77Xm/LJgjQmquHHi4KecEx4zBYUlf+S0eIPJci8gk/4cN6ZBOg06bA5Gx1EQSzWKP3MZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548246; c=relaxed/simple;
	bh=N6LKTa+7SYkLs3coFQ3qllUDvz6fJJXHpLYh6nsHJZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swWvQCFKnMgzcNBO1P0hMR2X7q2dZ9yuBaqX3PF6Ka1aWFxVS5uLMhUK2rDkLqMQrP4in7v5EV+lcfd4YUz4V9h4dfgd8V3y4bctXzKW2aDspTxgI3E9x5y+sleB6292hS4DHNbpwdXsFskxQ7DIOTFMe3gGceWI36+G5tMqMyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU9pKqYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU9pKqYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3003C433C7;
	Mon, 29 Jan 2024 17:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548245;
	bh=N6LKTa+7SYkLs3coFQ3qllUDvz6fJJXHpLYh6nsHJZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AU9pKqYlSv3bYYicxxoylw6qvnzpPXtUpLWK3yI9wZCbrMJAnA4vgm6DojqjSejWj
	 qIod3rtbnV2GUuAAKMi6+PZI8LqYETIaAz/PW7Z8OrxwUvv3+lObA4tGbFPYVCq9oK
	 rQZDbTeFpICsCkZ642mnHGfupk99WWZKv9vcBZtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 043/185] media: videobuf2-dma-sg: fix vmap callback
Date: Mon, 29 Jan 2024 09:04:03 -0800
Message-ID: <20240129165959.967299461@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -494,9 +494,15 @@ vb2_dma_sg_dmabuf_ops_end_cpu_access(str
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


