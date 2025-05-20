Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8E81B0F17;
	Tue, 20 May 2025 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749848; cv=none; b=EJppDCIQDTs9rqHII+9oHaPbUv+1qKmbj/LN5bX8TjssqEvaIC6I8+QiFJmZLOKHZc5HNbjE2g51K3PGW8leKhlao2Tey+jrq/YMp+Po6e/tJS5Aef4qctUXs3l03HTn1Ndu59MekQBEcf3vtRNVB4XiV3qGOrq4MPuXOD14fUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749848; c=relaxed/simple;
	bh=Myk26n8igdC2z5AADPyFL8mvNuwQvvsAwu+DcjP/vC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsnhzaf935GwbPXSeXWDs8YAdyLyi0ZaVf+U6kmyiyfRCK6V94rfIRK842pVP8EKkmNDJw7AXjw+ERTPr+hfh3e67CbVpA5eAz0iUKpFkDeLRnwq+OK1Xenw+W9+M/eAjv/YaoQHbRFNvhfoMxjKb55eVkuunRNk3zpjpKl8K+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyRfqK0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyRfqK0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B72C4CEEB;
	Tue, 20 May 2025 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749848;
	bh=Myk26n8igdC2z5AADPyFL8mvNuwQvvsAwu+DcjP/vC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyRfqK0S/KCZDH/ehWTyn4TazEJ+GLIIGQbH0mok6qbYCDDWjgUnqCWUEfcWiGcqO
	 uYjDlNzpooj9LZZvcuy2rC5Q3maTfvx1BzIeOoAriVIfylE54F0e9QTqbOLhiiYVwO
	 fXfzR9647GWgQcIVaEKYmgvFvUE57NM2iERQ8cKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 078/117] Drivers: hv: Allow vmbus_sendpacket_mpb_desc() to create multiple ranges
Date: Tue, 20 May 2025 15:50:43 +0200
Message-ID: <20250520125807.094870571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 380b75d3078626aadd0817de61f3143f5db6e393 upstream.

vmbus_sendpacket_mpb_desc() is currently used only by the storvsc driver
and is hardcoded to create a single GPA range. To allow it to also be
used by the netvsc driver to create multiple GPA ranges, no longer
hardcode as having a single GPA range. Allow the calling driver to
specify the rangecount in the supplied descriptor.

Update the storvsc driver to reflect this new approach.

Cc: <stable@vger.kernel.org> # 6.1.x
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Link: https://patch.msgid.link/20250513000604.1396-2-mhklinux@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/channel.c       |    6 +++---
 drivers/scsi/storvsc_drv.c |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -1172,9 +1172,10 @@ int vmbus_sendpacket_pagebuffer(struct v
 EXPORT_SYMBOL_GPL(vmbus_sendpacket_pagebuffer);
 
 /*
- * vmbus_sendpacket_multipagebuffer - Send a multi-page buffer packet
+ * vmbus_sendpacket_mpb_desc - Send one or more multi-page buffer packets
  * using a GPADL Direct packet type.
- * The buffer includes the vmbus descriptor.
+ * The desc argument must include space for the VMBus descriptor. The
+ * rangecount field must already be set.
  */
 int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
 			      struct vmbus_packet_mpb_array *desc,
@@ -1196,7 +1197,6 @@ int vmbus_sendpacket_mpb_desc(struct vmb
 	desc->length8 = (u16)(packetlen_aligned >> 3);
 	desc->transactionid = VMBUS_RQST_ERROR; /* will be updated in hv_ringbuffer_write() */
 	desc->reserved = 0;
-	desc->rangecount = 1;
 
 	bufferlist[0].iov_base = desc;
 	bufferlist[0].iov_len = desc_size;
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1819,6 +1819,7 @@ static int storvsc_queuecommand(struct S
 				return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 
+		payload->rangecount = 1;
 		payload->range.len = length;
 		payload->range.offset = offset_in_hvpg;
 


