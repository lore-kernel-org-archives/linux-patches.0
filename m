Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB36013C816;
	Thu, 13 Feb 2025 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460626; cv=none; b=dD2PqzuwQX6qUh8rBXGasfiWivbe74iVeXr32OtRm/crRHKOU2FnJFTrs6M8eWdD2A/4hu/6iKpPXsyIYNsVH6XTJiMmTnylg5opGTdj+Uk/kzK9zWsCK0QR/41d6QwoUPZvJBT+LLDdM6jTkS9DFQlNtKv8hZFWW/Y5QT6cqlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460626; c=relaxed/simple;
	bh=RTNt9kujLWPC3G33sZmBJFfMODZYKCnl+WSyk4wm9Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpJeT+DJRa4ZA0+w+CPbNRYf/GbgyM48T23UZZNxitEuhIEk6t8N6idnUyGJCVgjWaYNSqT+sRoAu+RJLEaTwwovLxAKeeN2xEhjdkHura2h8/kO/PIVd77lR1wIMNLRDdaA6iDXSDf36vvOj7f++lzjlhbwI4zg3MqM9UMKqQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQ8Fv9H+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQ8Fv9H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B25C4CEE4;
	Thu, 13 Feb 2025 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460625;
	bh=RTNt9kujLWPC3G33sZmBJFfMODZYKCnl+WSyk4wm9Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQ8Fv9H+XQyMhGSlBVZnUlxIpsBWf7c1/owIiKzRDsx3sqDBSx+xBhjZCHRWRzSSr
	 hS1ucoVK5XT8AQM/uqkwOdFmX00+q/+/F/m8tOoZGYSPYsa8XKsNIwGsMQZfjEZ8YD
	 MgybIlD7Ov/tKV0N2QkgT39qGruChz8SKj9JKDiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Roman Kisel <romank@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Long Li <longli@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 165/273] scsi: storvsc: Set correct data length for sending SCSI command without payload
Date: Thu, 13 Feb 2025 15:28:57 +0100
Message-ID: <20250213142413.851967068@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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


