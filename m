Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17A3335BBE;
	Mon, 18 Aug 2025 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525209; cv=none; b=ZRGmV6NRsHeu+aSZMhcFEOm9IX50P2hyNMf+IZX4jQZiIvTMXdHy3BTVyR7h2ITYpg2M3UiKY/zDpdghQx910baeVDSM9ShMhB+lXvXeGrLO7vNSdU96+D+W6Oz+pZoLhw6+5DvFWgqnVhw2bZkuwDwg1jLHI1exts4WHI5Btpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525209; c=relaxed/simple;
	bh=zNrbLxmZrcA5yRb8sku/g1/nEOrcCQaixOclCTN+Pjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dos7maLra2UDte0zPE0M/XWAZ3LjE56EjNJbtDLKEE/TzGCGobvI/2tbIyoqNbS1axqqAg5QVTAzTQ8qmLJOmIPqS841vQZ5YhcirFKtixCgB4c1q87/RzG9jfG8GtI0jYVI4Y3JAs506PGCW1hvx4dWFI984YYTuu+UCLMXnjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEdagibO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEdagibO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7C3C4CEEB;
	Mon, 18 Aug 2025 13:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525208;
	bh=zNrbLxmZrcA5yRb8sku/g1/nEOrcCQaixOclCTN+Pjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEdagibOObdZa/sYT48QY4dxuq3LGD9DD8xt4G/x5zRSQJQA7NIJw11kFCnapP7fV
	 4z5751zNcYLv60HJE/YtTEJjegRONPEoDF2dJl530ANOAvNmDlaifCitNa+aAnmVq0
	 BH/dcCl7rkNNgJ0ks2jSPNnY4IY/0DCOyZaK9hzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 192/570] usb: core: usb_submit_urb: downgrade type check
Date: Mon, 18 Aug 2025 14:42:59 +0200
Message-ID: <20250818124513.199794084@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 5e52a35486af..120de3c499d2 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -500,7 +500,7 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 
 	/* Check that the pipe's type matches the endpoint's type */
 	if (usb_pipe_type_check(urb->dev, urb->pipe))
-		dev_WARN(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
+		dev_warn_once(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
 			usb_pipetype(urb->pipe), pipetypes[xfertype]);
 
 	/* Check against a simple/standard policy */
-- 
2.39.5



