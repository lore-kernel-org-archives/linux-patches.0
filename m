Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6405135A948;
	Fri,  9 Jan 2026 12:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960971; cv=none; b=ULhGQCMwb4hfZmDzSPJoW+z1gi9Zy4ZYgAFExSqJGSpaTr2EjQkOQVx+DLJivo9oshTydTG+nVfYaLgd47u7heSfdlVd2CL9npZ5BitVjL4VqxPB556OsRWOPZE77HqRsHFdtkPfF7+3yrYLak8k6AzofsxqNrQZOmGapmWEzb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960971; c=relaxed/simple;
	bh=WSytHhiofvseorJZshukS21osZBobBqnw2fnTCff5vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELtNXxV3PyN6diDKHySCe3NkbOy6x9ybVLam28T4Hva21FrjrvX/+4aVKKIuYKasOarv6Ek4hm1/YlPUX7JLKrgDkfhB3GT3KzUe3TBZQif4XX7qBLv9lVoSpHprk4JYjzHFDofgobyWILmDgB4MUR7XaMRWCzWkHIbEdjn1CA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WF4WMYQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WF4WMYQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A04C4CEF1;
	Fri,  9 Jan 2026 12:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960971;
	bh=WSytHhiofvseorJZshukS21osZBobBqnw2fnTCff5vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WF4WMYQOBxvGSmfYK/wu4eCPmlURA+zIrc7ROcjX1ovLWzKTJuJTQ/0QZCossNzqk
	 ZPtwGeM97ejEEuAQ1o1V6NQdfIBoBNgR291xjDNyJMBwaQBMmYojppy966uBW/clm9
	 ngN02XNEtQdQMrfQ92gDFS7VuTX5qkRURPHLjGjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 589/737] media: videobuf2: Fix device reference leak in vb2_dc_alloc error path
Date: Fri,  9 Jan 2026 12:42:08 +0100
Message-ID: <20260109112156.157283988@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit 94de23a9aa487d7c1372efb161721d7949a177ae upstream.

In vb2_dc_alloc(), get_device() is called to increment the device
reference count. However, if subsequent DMA allocation fails
(vb2_dc_alloc_coherent or vb2_dc_alloc_non_coherent returns error),
the function returns without calling put_device(), causing a device
reference leak.

Add put_device() call in the error path before kfree() to properly
release the device reference acquired earlier.

Fixes: de27891f675e ("media: videobuf2: handle non-contiguous DMA allocations")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/videobuf2/videobuf2-dma-contig.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -258,6 +258,7 @@ static void *vb2_dc_alloc(struct vb2_buf
 
 	if (ret) {
 		dev_err(dev, "dma alloc of size %lu failed\n", size);
+		put_device(buf->dev);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}


