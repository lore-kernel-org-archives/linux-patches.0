Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2CF313E00;
	Wed,  3 Dec 2025 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776844; cv=none; b=hTeQq5QYlP1m3BdRa5h6LVo34vV1OZjICwEihfPgLeXtYXaAkAhvjDuHXQqWZf4F8tD/kEQzgFiDS2dgau1RxY3iwXMMQSlRCQjUyfEEy1FE0Ev+6TF/ZW3iPXY2jN1by90bzlvZltglFlMG/VX+WEX0OFYqC1aC0NkfV9FMlek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776844; c=relaxed/simple;
	bh=pIGnLcqnpfeS/QhhBM5IGGeYmEgvN/qV3cThkwqQrXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlwnNvc4CUlEFde/XsJYtd0MXYL6itYiUCvqqi5sKPj59RB7Zwx8//8stFhNGVk/LkHPdJa4fjcqrNIlcqWhP0S1j4NMT1g+P9PZqxuaFPuNlYB7Rabd9Z49OAfNzCSZLylDTOuPzTaX+nXIhDL/+qdoAo5MWglvI2kKhASuWaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PV5oEBJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PV5oEBJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC56C4CEF5;
	Wed,  3 Dec 2025 15:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776844;
	bh=pIGnLcqnpfeS/QhhBM5IGGeYmEgvN/qV3cThkwqQrXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PV5oEBJlCYjFrCVULAvwtqJFRT226yqWQeAGlkvnLO+H4g9NRE0bwW39JxvNm7CLu
	 2TfVUJvovs51A/RZhTUmb5XES8FNpXhUpAquShMdYSZnAI2+3ZzG5mvnUBra6F2Ez3
	 J9jLbHpKvhHgS1vsH0LZDNr7q/CGQDNCrCYjTQ6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Desnes Nunes <desnesn@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 280/300] usb: storage: Fix memory leak in USB bulk transport
Date: Wed,  3 Dec 2025 16:28:04 +0100
Message-ID: <20251203152411.000545433@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Desnes Nunes <desnesn@redhat.com>

commit 41e99fe2005182139b1058db71f0d241f8f0078c upstream.

A kernel memory leak was identified by the 'ioctl_sg01' test from Linux
Test Project (LTP). The following bytes were mainly observed: 0x53425355.

When USB storage devices incorrectly skip the data phase with status data,
the code extracts/validates the CSW from the sg buffer, but fails to clear
it afterwards. This leaves status protocol data in srb's transfer buffer,
such as the US_BULK_CS_SIGN 'USBS' signature observed here. Thus, this can
lead to USB protocols leaks to user space through SCSI generic (/dev/sg*)
interfaces, such as the one seen here when the LTP test requested 512 KiB.

Fix the leak by zeroing the CSW data in srb's transfer buffer immediately
after the validation of devices that skip data phase.

Note: Differently from CVE-2018-1000204, which fixed a big leak by zero-
ing pages at allocation time, this leak occurs after allocation, when USB
protocol data is written to already-allocated sg pages.

Fixes: a45b599ad808 ("scsi: sg: allocate with __GFP_ZERO in sg_build_indirect()")
Cc: stable <stable@kernel.org>
Signed-off-by: Desnes Nunes <desnesn@redhat.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20251031043436.55929-1-desnesn@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/transport.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1199,7 +1199,23 @@ int usb_stor_Bulk_transport(struct scsi_
 						US_BULK_CS_WRAP_LEN &&
 					bcs->Signature ==
 						cpu_to_le32(US_BULK_CS_SIGN)) {
+				unsigned char buf[US_BULK_CS_WRAP_LEN];
+
 				usb_stor_dbg(us, "Device skipped data phase\n");
+
+				/*
+				 * Devices skipping data phase might leave CSW data in srb's
+				 * transfer buffer. Zero it to prevent USB protocol leakage.
+				 */
+				sg = NULL;
+				offset = 0;
+				memset(buf, 0, sizeof(buf));
+				if (usb_stor_access_xfer_buf(buf,
+						US_BULK_CS_WRAP_LEN, srb, &sg,
+						&offset, TO_XFER_BUF) !=
+							US_BULK_CS_WRAP_LEN)
+					usb_stor_dbg(us, "Failed to clear CSW data\n");
+
 				scsi_set_resid(srb, transfer_length);
 				goto skipped_data_phase;
 			}


