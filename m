Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0C21DDE9;
	Thu, 30 Jan 2025 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246662; cv=none; b=YEXkESkJumPQWOODZ15X4OsAUWE1S11vU+AoM2rTNj6pSuE0MB4/PxrNggctwdjsrYePSL4aM/giygmTA9ZfU4vpI5B8FUiDpd8mu90TXeRkzHpzeKcXHO9u0oK6c02etAWgrifj+51K8oUrXA+mIqncpsvh9cRerR8XqB8GqLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246662; c=relaxed/simple;
	bh=KinoeGizS3zOHRfZQlfzZizHGY9PYlXSfB8uS+OZC50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa0JcIZTv5W2MUI4mE+SO/NYJrLGYHLTNPcdmFi5beN5IqfXE0tYOetJ7eWeiBBGy9f2flKA6E7S5swMUVjmKbD+yFcPquwrpcC00BO/+rvY/SepC0B7QeNMv4mqYBvUoDONOpfFdW3wgqNRoL6j0lBQDx9LrR9WyZpHnGVlaAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9NylLtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9NylLtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0666FC4CED2;
	Thu, 30 Jan 2025 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246662;
	bh=KinoeGizS3zOHRfZQlfzZizHGY9PYlXSfB8uS+OZC50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9NylLtF01eHLAI66M5wt1QNS5fwfm5Dcfre4CAw4y5ekZ6t81KOTAaIdp7pJv/Pw
	 Z0Rm8kSCNmcwyRSYWpTSYc83f+6ffjgTe8gbD6gfRm4gMlWPgRcLltNd/1AMQWkKDz
	 SOCfjP4XmcJt5UIwJERWoxawk5SC76WzMOwAB8aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Yan <jerrysteve1101@gmail.com>
Subject: [PATCH 5.4 25/91] USB: usblp: return error when setting unsupported protocol
Date: Thu, 30 Jan 2025 15:00:44 +0100
Message-ID: <20250130140134.679138547@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

From: Jun Yan <jerrysteve1101@gmail.com>

commit 7a3d76a0b60b3f6fc3375e4de2174bab43f64545 upstream.

Fix the regression introduced by commit d8c6edfa3f4e ("USB:
usblp: don't call usb_set_interface if there's a single alt"),
which causes that unsupported protocols can also be set via
ioctl when the num_altsetting of the device is 1.

Move the check for protocol support to the earlier stage.

Fixes: d8c6edfa3f4e ("USB: usblp: don't call usb_set_interface if there's a single alt")
Cc: stable <stable@kernel.org>
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Link: https://lore.kernel.org/r/20241212143852.671889-1-jerrysteve1101@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1337,11 +1337,12 @@ static int usblp_set_protocol(struct usb
 	if (protocol < USBLP_FIRST_PROTOCOL || protocol > USBLP_LAST_PROTOCOL)
 		return -EINVAL;
 
+	alts = usblp->protocol[protocol].alt_setting;
+	if (alts < 0)
+		return -EINVAL;
+
 	/* Don't unnecessarily set the interface if there's a single alt. */
 	if (usblp->intf->num_altsetting > 1) {
-		alts = usblp->protocol[protocol].alt_setting;
-		if (alts < 0)
-			return -EINVAL;
 		r = usb_set_interface(usblp->dev, usblp->ifnum, alts);
 		if (r < 0) {
 			printk(KERN_ERR "usblp: can't set desired altsetting %d on interface %d\n",


