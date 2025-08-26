Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6115E1494D9;
	Tue, 26 Aug 2025 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217717; cv=none; b=LpmvCf9Q9kz4L/VUFCJJgoFnbsWcoUDMRPfdTSUyN/EOQGhMrZArMTLP8vUnK7jeVFUC5rp07JnAZjFV15Lb3AbAWvMD3tblHPnc3cxx4dquutBEQ3nQUv7SAi2yA5PlO2S6V98NwDXgj8+YOZuyFdMunOxj7/xJ4wFoCVyDLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217717; c=relaxed/simple;
	bh=lFQZl/DbLAZQzYU7HVrKAugkQAk2tjGI/+i8Ow2Lqfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlYSJ8b4R8nqCV9rBnfaPJPGReCyaPGHoJ6KHDzGb/efaXEXcpshncjLZhF4OGZSxLfHnEYV+HZBkd7gbS+r2pp+4clGbEqd/WQipGgwWeaiVQVzq5mAP63OxEREL8J75Bvn3b4ZGPVYt4EmcOKeU9BEMs1wmCh4EirupdM8EWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHLQKo2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHLQKo2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE19BC4CEF1;
	Tue, 26 Aug 2025 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217717;
	bh=lFQZl/DbLAZQzYU7HVrKAugkQAk2tjGI/+i8Ow2Lqfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHLQKo2/5OeUxlkRTPHQJR/mkSDPqZNum4BosXuRG33r+bcVxNNgspqq8K0hXKQsh
	 bajdfQjerPPYmCcRCen3Hb1BpKSFUcS+L8x7tmlo59kKbuham+f+rhl1FSg/BhBUGA
	 dnjbA/Ib9BVawu/TbmU/qwmML6MoEKw/Vng7c/oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/523] usb: core: usb_submit_urb: downgrade type check
Date: Tue, 26 Aug 2025 13:07:39 +0200
Message-ID: <20250826110930.575135680@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 503bbde34cc3dd2acd231f277ba70c3f9ed22e59 ]

Checking for the endpoint type is no reason for a WARN, as that can
cause a reboot. A driver not checking the endpoint type must not cause a
reboot, as there is just no point in this.  We cannot prevent a device
from doing something incorrect as a reaction to a transfer. Hence
warning for a mere assumption being wrong is not sensible.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250612122149.2559724-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/urb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 9c285026f827..c41b25bc585c 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -490,7 +490,7 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 
 	/* Check that the pipe's type matches the endpoint's type */
 	if (usb_pipe_type_check(urb->dev, urb->pipe))
-		dev_WARN(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
+		dev_warn_once(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
 			usb_pipetype(urb->pipe), pipetypes[xfertype]);
 
 	/* Check against a simple/standard policy */
-- 
2.39.5



