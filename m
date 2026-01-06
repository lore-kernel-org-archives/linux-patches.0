Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1479250BEC;
	Tue,  6 Jan 2026 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721012; cv=none; b=tfXGO3WHK4/XsCKcP65H6R2SyUPN7c0sTHjkQstujhA3bASxDt/O/oyY4QvtDA8Ulq1XHjXwCrOWel0zmWf1WmnMFCeqKwLfQZQa27yIAM20YPKAf3WT5KgCzkbhFYGvtAEw4klvGA6h7g8NZirA+q1a5VH/IwqaiI01qPsE4XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721012; c=relaxed/simple;
	bh=JrjD04dtu+IN+WuBAMU62/qvXsWOF1vryiGkIn/DNxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXpaOgPPc9LCGEftefdr9U+rlVUM36gNOs09LnVlderswb6kz3bslKTk/vKg4bVAeu62LwxE7Hc3nvl0WxwczuHH9qQ9gYKwyczt+CMrbWgX9VxQnd/3ha5p9Q4myqBcNiR2igjoj8EattXloZUpyi5JHscf3Hu+m3uaHTLUQC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVIjRgmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVIjRgmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1877AC19424;
	Tue,  6 Jan 2026 17:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721012;
	bh=JrjD04dtu+IN+WuBAMU62/qvXsWOF1vryiGkIn/DNxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVIjRgmf0khoBR/A3tUUIRdgQ040AqdVmhWhT8E7gsku2ShPuCuY1ofyoqARao6xF
	 pife07WylFBVB1mfJYP1w6HEJYpSuGNmnUKbV6CrrrmdXpkF7LkA4wRIjUgHbktgOS
	 CrubQHX3VZ/DxzxWGPZvReiOMJG61SpxXbNPS/ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 409/567] media: videobuf2: Fix device reference leak in vb2_dc_alloc error path
Date: Tue,  6 Jan 2026 18:03:11 +0100
Message-ID: <20260106170506.471858602@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


