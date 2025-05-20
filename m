Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38BAEC4;
	Tue, 20 May 2025 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749464; cv=none; b=lj2NGBRHKhnu5I4a/9r2E70gl0YwPFHHazcGE+giGkKlo1hrQmALqq06GkmhGb6+CEBfBhldxTBX4GglDd08HovPr4bkMJXQVV1gcDPwlHcZCGasmIhDcjktu0qQPgKJfol7p7SQHJTpIqI0MtxKDpPtqSR+s8iI5T1gPqCo0qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749464; c=relaxed/simple;
	bh=C9VzM7X2kdfjanrJRw59QXxzcT9kazpxEqvsk7PE4jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYaAAG3oT15JNwy2izVK8L3UnuXzmnceltUagC5cfiHZ5fTNPHBNIUTtjhIjDzqwNVHt3y25DaWfZ8r0G9JUSiyM4/FDZrRCxNj4miptZzFpR+m9IGeByLRnrU0TpMn8AryY5/ZaCsRnKpq1ef5XWVfXQAn4OOLLVsDwLYMuOcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZUIThwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZUIThwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D042BC4CEEB;
	Tue, 20 May 2025 13:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749464;
	bh=C9VzM7X2kdfjanrJRw59QXxzcT9kazpxEqvsk7PE4jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZUIThwHLaOeiD8oOwQaR1ZbIq3G6+2tanNkf2OFxqNReog1JmZ44qfazb8SEZpZB
	 0jC+DZguSw/JyG366A++vI36TCRuwse8gT7fNq7GcoxQxrmWBx9nLAXthVz7mlb8Jz
	 sYUSJ6CB0TRiF7Uyq3HKwdoTv+i8FU4+GKk78SUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 53/97] Drivers: hv: Allow vmbus_sendpacket_mpb_desc() to create multiple ranges
Date: Tue, 20 May 2025 15:50:18 +0200
Message-ID: <20250520125802.733557291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1810,6 +1810,7 @@ static int storvsc_queuecommand(struct S
 				return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 
+		payload->rangecount = 1;
 		payload->range.len = length;
 		payload->range.offset = offset_in_hvpg;
 


