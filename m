Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E771F2FDC44;
	Tue, 26 Aug 2025 13:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216221; cv=none; b=ssbs5SVZgvgXyVQsvR9MGOe+salKT8FF2B2FVQB4jncCbp7xe/H/bI+bmQB+kQ77TU6gMRCJzqsIw1jkMTj7ZPsL4Ex71vrU8FVamJ4yswfK7IkZRQyA17ytdZTusijhcvLYVYEdeQM0uqYHdyA7bc7LNfFKDhgtuWV0CsB6z7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216221; c=relaxed/simple;
	bh=8ktEa3Gd25hQlWA7ZbnLUyM9JVCPiGnqBfRjKXNMk2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cd3LUqEKevI0NWt+vf6mL+2zKEJU5TcgJhm16Da5kbBjqcss3oSljPuY45ZjDZSNYuHqN60RrWrM8DcSQWxWf8tk01N/hmfaTyE52OBhM4N04ix/cXKzH6zl3uR8koGwVu3zMOHxxKySG14VZflO4wKzPez1AfGa909weu4qLbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaxEioqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaxEioqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7939AC4CEF1;
	Tue, 26 Aug 2025 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216220;
	bh=8ktEa3Gd25hQlWA7ZbnLUyM9JVCPiGnqBfRjKXNMk2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaxEioqH4ihLbrx1QDoZlOY8gBHjyjDnbh4g4RLZxwTKanS48yKxJelWqOcUC9/Cc
	 sIdGo9zmDYqvpYoqCtWzmyV7Kxb9sydnUj6kPik42h4wpXmDYFqw+co4c65EBrM1Sa
	 A2tWY/wFtSYtQjIxDwts1NBwn+DGQujadPXwC3oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/644] usb: core: usb_submit_urb: downgrade type check
Date: Tue, 26 Aug 2025 13:06:59 +0200
Message-ID: <20250826110954.514251761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 33d62d7e3929..201f8519d9d6 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -499,7 +499,7 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 
 	/* Check that the pipe's type matches the endpoint's type */
 	if (usb_pipe_type_check(urb->dev, urb->pipe))
-		dev_WARN(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
+		dev_warn_once(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
 			usb_pipetype(urb->pipe), pipetypes[xfertype]);
 
 	/* Check against a simple/standard policy */
-- 
2.39.5



