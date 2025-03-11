Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0C215820C;
	Tue, 11 Mar 2025 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706881; cv=none; b=POeJP/YS0HCPmWMj2/4oSYWottdyWeeBv537iNHf8CPJG5UTRSI7kr+o6243RPwTEkvxj9UZDOYWj4xmKEwHwV39/ijHbnjnTDfk4KGcP130Yz05synLESYY3Z4+JsCPW/H29lCdlx4mWWbouRmwV8hse2IqaWibRWr8N50A0jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706881; c=relaxed/simple;
	bh=UGQVnmJSlK/gtpekNyzVuA24NKw4RMfshtl/VMwSy5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsArB5N3w/7Pfn24+YOWeE7xuVxdRMSLMZtmR8C2tBNuStQ1aIZnsLtLj+wSmdCq+QcQyG8uEO7GPvSc694q3bJaAkxaPHQNlYX8jwsovdrsQeOg+9DWrMzVRNEgzrL+IREUCxPf77znT39TX9OjRdGUmWXLHsVsBlh8at6DE6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKJMhQw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKJMhQw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4B1C4CEE9;
	Tue, 11 Mar 2025 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706881;
	bh=UGQVnmJSlK/gtpekNyzVuA24NKw4RMfshtl/VMwSy5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKJMhQw/DFhIHxPGSpaIlUrTP5KyrpjhGxYC9HZhVDImbsxUPHw4eym3scC7NulQK
	 S3aRA42LuOsu4gjGtUq3/eOHWyeEWMDK59tdlnJ1et8h/YSl/LQRjXHGg69pIlbMku
	 n3rf2HrAm7XtamEYw0wtGbIFQRcgoByJjQ0XWHiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Roman Kisel <romank@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Long Li <longli@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 199/462] scsi: storvsc: Set correct data length for sending SCSI command without payload
Date: Tue, 11 Mar 2025 15:57:45 +0100
Message-ID: <20250311145806.218909200@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit 87c4b5e8a6b65189abd9ea5010ab308941f964a4 upstream.

In StorVSC, payload->range.len is used to indicate if this SCSI command
carries payload. This data is allocated as part of the private driver data
by the upper layer and may get passed to lower driver uninitialized.

For example, the SCSI error handling mid layer may send TEST_UNIT_READY or
REQUEST_SENSE while reusing the buffer from a failed command. The private
data section may have stale data from the previous command.

If the SCSI command doesn't carry payload, the driver may use this value as
is for communicating with host, resulting in possible corruption.

Fix this by always initializing this value.

Fixes: be0cf6ca301c ("scsi: storvsc: Set the tablesize based on the information given by the host")
Cc: stable@kernel.org
Tested-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://lore.kernel.org/r/1737601642-7759-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/storvsc_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1759,6 +1759,7 @@ static int storvsc_queuecommand(struct S
 
 	length = scsi_bufflen(scmnd);
 	payload = (struct vmbus_packet_mpb_array *)&cmd_request->mpb;
+	payload->range.len = 0;
 	payload_sz = 0;
 
 	if (sg_count) {


