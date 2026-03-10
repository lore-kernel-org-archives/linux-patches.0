Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE143876AA;
	Tue, 10 Mar 2026 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142013; cv=none; b=Y5yajLtiJvOqHbQu1j3wplqAxR3W/HelIikVQjNrUgpjbXcVuIx3ZP3KflQOMeLpKUAzCaNKr/3Wj/RS3tLXPongxI8NIWBd9yZc9v67HRtK8Go+mJXGpe3aNidaG8kk7EqJ7RgU76v3MWQlTHYQn5sBVX25Nq087vb62XQrOEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142013; c=relaxed/simple;
	bh=qIwRg2p5hIpqqWwocd5Twp1VrVFSoiseaXE+Kvy6fYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pECIHroo7nLP61mCg8QFgMlTQiFzbDZM+BE3/rW/dv54S2RRvXjGdPVfbKcsZ1UQOZRkZixlLNZWHhB0nS8Aprl7gJm1qX5Ti2dEV7ykzInfxJifDaVmyS3/WUqmYxS1817aTCvz0TD39ZaSr33X/apSLw1RP5ZwbZDQKi5wDPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TQCENa8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQCENa8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2321DC2BC9E;
	Tue, 10 Mar 2026 11:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142012;
	bh=qIwRg2p5hIpqqWwocd5Twp1VrVFSoiseaXE+Kvy6fYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQCENa8Ux2bIyXBcJ9OleAi6/adHHi8GT7RGm/AvFmcgix56NUUkfIAjKjbjbBk1k
	 bCRHo3loXqoXhisy1eknT1sddORd+Hqwq2mvMPPji1e1BDJMtyXjEbOCowxEgH8bTV
	 03vpe4y+ss+ITd4HIFBZLJeOB8pAcc1UTlHt8kJe9qMXrG7ApOst7bQPjC4m866D+r
	 lRmjQ0LBGGVqe5gBI3fX04fZS1e5kUw6siLZa9LEN5vRge9AICvpWQOCxGImLM7Oqw
	 wERKlTSUAkSOMT6TetTKITVH8ZTFF1R+4o/IEaXpFaULQDST1xURVxWL8Q7jaXK16Q
	 zEzXgtad5iM9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 139/314] can: ucan: Fix infinite loop from zero-length messages
Date: Tue, 10 Mar 2026 07:16:38 -0400
Message-ID: <4a524859d4d64dc9a045087a1d8fa88787e77a6a.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 07406daf7c88e..6c90b4a7d955a 100644
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

