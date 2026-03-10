Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C835537417C;
	Tue, 10 Mar 2026 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141107; cv=none; b=CtJbrrECHRX11TrXvWRlLx2HQbs+/3ORhdLjoBvMOyEOc38kXDR5yndOqguVry6YP/h3fkHWSZfppzRxsj6Mbbh03v8g/n0zWjl8/qEFW+aWi0+MTed6aai3zF6wM4g041O8bwJdZqm73R1ov5A00Ra5QxAcz4WTE87AfQ0GM+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141107; c=relaxed/simple;
	bh=WK1792rvM+AiR+n2u/1SJXoB08OMK8VlVYA0Zhs6EyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/9PEE4ZZIdI5sxLpYWc6oyE9BfMytQ5JmpCbNnZrTu6MHrarVEFoxfu6Sk5skBC3OuvVa8/9SvcC4+pSx7TAmD/oWpzmcAvTEVoS0NN8DmBPQdIPigH3e9n+JJ2ZF4QDvL4P9z4LUM9eqHhcELIhCfPwjAY1mAwxwbqf/V2hd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3sK2FU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3sK2FU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA61C19423;
	Tue, 10 Mar 2026 11:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141107;
	bh=WK1792rvM+AiR+n2u/1SJXoB08OMK8VlVYA0Zhs6EyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3sK2FU+mStwSYOJIsTJFS1dhz47/eHqq9qYkGKCxBz4RSbGQ3KUKvW5jhMACQXBv
	 G2DP7NIArOy4jCdjORxRF9yMQCeSkLFC2rIEDR93Ozb3DB4UDZxZ+1/BY/RD0W4LIg
	 PH/Uf6C4vlKeTPyBeIvRe75prGj2N0oY/HDyu0OGBvfBaw9m/Pd/d5yWZPw5oSl1Hh
	 0zrnK/QV0RrTmfk0ciHVAUooA8Xfp+tPTyLSNhU0pj2c6ImEFoBZjFWeHAH7fABX83
	 QvIKI7EmpV+/A64vJASt9indvD6SMivEOkma4AfaryV+gafAzCvZ1mLOx5eH1Epu2L
	 IpOpAl3LDQzaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.19 109/311] can: ucan: Fix infinite loop from zero-length messages
Date: Tue, 10 Mar 2026 07:02:36 -0400
Message-ID: <e584abd7eaf9d847cb20d61837a6124147505a72.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 drivers/net/can/usb/ucan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index de61d9da99e35..87ddeff0937fb 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -749,7 +749,7 @@ static void ucan_read_bulk_callback(struct urb *urb)
 		len = le16_to_cpu(m->len);
 
 		/* check sanity (length of content) */
-		if (urb->actual_length - pos < len) {
+		if ((len == 0) || (urb->actual_length - pos < len)) {
 			netdev_warn(up->netdev,
 				    "invalid message (short; no data; l:%d)\n",
 				    urb->actual_length);
-- 
2.51.0

