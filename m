Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246A1211468;
	Thu, 13 Feb 2025 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457947; cv=none; b=c3c7LGlcETyQhZivYpGNoJKgrnYAybGg0eWxAUQUu/yK5vhaSwJuEnAMCcITcUgKsM6dJS9jtTZdAuIAl4AbQt6g2UVsTJo3mmc1FX64kYWSYRhTISHVIAc9bhFXKqRbBBGy6b53Y2E6AW0z/QOd5BCo69jhP75E4l+ikoXUeS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457947; c=relaxed/simple;
	bh=6FMeWs4degIA/ld5l04hHnSRES6Y7H/TZbylga4wCjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIueDyAn6jaxfEoB8yppwmupuFvn3WS8BTcM4OQiSqMNqc2VUHeyPri6mLfbDF6+wdLemlRihvehOhseOu8Dy2uipWP4oJiC/LgmJxrNn5eFSk9lo7esGN5oalClRasVIu0E6RGSYbImyTaFtHmhz83NsCGwpqWVYK5TKdt5Uko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ox0IoTKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ox0IoTKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0252C4CED1;
	Thu, 13 Feb 2025 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457947;
	bh=6FMeWs4degIA/ld5l04hHnSRES6Y7H/TZbylga4wCjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ox0IoTKaHbcFEX+H2Y/ePTZRBnuWT3/H14+9trsV9YVLS/ciflqNnyIGu6aQcleyG
	 OVOYp/EXp1+BvrsWGqIjwy9tZw2KrY8QIna+dLsRacO72M9vaiP/w6nFmr5q9Yq8Xd
	 K5xlhHNwmwINOETqI7NnByofvfdniQt8TAba4dRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Roman Kisel <romank@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Long Li <longli@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 258/422] scsi: storvsc: Set correct data length for sending SCSI command without payload
Date: Thu, 13 Feb 2025 15:26:47 +0100
Message-ID: <20250213142446.495896480@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


