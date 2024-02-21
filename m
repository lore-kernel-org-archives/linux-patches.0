Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A585276905;
	Wed, 21 Feb 2024 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525325; cv=none; b=VO+PpTwpN1aecFNmXnfZRHjeifSFv1bfj5/FuDQ4umu5rnk3bFt3r0F1tCULZxflkQK+jO+gbZyYziqazC9lmxrexEsbSS0e0FRLiDaqpk6YrkIe1soMaT1F+CfLs3Nc69WxqsA8kv97TISnePIcfZDe0yXNZ2oRfZNu8ZEfq5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525325; c=relaxed/simple;
	bh=4dZfnxAXEuRBeQUSUjyVFGaecwKpQgDheS9mxhseObU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PedDChVbdcCrTgSsoPJtdst9GwvKKuyq7Rxy2s+74EKNgJ/OrLdrmEuEIXeqn537udRO41pE1jUuu+yx3a/X8yDMItBTuuNfLnvTGXPlo2LkAGWc0W9dKyi5S+qwUGaHpxIHhg0QyImzeJVIgU5MYwzOFqnNzL1sE9hzW9ZB/UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCVmB0RK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCVmB0RK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AFEC433F1;
	Wed, 21 Feb 2024 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525325;
	bh=4dZfnxAXEuRBeQUSUjyVFGaecwKpQgDheS9mxhseObU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCVmB0RKojiOokjS0bME6SB33GCIcsLljo9ZPS1CtfXgSxltWE0RGHHrP/fB9GnMI
	 H3nDbUJ95rVRxYgQBfD3j35J8v+J/VhAgriy80TCS0lFxcCy/GeeVpbAgs62bs4bdU
	 JDy+ITfL64E9MRJx/wvTW3FKHDEWBxV/94HGowy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/267] scsi: libfc: Fix up timeout error in fc_fcp_rec_error()
Date: Wed, 21 Feb 2024 14:07:24 +0100
Message-ID: <20240221125943.171088764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 53122a49f49796beb2c4a1bb702303b66347e29f ]

We should set the status to FC_TIMED_OUT when a timeout error is passed to
fc_fcp_rec_error().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20231129165832.224100-3-hare@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_fcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 22e286f920f4..5e00ee0645f2 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1685,7 +1685,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
-			fc_fcp_recovery(fsp, FC_ERROR);
+			fc_fcp_recovery(fsp, FC_TIMED_OUT);
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
-- 
2.43.0



