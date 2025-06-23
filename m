Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0691AD3FA;
	Mon, 23 Jun 2025 21:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715665; cv=none; b=P+Vj4secKcJk0i+uzgP0R4yTkkFu6GB+gvPvd1mVpfOCVdF7S8Mkd2EMAEGVliPb8eI3BtLzDaTs+0HybK+fcilR0nCMTfVxmTb+cZ0rF7vNt++aR4fBTavXd08/OomLBRCjBQ/NxJQ7rnoNN6Vft9o4OTMZd3D0hnOnXyBy5ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715665; c=relaxed/simple;
	bh=TOdvou6jWnj1A6roy0gohf9m/ErJIpFevhFf2vnVSc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kLPH/h68/mmkCuyCg8OrxYdPT8VsBkvtq+sFxWSWXSp+huKrDRc2rWheigbCdMoB9o3l7MqFeC4011YhEBzZox1/zGVgd/m6S8YduK9F18G57CKiW79i8Iv3y9RS84eY7g7kT6hrewyPh6YMEt7fZ4zDJ3QY2daxWMDEfLhgQyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHCmMgBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHCmMgBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D4CC4CEEA;
	Mon, 23 Jun 2025 21:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715665;
	bh=TOdvou6jWnj1A6roy0gohf9m/ErJIpFevhFf2vnVSc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHCmMgBXWmLpmsZNo7r2bhnXdmzUrNQueqDxEMRVsa5YtnZl2ifGDfxdUhW4mKNns
	 yqGzkjPMTxyxVco6hNmu8Kz77eZJJUEgr/gFQeOgJAm2StIMrA8xqWtkSogVmqrsGq
	 oDvQNF5W4Q3PAetXJcSfpIB0E4YICrK/v+h7ljjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.10 289/355] udmabuf: use sgtable-based scatterlist wrappers
Date: Mon, 23 Jun 2025 15:08:10 +0200
Message-ID: <20250623130635.462534622@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit afe382843717d44b24ef5014d57dcbaab75a4052 upstream.

Use common wrappers operating directly on the struct sg_table objects to
fix incorrect use of scatterlists sync calls. dma_sync_sg_for_*()
functions have to be called with the number of elements originally passed
to dma_map_sg_*() function, not the one returned in sgtable's nents.

Fixes: 1ffe09590121 ("udmabuf: fix dma-buf cpu access")
CC: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250507160913.2084079-3-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -127,8 +127,7 @@ static int begin_cpu_udmabuf(struct dma_
 			ubuf->sg = NULL;
 		}
 	} else {
-		dma_sync_sg_for_cpu(dev, ubuf->sg->sgl, ubuf->sg->nents,
-				    direction);
+		dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);
 	}
 
 	return ret;
@@ -143,7 +142,7 @@ static int end_cpu_udmabuf(struct dma_bu
 	if (!ubuf->sg)
 		return -EINVAL;
 
-	dma_sync_sg_for_device(dev, ubuf->sg->sgl, ubuf->sg->nents, direction);
+	dma_sync_sgtable_for_device(dev, ubuf->sg, direction);
 	return 0;
 }
 


