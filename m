Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A407F401A0A;
	Thu, 16 Jul 2026 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211441; cv=none; b=a0CSCJAtRPNsjovB/YWb2fubVgKVytWnIWPZ7YQtQWPT8wl1udo80N+RvgvOtuNK6R6dpNz2pIgnAyT1GaCJhSAW5IQKrDB6PbeJght+8xWBPKCzm1LgfoAR7qRo/9QAsnRQC3x1NbMbJhFrRpJaHlCj3SlBx5z3WTp/NKegfFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211441; c=relaxed/simple;
	bh=LOHf3l6uQ/F3kPFAx8pE1jccZpBsgcSflgKqOWwyj+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NU4eGPIecKoAcT2Q4heq/uDWT4Y3LyfyfcWnKEhpU17GAfMozb+LK2F1kLV2uU9PCsnelT2xMfL+alUehOHr/wzHJCHrEBIubfA6CkAIhkL4lg0I3KVhkag6f3pQRoDK+uZnEXMoBiS0Un275hS2ss5l/5Qp6WTODxaOFhr6IWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCDsjuZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCDsjuZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E711F000E9;
	Thu, 16 Jul 2026 14:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211440;
	bh=sFX4nTnUVxtmvyICxlldeSvLl+2FRRS9177cXHHKRXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCDsjuZjje0h0JvgoC4kSpn/q8e00H4eTdREI3kZNMgV/9wW6xmY6FzzPD5fl7Q7l
	 igr30aooOXwmvxsPGhTH+wr+q+sw2v4QqLSrBjJz9h2qBk5Pp2aHAvb4lFZA01BFas
	 1HcVnc/USOSt2bIhY2ePYg+hT8f/GBI4AwRSAkVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH 6.18 430/480] udmabuf: fix DMA direction mismatch in release_udmabuf()
Date: Thu, 16 Jul 2026 15:32:57 +0200
Message-ID: <20260716133054.116273446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit fb7b1a0ab25a6077d26cb3829e31743972d4f31d upstream.

begin_cpu_udmabuf() maps the sg_table with the caller-provided direction
(e.g., DMA_TO_DEVICE for a write-only sync), and caches it in ubuf->sg
for reuse.  However, release_udmabuf() always unmaps this sg_table with
a hardcoded DMA_BIDIRECTIONAL, regardless of the direction that was
originally used for the mapping.

With CONFIG_DMA_API_DEBUG=y this produces:

  DMA-API: misc udmabuf: device driver frees DMA memory with different
  direction [device address=0x000000044a123000] [size=4096 bytes]
  [mapped with DMA_TO_DEVICE] [unmapped with DMA_BIDIRECTIONAL]

The issue was found during video playback when GStreamer performed a
write-only DMA_BUF_IOCTL_SYNC on a udmabuf.  It can be reproduced
with CONFIG_DMA_API_DEBUG=y by creating a udmabuf from a memfd,
performing a write-only sync (DMA_BUF_SYNC_WRITE without
DMA_BUF_SYNC_READ), and closing the file descriptor.

Fix this by storing the DMA direction used when the sg_table is first
created in begin_cpu_udmabuf(), and passing that same direction to
put_sg_table() in release_udmabuf().

Fixes: 284562e1f348 ("udmabuf: implement begin_cpu_access/end_cpu_access hooks")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patch.msgid.link/20260314232722.15555-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -40,6 +40,7 @@ struct udmabuf {
 	struct folio **pinned_folios;
 
 	struct sg_table *sg;
+	enum dma_data_direction sg_dir;
 	struct miscdevice *device;
 	pgoff_t *offsets;
 };
@@ -237,7 +238,7 @@ static void release_udmabuf(struct dma_b
 	struct device *dev = ubuf->device->this_device;
 
 	if (ubuf->sg)
-		put_sg_table(dev, ubuf->sg, DMA_BIDIRECTIONAL);
+		put_sg_table(dev, ubuf->sg, ubuf->sg_dir);
 
 	deinit_udmabuf(ubuf);
 	kfree(ubuf);
@@ -255,6 +256,8 @@ static int begin_cpu_udmabuf(struct dma_
 		if (IS_ERR(ubuf->sg)) {
 			ret = PTR_ERR(ubuf->sg);
 			ubuf->sg = NULL;
+		} else {
+			ubuf->sg_dir = direction;
 		}
 	} else {
 		dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);


