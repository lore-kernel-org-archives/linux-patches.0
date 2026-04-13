Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05D02FFFA4;
	Mon, 13 Apr 2026 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097213; cv=none; b=GIo77kcIk6dPEpD/DopLlNLRrzR2XgwDdZRn1cmXkmTca0+C00oFjJZeNczvDOrDgLeT6P24aHjqFcpfVbo2KIe745q1y+9xydxXdgdPatEjCb+RXgNsFIF68MwSPbOpnboInZNZq7eiNBysm8Duxybu0S5rcGshTxHTOGXGiMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097213; c=relaxed/simple;
	bh=mwqm9ZxjMhc2Af1UOa726MUvJJUph7zDeyrLaWOr/yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuVQUvwl9VVb+fAMUz3pTIZwpTC2PDJ8T0CexJ4XR+vtLvzgr3/xHd1o8rT9I9stuYOR15jyvey7dC17/alV337SxxsEdDWX1P74HsfIPbZLsSM1jsvXGIDJTxkcCW8YwW3Sq3rDMBLWSwQ0v8MMDuEaxKnEjsAI+7NThV2lhdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5mcztkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5mcztkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E73C2BCAF;
	Mon, 13 Apr 2026 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097213;
	bh=mwqm9ZxjMhc2Af1UOa726MUvJJUph7zDeyrLaWOr/yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5mcztkRiFT3xO+hgmu4c+CSQ8Uvp4JSyBggwbOEs3RNRw5uOPGtlrR4aipregn+A
	 BYn5DfYdOpVwGtEwVuc+4ZZHFb8s8jy6PjOHZYwlc47Z1h54qshHdCG2JbfO0OLsHp
	 2OXv5RBkjZE6m6+YwX4BGAG+M8PfetbI+Zmojixw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 048/570] can: ucan: Fix infinite loop from zero-length messages
Date: Mon, 13 Apr 2026 17:52:59 +0200
Message-ID: <20260413155832.239501637@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1e446fd0582ad8be9f6dafb115fc2e7245f9bea7 upstream.

If a broken ucan device gets a message with the message length field set
to 0, then the driver will loop for forever in
ucan_read_bulk_callback(), hanging the system.  If the length is 0, just
skip the message and go on to the next one.

This has been fixed in the kvaser_usb driver in the past in commit
0c73772cd2b8 ("can: kvaser_usb: leaf: Fix potential infinite loop in
command parsers"), so there must be some broken devices out there like
this somewhere.

Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022319-huff-absurd-6a18@gregkh
Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -747,7 +747,7 @@ static void ucan_read_bulk_callback(stru
 		len = le16_to_cpu(m->len);
 
 		/* check sanity (length of content) */
-		if (urb->actual_length - pos < len) {
+		if ((len == 0) || (urb->actual_length - pos < len)) {
 			netdev_warn(up->netdev,
 				    "invalid message (short; no data; l:%d)\n",
 				    urb->actual_length);


