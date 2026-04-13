Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB3023D7E3;
	Mon, 13 Apr 2026 16:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096207; cv=none; b=HJlX6Dnl5wOVTGgoIqQpF42Ck81HItKyW9k2xID/KJbQsnpjk8nTZZg2LX0eLwDCay1GXlb9snWHw2FoFKG+VYZrxpBcpUjDasPpBfzjS84/mMd34a7otR6+DuKETyuk3qnzlmUUhb1CU34ExWdeO7ZursjRP7vXziCYoNpeXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096207; c=relaxed/simple;
	bh=if8d9mHzBf1qnWxzQpXllAs7aWwjW7bj+3jYB44F0kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdiNTdYIfvYzZmGjZ7F2SiJq2SV0RvHF+Hs8XzUCOzlXtEBpoKXxDR1tb+H6UpfSQf0+RUIYwmECgur6AF7G9dFTKc+9wjOQtGx2mZYaJra+Va0++M+GWQSFmVejRRUeuh/NHhz1XByNqod3i8Y6Tr1CtqdjFHqZnD6S9ocPK34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+yGKvuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+yGKvuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5071C2BCAF;
	Mon, 13 Apr 2026 16:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096207;
	bh=if8d9mHzBf1qnWxzQpXllAs7aWwjW7bj+3jYB44F0kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+yGKvuoK+hrRyCc28LjL3H5Y+TPmZ5ATb81OEyZZ4Y6Onq5QHKN7husbJroY5TrB
	 opxQ8zXvvtfTWC9ncDYxQVMmowUTPVQsa5QyQ97GNDKSNF7LFlsp6wO4AT2aw3e+q1
	 WkDIMN+wKMwqjxXZVwtKhdiF8CgUy7m7TzVdbpyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Nathan Rebello <nathan.c.rebello@gmail.com>
Subject: [PATCH 6.19 01/86] usb: typec: ucsi: skip connector validation before init
Date: Mon, 13 Apr 2026 17:59:08 +0200
Message-ID: <20260413155731.626357420@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


