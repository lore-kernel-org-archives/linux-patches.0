Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4116F22AE7C;
	Mon, 10 Mar 2025 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629447; cv=none; b=FOwkppTJZn/7gFyyLXBmdcBZRBX29jEhCtYfVCkdn1yqOyAhscH3HQxnsB6JtrPgJDdlN46BgSrZN7qCs80zUB/Mgt+kPgF0MESmSr4R/vYIz1/3pmgaYc0P/sO3ObICOzZd4nHWBe5r1CI1m5vgZJrCkMCIt4TI4c1DYVvVaw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629447; c=relaxed/simple;
	bh=0hEu6EMs3mB4TSPHZnFNSJUOUEfjIyAaCl9XPR/A5lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYOeVAmqtgD6EWarUYYqzA8lrIT8gBcKiim0PxZVCqAcHr7bpbTSCxsj24BjcXP7QoiCJoc/OwjiwldTXx7lRi+3OhU1+9brfSiXlodciCg8ENM7KakFLi5p90CYvzQVjNu12Hn7eRyNDKHiZVzqk0LIVzHehDTc6dIKPjv3Qjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smtn9/Fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smtn9/Fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395A8C4CEE5;
	Mon, 10 Mar 2025 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629446;
	bh=0hEu6EMs3mB4TSPHZnFNSJUOUEfjIyAaCl9XPR/A5lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smtn9/FlQTO1e5e0R6bM0Lg10BM52vAt36uFXOz58aBT+R4uMWTMINl1ClW2gyhe0
	 ESzCXqb2kV38VgODhYByTGpmN983dCXzjD1QflqpUe3J81UesuXlvyujTne73wKLQq
	 WpgMqsfg2JUqsETh29rxyLZJYzheGBEsQGgebBoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Roman Kisel <romank@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Long Li <longli@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 298/620] scsi: storvsc: Set correct data length for sending SCSI command without payload
Date: Mon, 10 Mar 2025 18:02:24 +0100
Message-ID: <20250310170557.386366442@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1854,6 +1854,7 @@ static int storvsc_queuecommand(struct S
 
 	length = scsi_bufflen(scmnd);
 	payload = (struct vmbus_packet_mpb_array *)&cmd_request->mpb;
+	payload->range.len = 0;
 	payload_sz = 0;
 
 	if (sg_count) {


