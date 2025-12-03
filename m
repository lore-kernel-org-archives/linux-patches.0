Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DF639A255;
	Wed,  3 Dec 2025 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780793; cv=none; b=TpCFwRKtBWY4uxVGT7VCKawk2+DOQeBAdGEPd1lK7cHD1cNUmT4bb3V/XLLvnTCtTQCqe0H4JWOnaCPqsJzFve1cA7i0DRrBTHfjh/aPVt77aySITgVn3MdxyltKmeGcmlZCFLp+78Swc/V02QvMGjsK3B2Ywv+9s8GmfXB0ADg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780793; c=relaxed/simple;
	bh=Mi7LQQieqok57JGGj2rPySdvsaTtVdfG6mxgkfJhniw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2lRU9vl9L7MgJCBU8/a7CgiSWi4tp3yWBszBxj0oYYccQ1JGNpJTp/X4g3hH+tMIjfU+mJp3/2VmgMVCNsxRms33QZ9hhrAB+ORMNROZZ1FImM8YaAtrLEeB5cucVcEFEIcovsAQlIL/1jY1AecSYUNOyq5nd332jkfkUmn0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0Wl003y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0Wl003y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52514C116C6;
	Wed,  3 Dec 2025 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780792;
	bh=Mi7LQQieqok57JGGj2rPySdvsaTtVdfG6mxgkfJhniw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0Wl003y1a2wDIAOTPknQbDbOPkzYSawLBvaRhBQEwykBUXP3l7W7Bj9xHMPNjP2d
	 rJNKcTZkX2jO8N58iZTwITd7R7fSaeeCqHyinC0mdKni7tZpfazAtTqW/UfZqa7B+6
	 LRG9CRd8wJf+93vIynP3uOAGqB8O7uti1DJgtX+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Desnes Nunes <desnesn@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 091/132] usb: storage: Fix memory leak in USB bulk transport
Date: Wed,  3 Dec 2025 16:29:30 +0100
Message-ID: <20251203152346.662082137@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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
@@ -1204,7 +1204,23 @@ int usb_stor_Bulk_transport(struct scsi_
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


