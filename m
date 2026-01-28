Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D52C2C237E;
	Wed, 28 Jan 2026 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614562; cv=none; b=B/xhjDI6rUzLld6+hyt2p9suFsdE+4vHYzW5Xx/RF4vlp0TlCv0rYtTOO5ZXkaFD4Pu/1gGYujSnFtNNrkPuBAClUWpAOhLuXHVVLjIvlFzuliEv8q50gmax9UCX+fGJln8jA6VoRVqF1xKBW7OakdKt4hMm9elCUdpUtw1n0TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614562; c=relaxed/simple;
	bh=5u0WtFgUtnPxN1RuVLEcVXQfN1xV2SMwrSMyXZDg11s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYdAVtSKYrFXy+zBSkcoereqmilj+nZObtca3U3Klvzm5HuFsgM68AoCGLVZCcEiMbe4a0OjfdVc6/3gwWi6z1dBCamyOwui8I0gWrkk7RN9d7QcW6INL+od05xg3OgmdM1+4sx465M15aLqVJGGfBtPwpKp8yvfGKbmhXV227w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOLOVDQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOLOVDQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFEAC4CEF1;
	Wed, 28 Jan 2026 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614562;
	bh=5u0WtFgUtnPxN1RuVLEcVXQfN1xV2SMwrSMyXZDg11s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOLOVDQ+oje5n/P9waK+Zn0XflE5/aUfYOfpdyEUin4ktNwHi/U8TeFYMFqWpMg2K
	 JvvFKp/9hM5N+BvSwkVZ6AfRHoodVdGfLrqbwlfS5qbGRSJXKNTlONBCj86ah7mbnF
	 Wjv4eBuyVSqzX18Unu4YWbBvLG3butyTHRZo9kog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 142/254] scsi: storvsc: Process unsupported MODE_SENSE_10
Date: Wed, 28 Jan 2026 16:21:58 +0100
Message-ID: <20260128145349.926700181@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit 9eacec5d18f98f89be520eeeef4b377acee3e4b8 upstream.

The Hyper-V host does not support MODE_SENSE_10 and MODE_SENSE.  The
driver handles MODE_SENSE as unsupported command, but not for
MODE_SENSE_10. Add MODE_SENSE_10 to the same handling logic and return
correct code to SCSI layer.

Fixes: 89ae7d709357 ("Staging: hv: storvsc: Move the storage driver out of the staging area")
Cc: stable@kernel.org
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://patch.msgid.link/20260117010302.294068-1-longli@linux.microsoft.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/storvsc_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1145,7 +1145,7 @@ static void storvsc_on_io_completion(str
 	 * The current SCSI handling on the host side does
 	 * not correctly handle:
 	 * INQUIRY command with page code parameter set to 0x80
-	 * MODE_SENSE command with cmd[2] == 0x1c
+	 * MODE_SENSE and MODE_SENSE_10 command with cmd[2] == 0x1c
 	 * MAINTENANCE_IN is not supported by HyperV FC passthrough
 	 *
 	 * Setup srb and scsi status so this won't be fatal.
@@ -1155,6 +1155,7 @@ static void storvsc_on_io_completion(str
 
 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
 	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE) ||
+	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE_10) ||
 	   (stor_pkt->vm_srb.cdb[0] == MAINTENANCE_IN &&
 	   hv_dev_is_fc(device))) {
 		vstor_packet->vm_srb.scsi_status = 0;


