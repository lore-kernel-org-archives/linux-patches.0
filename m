Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB838311960;
	Wed, 28 Jan 2026 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615112; cv=none; b=b3k1jm+52zTpMhLEAkEacado1ZBvAWgHFfwqu4+/Hb9GBJLYCNJl/Me31AcXxfbj9jd/aAlr/6Rd2ZhwEEsW7IMyhLkOG+a1ZeIvtDKnjvqCdfr6HS9/gZBxinuDmpuiV9iPsJw8HiEYFa8AD9cjnaIi+a2opRG8NvRerV6ou7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615112; c=relaxed/simple;
	bh=h18qjHTCnIVyb5PWzxb0lz9SY+M6uH71DwAqS95kaOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldG7vHr3RdWmZHQxsD//ZQrhX/3bVym5MCBkjFA8qi1CwMyP6F8WRq5ZaIk/BjUvb8kUG2Z2QffUtXQiQSKk0R8LPf/qRdZQ3vy4x++hLZFdU74o+ZI17NOekfEJUqOIZdgAn86WXAnrbWYc4wvltEYr3uNS7Ghhb4Z84zPz/Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/2zHQyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/2zHQyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B50C4CEF1;
	Wed, 28 Jan 2026 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615112;
	bh=h18qjHTCnIVyb5PWzxb0lz9SY+M6uH71DwAqS95kaOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/2zHQypxBz17V/Bsi70Jhh6LnpFNAWAGiQDRJySD2Zxr2ZqG1i0OFPWzLjEp1cYI
	 Cb8i7I4vrBAJtFDBSI36UCCUlBUgH/hCzrPQz0SrbwW/N93ZDnCzzfVqZtmONwEBTN
	 R25jTZxA0046vPIpfUa+qOz3IU/FR2jjIS/IYYPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 050/169] scsi: storvsc: Process unsupported MODE_SENSE_10
Date: Wed, 28 Jan 2026 16:22:13 +0100
Message-ID: <20260128145335.817310338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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


