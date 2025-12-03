Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9748131283B;
	Wed,  3 Dec 2025 16:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778510; cv=none; b=usNVgrTRVugpkDz7F+U/BXWiEh0sTo7rfVjvLExKFkng1e6YrTJt4weemn0M1yUCYgnw/A+XA+VqFEXHYRJsms1cBmHWGVI8NRtJD5ZX5YXGqUmAlOpeJRkHGgQUPFwwoP4vvIAgdpU1/oJy906xh91a+kAez6APFpEn2uIZ1jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778510; c=relaxed/simple;
	bh=paMsJuHuMdP6xTlFyVsK1ZDd3N0KSvXq+rx6pi/vHxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6TpHlJGSW3nr8N4jg9uMlJgJNmXPkCLiEwn5iRi0IX/LXc4tgcPVNmYgUQv2SQsO59jeRaJcNE6rmRm6iOvWksuLiSt/rTmCoag1ppXuVKabOn49H0v451sMLPHWnZafNTbgI3hm9Z9MZP6TJSZZZj6k+6QjKH2RfMLEa6fheQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/EFm/Ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/EFm/Ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E25C4CEF5;
	Wed,  3 Dec 2025 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778510;
	bh=paMsJuHuMdP6xTlFyVsK1ZDd3N0KSvXq+rx6pi/vHxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/EFm/LlXm8Xtu4AnfXX8Z7hd2j6F6e/gdrsqZnrLDzTO1vuXKT/qMKemPoJNnx6L
	 N+goPSiC4TghhhUxSTM8vWS9i9TdboEXZoulDEjEDuF6/BXpFSDW9uk7SvVHlrOd+u
	 Bk6avzHWYd56tFWUJPDx80KuWpwNaHg/15BjG8k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Desnes Nunes <desnesn@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 367/392] usb: storage: Fix memory leak in USB bulk transport
Date: Wed,  3 Dec 2025 16:28:37 +0100
Message-ID: <20251203152427.667226720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


