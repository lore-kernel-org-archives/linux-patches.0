Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2E73C2F;
	Wed, 21 Feb 2024 13:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523277; cv=none; b=SYjY/eO0eVxkjLTxpveo5JO1G+yUPGWNn6rmiHu6ByxjGY2uzlQZ3dAxKtvX2Xqrwi90j1RU5mfnQ1nGXFkqlQVgQiKRJ/VvJK/Kf+kRWGHM6hkg7fozh+ZoOoiq0znZLRc/ncwzQrCBYJTEeC+SjA2mFtBjwF0NumqcvimkAsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523277; c=relaxed/simple;
	bh=pfw+QyW0BeNdCWFX+y7VgYOMyrDiSPfPElUI+UcNVOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmVcgRM/oRvQ0sSbsyVFd9KQWKOrxVUhKv2MDT5FXCHakIBDAd1RpQLeA+T0xK9dDbjGnGiOSIvOlHWCz7rYFpV2IlgmmIRyP2tAuKXKHnD33bLLWGLBllbX/i30DpguEpbZSmDHp7v/cbHyKA0gjrlzuQD9UjyfI7clW91+P+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8NsbXUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8NsbXUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226EBC43390;
	Wed, 21 Feb 2024 13:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523277;
	bh=pfw+QyW0BeNdCWFX+y7VgYOMyrDiSPfPElUI+UcNVOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8NsbXUA4zTZy/yy989adKlOQf9LCcpEvFgtLhTX0JPd3AYrRQK9Re+jgn/+OB1ST
	 4f/p+n7z2WVMWcqm3Nm1FU6d4cSAmBemAvMc5avRkysJv7mXfJxE8RNSk6S661jBJn
	 i5iCcwsbpCeKKtxBSwU7cCeUS/SvS4tQsN3jQ2DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 359/476] scsi: storvsc: Fix ring buffer size calculation
Date: Wed, 21 Feb 2024 14:06:50 +0100
Message-ID: <20240221130021.271340395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -367,6 +367,7 @@ enum storvsc_request_type {
  */
 
 static int storvsc_ringbuffer_size = (128 * 1024);
+static int aligned_ringbuffer_size;
 static u32 max_outstanding_req_per_channel;
 static int storvsc_change_queue_depth(struct scsi_device *sdev, int queue_depth);
 
@@ -737,8 +738,8 @@ static void handle_sc_creation(struct vm
 	new_sc->next_request_id_callback = storvsc_next_request_id;
 
 	ret = vmbus_open(new_sc,
-			 storvsc_ringbuffer_size,
-			 storvsc_ringbuffer_size,
+			 aligned_ringbuffer_size,
+			 aligned_ringbuffer_size,
 			 (void *)&props,
 			 sizeof(struct vmstorage_channel_properties),
 			 storvsc_on_channel_callback, new_sc);
@@ -2033,7 +2034,7 @@ static int storvsc_probe(struct hv_devic
 	hv_set_drvdata(device, stor_device);
 
 	stor_device->port_number = host->host_no;
-	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
+	ret = storvsc_connect_to_vsp(device, aligned_ringbuffer_size, is_fc);
 	if (ret)
 		goto err_out1;
 
@@ -2226,7 +2227,7 @@ static int storvsc_resume(struct hv_devi
 {
 	int ret;
 
-	ret = storvsc_connect_to_vsp(hv_dev, storvsc_ringbuffer_size,
+	ret = storvsc_connect_to_vsp(hv_dev, aligned_ringbuffer_size,
 				     hv_dev_is_fc(hv_dev));
 	return ret;
 }
@@ -2264,8 +2265,9 @@ static int __init storvsc_drv_init(void)
 	 * for Win7 and older hosts because it does not take into account
 	 * the vmscsi_size_delta correction to the max request size.
 	 */
+	aligned_ringbuffer_size = VMBUS_RING_SIZE(storvsc_ringbuffer_size);
 	max_outstanding_req_per_channel =
-		((storvsc_ringbuffer_size - PAGE_SIZE) /
+		((aligned_ringbuffer_size - PAGE_SIZE) /
 		ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
 		sizeof(struct vstor_packet) + sizeof(u64),
 		sizeof(u64)));


