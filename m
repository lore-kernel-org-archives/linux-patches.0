Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D383955FC;
	Tue, 12 May 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608312; cv=none; b=GFMIjxzHX8FcMZ67R37loApNXwStuDsvhvdK0kvfG7hzJ5u+tqCiiO4SXQrgquMsFyZZxJd5epIqNKoDqY5xlKT9kEaGUDrBMQcHYvEH3Qq4iVsJzqkAO1bO7UvyAS3YU7ham+lPfQZ4wksb7vKDCW5mUvNGTX7J/oQmDL9Zxmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608312; c=relaxed/simple;
	bh=0pDBjri7ucX3mW3CgexSsJb2pZgV9Ix3LYTsFlgwZ+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPUV3PjxSWhxd/rOMOHDRLol/5DmMc5BXLhQz2y5P93LN3C/Ly4NuI/horZJg/kwn/0I/Q4tutZwpks77lnNry+9vhAFL152u9dPBWV82cyWdd27F4CYPT3lHwckou0uG+4WE02aewyeDROzOHmfOqlEDep06egE3rdhRLq3ynI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1hDJNoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1hDJNoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7E4C2BCB0;
	Tue, 12 May 2026 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608311;
	bh=0pDBjri7ucX3mW3CgexSsJb2pZgV9Ix3LYTsFlgwZ+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1hDJNoBysvFo9wIsh2nwJ1r1A/Faupn/7Y6mBYNJo/hkf1l4RicbepWVjz+SR2vs
	 kXB3uXrEpXYPjjCjhHOEcTyw1BVHYUgEagO9F8xS/xSVTa1uMFdYgMveno4IJOwZfk
	 GlxB2HQsnUZ7JVx6T492HPnt/YIKH0Fd9QK6tRnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 003/270] ipmi: Check event message buffer response for bad data
Date: Tue, 12 May 2026 19:36:44 +0200
Message-ID: <20260512173938.527429678@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit 36920f30e78e69df01f9691c470b6f3ba8aebf98 upstream.

The event message buffer response data size got checked later when
processing, but check it right after the response comes back.  It
appears some BMCs may return an empty message instead of an error
when fetching events.

There are apparently some new BMCs that make this error, so we need to
compensate.

Reported-by: Matt Fleming <mfleming@cloudflare.com>
Closes: https://lore.kernel.org/lkml/20260415115930.3428942-1-matt@readmodwrite.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -642,7 +642,13 @@ static void handle_transaction_done(stru
 		 */
 		msg = smi_info->curr_msg;
 		smi_info->curr_msg = NULL;
-		if (msg->rsp[2] != 0) {
+		/*
+		 * It appears some BMCs, with no event data, return no
+		 * data in the message and not a 0x80 error as the
+		 * spec says they should.  Shut down processing if
+		 * the data is not the right length.
+		 */
+		if (msg->rsp[2] != 0 || msg->rsp_size != 19) {
 			/* Error getting event, probably done. */
 			msg->done(msg);
 


