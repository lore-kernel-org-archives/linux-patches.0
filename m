Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0AA212EEF;
	Tue, 12 Nov 2024 10:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408148; cv=none; b=rDIbaovUPmq5bT5IiUF8mnOD++cVC5qvxWgbgRreq9MT/JyYkgtDC4xKwCs+fYSjKcuwcu2pvh0BvdNrzup0SoSsPyHhzHb4JJflKY09FEJvkIevMr0OWHjWD7oovA4M1w0sY8lQsnexJMOZY3+auvIJ1J9HXE7Hmn+YYSLrbpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408148; c=relaxed/simple;
	bh=kIIhF42DtGOmLLSwCz+pcinGmVuYkAIFo8SZWbqNVJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAZixM2zi3YLL293UC0QVRV1pE+ziYNa5VUmcv91l+hC3KkP+KlheCJjXGbfNRYgF4VDNjAhNzh/q5oON/sfucohWqnXACOPCEW96ACRMzwS2mVTW1wBNvJY79ZNYxqwmCdrJlk5pKsdKWqG0zwKCTlpAcrqq39oj7L99OOiHY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDwvECLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDwvECLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA455C4CECD;
	Tue, 12 Nov 2024 10:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408148;
	bh=kIIhF42DtGOmLLSwCz+pcinGmVuYkAIFo8SZWbqNVJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDwvECLU0nz7ZyhwtCyF7xAsGfBvoxNHZTR+nojS6qX4grRYjY0qRzfIckaZbHoNQ
	 ojjCcqRafAHLpZCGX8AB0IzS8vpffdKaGkEgbuGyTqiKzQyzVEzbBohqRq+1Q7laDa
	 +wA4eleNHThskYmhVYei//tM8QHK5q9Ndho/n23M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.11 075/184] media: dvb-core: add missing buffer index check
Date: Tue, 12 Nov 2024 11:20:33 +0100
Message-ID: <20241112101903.740370534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit fa88dc7db176c79b50adb132a56120a1d4d9d18b upstream.

dvb_vb2_expbuf() didn't check if the given buffer index was
for a valid buffer. Add this check.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Closes: https://lore.kernel.org/linux-media/?q=WARNING+in+vb2_core_reqbufs
Fixes: 7dc866df4012 ("media: dvb-core: Use vb2_get_buffer() instead of directly access to buffers array")
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_vb2.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -366,9 +366,15 @@ int dvb_vb2_querybuf(struct dvb_vb2_ctx
 int dvb_vb2_expbuf(struct dvb_vb2_ctx *ctx, struct dmx_exportbuffer *exp)
 {
 	struct vb2_queue *q = &ctx->vb_q;
+	struct vb2_buffer *vb2 = vb2_get_buffer(q, exp->index);
 	int ret;
 
-	ret = vb2_core_expbuf(&ctx->vb_q, &exp->fd, q->type, q->bufs[exp->index],
+	if (!vb2) {
+		dprintk(1, "[%s] invalid buffer index\n", ctx->name);
+		return -EINVAL;
+	}
+
+	ret = vb2_core_expbuf(&ctx->vb_q, &exp->fd, q->type, vb2,
 			      0, exp->flags);
 	if (ret) {
 		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,


