Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6648A239E8B;
	Tue, 26 Aug 2025 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218959; cv=none; b=QDy06ZfcLE1IRfK34B5t3tmohQ/PZlqT8wI+E/LdZrLQgmOHtbi46L3yMW8VJSDyLqVfD9IFVxt7F1C6QUQkc9tX3d1wAsReMTZ6bGpBeUbryq2v6P7QiO/xtXasO8enVzo+TyhlGhL9rUSlBAxESzL2xUKa02HyooG7H90x12s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218959; c=relaxed/simple;
	bh=rwdzyoO4af8Ik92bbCYHnK7Ymv8QXsTGpDddLQ+lbNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKwcY7xOY8gpbOPYDIGpQGdQJ8UIBIOBc/KwZ+uN8ojNlrrCGK4UCTclWeSm3Ad/u2AeNsNlSYGfqsxL9YihEeWHxya6dhtaUabLg9ocpX4oS2Rt1W8ZSwt17GxLExetIKT+tpuRJc9zRwARWcVElgyXMLQxr1jn7jjDVXHmQTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjIC9xzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjIC9xzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA01C4CEF1;
	Tue, 26 Aug 2025 14:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218959;
	bh=rwdzyoO4af8Ik92bbCYHnK7Ymv8QXsTGpDddLQ+lbNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjIC9xzDP6tc0d5CR2aJdm4pN+48boVgAsgcinEsrNdo28gl0eC+uu9tjlonCHTY6
	 2nHvRGV5vrXsg68cFhnvUF9XOW2N8usI2l6xoDrgL2PT1oP5X0U9spPrPxVcBy7u6F
	 o7CQYb54y/kRbthpKWcM07/sd0I+Cc4BFF2TguOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/403] usb: core: usb_submit_urb: downgrade type check
Date: Tue, 26 Aug 2025 13:08:46 +0200
Message-ID: <20250826110912.386832946@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 850d0fffe1c6..e60f4ef06e3d 100644
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



