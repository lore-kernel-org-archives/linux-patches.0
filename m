Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFED1DE4E0;
	Mon, 23 Mar 2026 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277815; cv=none; b=fpUs38rFu/1oXEFTEsWqxzCAs7FLzai56fQjf1f99bZQAaPeH9ULgE1DDsGsNqUe6dXFXHm4LwiyTm2Nhm3kBUSpFnVlkGwwOE4AYwenCT3oKm6O3MwpdhYnkxV2agPyzByB7bWs91PpxU41H6wIvkQWVBgdqsk4koQimxPZN+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277815; c=relaxed/simple;
	bh=W5f31ixmXji09/6s8eDnMrnweP+wrTStkdqJUjiKzR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQIocY4PgfqzHir1NvDJGK/Y15owsLF2iycfx/Qb1+Hjd5ESgVYtFMM8BeKFhUWCrHdz0kn3acjmsB6nKSg2YDlpROJuZ5b7At0FNCWRsnyAoxu6N2OVlLkN+XbKbJqfFPkKYeuDZnl4ltRNrJ+9WY18A9yCMbLIRGBpW0tcWR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lphWPA4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lphWPA4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F00C4CEF7;
	Mon, 23 Mar 2026 14:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277815;
	bh=W5f31ixmXji09/6s8eDnMrnweP+wrTStkdqJUjiKzR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lphWPA4r/jl2zhwQ5gQeQUrxI9e0upHmZgyGJyZUsC2cQJi7QVuwmJDzCR6M/n5Wv
	 CvR/Gsmi6KIg6gqbWAzk5IuHkxokHgGV2/YJKDoNTv7nzqZ6PMtY11TosjTUgCJ/zQ
	 Nxg8YP935UoeBQCIKgd2Ysgb7mD/WPVb5Hmn9MuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 095/567] can: ucan: Fix infinite loop from zero-length messages
Date: Mon, 23 Mar 2026 14:40:15 +0100
Message-ID: <20260323134536.178623756@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -749,7 +749,7 @@ static void ucan_read_bulk_callback(stru
 		len = le16_to_cpu(m->len);
 
 		/* check sanity (length of content) */
-		if (urb->actual_length - pos < len) {
+		if ((len == 0) || (urb->actual_length - pos < len)) {
 			netdev_warn(up->netdev,
 				    "invalid message (short; no data; l:%d)\n",
 				    urb->actual_length);


