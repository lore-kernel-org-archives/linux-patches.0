Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A9C26B0A5;
	Thu, 13 Feb 2025 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459500; cv=none; b=E+UNy1nD/bF5U2GVo+LggjwaESJVZkooKQoEJQJsJDY4/zG35flvLTQHahcm27rJ3cq8Ec6XKuyTsqXjJqdbl5DzcO4xar/HEL7HiazOpObrJfPm9aOQr6VSlmyi5LERzZ2YECDf6mi1AdRsDGkqOdRVckBQUkF9wz7pdA9yRLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459500; c=relaxed/simple;
	bh=MIe67AbyJTT0N/sD/Ha4dg4J4KTleviOKJXZoc7zbGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl1GegsrPmoWB5uWb7IFOE6p4/vuiA1uRw17HNqT715YsRGwQohPXI2uffou3C4snt5rrAiiTwcZoe7YGj4oyOTGY1i3yeh9CWsqRgaL5c2LTaaYTVYLjaaOPFr2K95t68K8adJ/feK/6JdmuSeGy25Cj4F6BZbgfyUOrj+sflk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8EgUewa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8EgUewa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD685C4CED1;
	Thu, 13 Feb 2025 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459500;
	bh=MIe67AbyJTT0N/sD/Ha4dg4J4KTleviOKJXZoc7zbGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8EgUewaruxRrnDvdrDxZwr7chYTeiSHs5LPIph+6ZWTFRUBSW1Wkb/B5g0kXhEYq
	 PfVQMKX0xBMWMba0JezBINdLXbWYGZNcOyA15Qu0tZ7I7tUXQF+4ixVNdMG0Edo7nY
	 89X/sMMXlT3+eQud5XdaLn+ZhKWMdRr0ZIKxkT5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Roman Kisel <romank@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Long Li <longli@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.13 284/443] scsi: storvsc: Set correct data length for sending SCSI command without payload
Date: Thu, 13 Feb 2025 15:27:29 +0100
Message-ID: <20250213142451.569235941@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1800,6 +1800,7 @@ static int storvsc_queuecommand(struct S
 
 	length = scsi_bufflen(scmnd);
 	payload = (struct vmbus_packet_mpb_array *)&cmd_request->mpb;
+	payload->range.len = 0;
 	payload_sz = 0;
 
 	if (scsi_sg_count(scmnd)) {


