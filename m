Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB1321F3C;
	Mon, 18 Aug 2025 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523456; cv=none; b=iSAZyBnDmf+sqbg7/9lGE3X8FCjwNtExzPHie9+9dBm/lm/vEExfE+ZIZwNPpbKXvMF0bumoGfZrAK3T64XUjOvv90AhRdY6rE0IR/AhFslmSx34joVYTpauYoYotnm2PJbji195LzC3Z7lXT+BiWR3JPrw+FLYybaFzts/VB3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523456; c=relaxed/simple;
	bh=cfbq+BrPbZKXt05IQ5TNIhEWKOXNmAiecctYCbK61UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sp0YmJJUr2nbfDKe6QO0E9Xw4+tFxPc3Kx+n5djuy1WymwT6K8MfCJvmqtj6aSkciXLDd10eseeHjPbGdlLm+CmI0IHMNh1YYNUp6yke7b4iX88vIVWEw3n7MwQv6nw6qARzEwL79hRsvKi0/NA4YSoqnRhYf0fu10WhSEKTWq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWI24uW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWI24uW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7242C4CEEB;
	Mon, 18 Aug 2025 13:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523456;
	bh=cfbq+BrPbZKXt05IQ5TNIhEWKOXNmAiecctYCbK61UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWI24uW+ba+Vwo1oPj9170mXVBCtyy+j4wMZknGI5UGegtXjDuSvpQdVyWFIv8t92
	 bH/ztljXhKAMiedD3tnDvAOpH1ejGQCwKIsJc94u1lBV0aTHrEZO+9a10rBjttum4V
	 zn6tCs5KwxVUNwdrphut66CIWMdY3hBEQsAHQ1uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 176/515] usb: core: usb_submit_urb: downgrade type check
Date: Mon, 18 Aug 2025 14:42:42 +0200
Message-ID: <20250818124505.140551518@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



