Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68A314A4E2;
	Tue, 20 Feb 2024 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463009; cv=none; b=WIC0vBeWcrzBTD2NFXHViyMnz3GOcoA4uBuxMK1kgUYpjd76Gv8AEXU7I4zW5JTFt+82SXYtHIlqYr8uAW6s4gbiPO2KjUj3vWnpz70G3z3L4SRGRzxijZSfXdzuUEOTaYoCLoEdjm4TdZkDMO7bfdvqKQTAEysZ9LHcq/sZwUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463009; c=relaxed/simple;
	bh=RZLSzSXH7wwaIaZ7k2glIyaCWgpmWuLGpsKAQLIk3mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1//CZZFRumdgsVghqwMnBRAb+CrxhLVnW+jpdTw0Hyf7DM8YXqgzoBnjVCPS2IiLPGF4imFe3IktDoz/4LcTHW1vrzqlTI22w4VrthLxnTJpbjNetDUGAjaoQVcX1DA/nNubPN0Wluw7zMSwM1fOZgbc7AtA/qhIr0GwkBbQwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysQCkatz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysQCkatz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D04C433C7;
	Tue, 20 Feb 2024 21:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463009;
	bh=RZLSzSXH7wwaIaZ7k2glIyaCWgpmWuLGpsKAQLIk3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysQCkatzcbLBjkfKjwq58N3aygMpJDCIHHOgCFl+MMsfeYO7Gvtx52YjOqyW0S2av
	 typc2uclgoB9Zl6HCIXaUXKhgrujzQcIat2G4eqR/Y49H1n8TN7DYXpFVcDWs7xBk3
	 JtAmOmHSL6uIH2JZP54Tfiw2qbP+nhE3XUUuluG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenyu Zhang <zhenyzha@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sebastian Ott <sebott@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.1 077/197] drm/virtio: Set segment size for virtio_gpu device
Date: Tue, 20 Feb 2024 21:50:36 +0100
Message-ID: <20240220204843.384116808@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Sebastian Ott <sebott@redhat.com>

commit 9c64e749cebd9c2d3d55261530a98bcccb83b950 upstream.

Set the segment size of the virtio_gpu device to the value
used by the drm helpers when allocating sg lists to fix the
following complaint from DMA_API debug code:

DMA-API: virtio-pci 0000:07:00.0: mapping sg segment longer than
device claims to support [len=262144] [max=65536]

Cc: stable@vger.kernel.org
Tested-by: Zhenyu Zhang <zhenyzha@redhat.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/7258a4cc-da16-5c34-a042-2a23ee396d56@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -93,6 +93,7 @@ static int virtio_gpu_probe(struct virti
 			goto err_free;
 	}
 
+	dma_set_max_seg_size(dev->dev, dma_max_mapping_size(dev->dev) ?: UINT_MAX);
 	ret = virtio_gpu_init(vdev, dev);
 	if (ret)
 		goto err_free;


