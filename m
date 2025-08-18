Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3983218CF;
	Mon, 18 Aug 2025 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521971; cv=none; b=hXmT/M/BCw/QeU/96ox8JmWL06cYb4GfspBjBFcf7ued8VPJhi1/6asDb1kS41Tq3U9N5KYBy+rgNnAFHDIC33Z7+eTFacUM/pTQLy/oBmVdE6Xv4UdwHzolxSeUWYcsN20f6a8YyMJNC3/pFiNTJsdzHDMl3dJlpFy6Q+w8qp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521971; c=relaxed/simple;
	bh=KalT/mNzhwyLZEJUlGZ8RwVtUT2AfABaa/JUdDBy2WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL51kIMuXs7KwraX5roGEIIVKUqSzPjl4QueNxMeGp2iILGYA9vqd8V3EWK0YN4/Ao/cnUmwQYQZ4oA5fqejTB3cz1zON8EWY61wNTVQX+tcguViflQtMb/6VQPcJg7tGhiq/AX9LH5Bx5sAOasBqVgCa/YQUY4DHZ2GEHP++ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUx1Sqag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUx1Sqag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F965C4CEEB;
	Mon, 18 Aug 2025 12:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521970;
	bh=KalT/mNzhwyLZEJUlGZ8RwVtUT2AfABaa/JUdDBy2WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUx1SqagDJEorUf6RKBlm6r3H7+umCplhA2Fmq352rUSYI5z33lkENVDQeYS4mhX+
	 9IMVfBt829nFfHKGOzuNEqLeNHLneFlsP8kJowBRgopE2accX44vWcmtrqq/aTwY0R
	 lX8qL0t0qOgc2LecPwaHcSj15YcXIw+TJxwnG0VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/444] usb: core: usb_submit_urb: downgrade type check
Date: Mon, 18 Aug 2025 14:42:55 +0200
Message-ID: <20250818124454.497240566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 7576920e2d5a..9f202f575cec 100644
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



