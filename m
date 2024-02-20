Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9C3612D7;
	Tue, 20 Feb 2024 21:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463504; cv=none; b=Zn9Y4pdtmzHUnloeq0Cug4fq1CJD8XxblYDXe9SpFCEDhQRsCLKcPXmX0mGgn9vwcb80p9eG6nwSHwT6bb3k5vuSQfYzhW8wlCRAHJPLRvHlbxlgnzzoCwNrmdwNiI8tTCwKrpM7McQsbLOwY/nXFHFSAS2JljejVFPKzryxVjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463504; c=relaxed/simple;
	bh=E16un5ktJlW9WY9BgEu13ZEcBhmtZ7SE1g41/Vklluo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwvxhaYN0xgO8ltDppPnz9ryVwL3Np5c3lz+6PwWkVbDgy7N+FKxHBdHF4Dum/w10pDcSG7AHg1LLylL5a0rCXfUnToD+BUs6pfVQgQrHI2pgLhO5gAlquBm6i9lvkv4SPwmzRmPr54PBG+Gx7p/DRmgjq1JTIU4v+yefj6uIUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2i5b+h0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2i5b+h0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCBBC433C7;
	Tue, 20 Feb 2024 21:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463504;
	bh=E16un5ktJlW9WY9BgEu13ZEcBhmtZ7SE1g41/Vklluo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2i5b+h0+9nXIDyVtXoDeUSXVaiVAyvqCEitF/SfWif9FbifPj9lm4epWlZPv9d1C
	 6wgEVQ+bSGjvDBsOiR74ygccPdOMAf1GtDkGf/0ZhUDj3JhR0FilNdlhvcAa3Pr6MA
	 yj1s+iB1C/0cxW9WXAlZd35DEVWFrIOCQ3CotlKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 064/331] scsi: storvsc: Fix ring buffer size calculation
Date: Tue, 20 Feb 2024 21:53:00 +0100
Message-ID: <20240220205639.596299925@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

commit f4469f3858352ad1197434557150b1f7086762a0 upstream.

Current code uses the specified ring buffer size (either the default of 128
Kbytes or a module parameter specified value) to encompass the one page
ring buffer header plus the actual ring itself.  When the page size is 4K,
carving off one page for the header isn't significant.  But when the page
size is 64K on ARM64, only half of the default 128 Kbytes is left for the
actual ring.  While this doesn't break anything, the smaller ring size
could be a performance bottleneck.

Fix this by applying the VMBUS_RING_SIZE macro to the specified ring buffer
size.  This macro adds a page for the header, and rounds up the size to a
page boundary, using the page size for which the kernel is built.  Use this
new size for subsequent ring buffer calculations.  For example, on ARM64
with 64K page size and the default ring size, this results in the actual
ring being 128 Kbytes, which is intended.

Cc: stable@vger.kernel.org # 5.15.x
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20240122170956.496436-1-mhklinux@outlook.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/storvsc_drv.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -330,6 +330,7 @@ enum storvsc_request_type {
  */
 
 static int storvsc_ringbuffer_size = (128 * 1024);
+static int aligned_ringbuffer_size;
 static u32 max_outstanding_req_per_channel;
 static int storvsc_change_queue_depth(struct scsi_device *sdev, int queue_depth);
 
@@ -687,8 +688,8 @@ static void handle_sc_creation(struct vm
 	new_sc->next_request_id_callback = storvsc_next_request_id;
 
 	ret = vmbus_open(new_sc,
-			 storvsc_ringbuffer_size,
-			 storvsc_ringbuffer_size,
+			 aligned_ringbuffer_size,
+			 aligned_ringbuffer_size,
 			 (void *)&props,
 			 sizeof(struct vmstorage_channel_properties),
 			 storvsc_on_channel_callback, new_sc);
@@ -1973,7 +1974,7 @@ static int storvsc_probe(struct hv_devic
 	dma_set_min_align_mask(&device->device, HV_HYP_PAGE_SIZE - 1);
 
 	stor_device->port_number = host->host_no;
-	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
+	ret = storvsc_connect_to_vsp(device, aligned_ringbuffer_size, is_fc);
 	if (ret)
 		goto err_out1;
 
@@ -2164,7 +2165,7 @@ static int storvsc_resume(struct hv_devi
 {
 	int ret;
 
-	ret = storvsc_connect_to_vsp(hv_dev, storvsc_ringbuffer_size,
+	ret = storvsc_connect_to_vsp(hv_dev, aligned_ringbuffer_size,
 				     hv_dev_is_fc(hv_dev));
 	return ret;
 }
@@ -2198,8 +2199,9 @@ static int __init storvsc_drv_init(void)
 	 * the ring buffer indices) by the max request size (which is
 	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
 	 */
+	aligned_ringbuffer_size = VMBUS_RING_SIZE(storvsc_ringbuffer_size);
 	max_outstanding_req_per_channel =
-		((storvsc_ringbuffer_size - PAGE_SIZE) /
+		((aligned_ringbuffer_size - PAGE_SIZE) /
 		ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
 		sizeof(struct vstor_packet) + sizeof(u64),
 		sizeof(u64)));


