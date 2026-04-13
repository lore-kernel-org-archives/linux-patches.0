Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB0924E4AF;
	Mon, 13 Apr 2026 16:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096431; cv=none; b=e+ljfLaz0HYigUvuNBh8tjeHUP/xLLjgpp8UWulBMXYKJcInBHaGHrG+uHcSijyTm+oINhHkhYDvh+9VPaejGwz73BOwMGdjSGqQd4WJ7RjfauR4HPZ0Zy2+vvCklCiyInEcUqCEyy542uMp6g44ETSyz4lqHFq2+NivIjl5C6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096431; c=relaxed/simple;
	bh=9FKS68twfo+4J5BtW262UaL9Fm73xH50xmdV0M9F0Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppBwO38eAWRbVPK2ycEr5erYbkfMFfW6MmdazZbIJzdDl2Fxrqljcgf1xlqe6L2A9aKJIQ3SZM7E28cfwGMsp7IItPY5KUHU8QFEKO0N+0Pl0UoMb0qjEBL1kCdA4ZIcU3oGZWKWCN4lE1gJiI/X5h63NfKMyXrF6Xd7e0Hy3Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZjuIgdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZjuIgdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5409FC2BCAF;
	Mon, 13 Apr 2026 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096431;
	bh=9FKS68twfo+4J5BtW262UaL9Fm73xH50xmdV0M9F0Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZjuIgdPYnqX4mFs+cmif6wUQJfURPaUvC3AC3yFGXMnNqD1Dfy8Rh/c0rUZrmHj7
	 zXS/OEQAlfqJ8YxOtvu2kcleo/VfwIUSOEVlDX7aJ207iJCZiReFfid9MYqQF7cshk
	 SmPXHN85PFpqjp+cv1kooQPlBzxwGNeVRLDdDjOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Nathan Rebello <nathan.c.rebello@gmail.com>
Subject: [PATCH 6.18 01/83] usb: typec: ucsi: skip connector validation before init
Date: Mon, 13 Apr 2026 17:59:29 +0200
Message-ID: <20260413155731.079971446@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Nathan Rebello <nathan.c.rebello@gmail.com>

commit 5a1140404cbf7ba40137dfb1fb96893aa9a67d68 upstream.

Notifications can arrive before ucsi_init() has populated
ucsi->cap.num_connectors via GET_CAPABILITY. At that point
num_connectors is still 0, causing all valid connector numbers to be
incorrectly rejected as bogus.

Skip the bounds check when num_connectors is 0 (not yet initialized).
Pre-init notifications are already handled safely by the early-event
guard in ucsi_connector_change().

Reported-by: Takashi Iwai <tiwai@suse.de>
Fixes: d2d8c17ac01a ("usb: typec: ucsi: validate connector number in ucsi_notify_common()")
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Rebello <nathan.c.rebello@gmail.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260407063958.863-1-nathan.c.rebello@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -43,7 +43,8 @@ void ucsi_notify_common(struct ucsi *ucs
 		return;
 
 	if (UCSI_CCI_CONNECTOR(cci)) {
-		if (UCSI_CCI_CONNECTOR(cci) <= ucsi->cap.num_connectors)
+		if (!ucsi->cap.num_connectors ||
+		    UCSI_CCI_CONNECTOR(cci) <= ucsi->cap.num_connectors)
 			ucsi_connector_change(ucsi, UCSI_CCI_CONNECTOR(cci));
 		else
 			dev_err(ucsi->dev, "bogus connector number in CCI: %lu\n",


