Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04333D4E2;
	Thu, 30 Jul 2026 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421690; cv=none; b=Bd4Pb9jW+jQe3H/Y47dyhHEkkCJiElgNZcFpwwYeSpkARwDBiStRdwI4jDTbhXSf7rYmW0Plzat5+FAkmGeFwGFgaPxgjquTpzGhSQu73E6sa14dl+Pvn9Wy6O3IVAsrvmntHSb5Bx9h1n1pCGPxlxN5G+5Yatmp6QsadWkQeps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421690; c=relaxed/simple;
	bh=YDHRD+z33kZolV6mR+4CrqS5G8MBpNFyyxz3AM/RA6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKi65APNU4WGqOCDeP+08u4OTsf/17p8+uO5Zc2SMmgHoc6de/vUB0so9iBCJqfUA4iXRj1uQ3pf+aTIq6FKCWv1MW6WT98+vCVzExXYXXNgGRulu5qx0WTQcJ7fM8Bi2Nzid+dQX+QNSkFcdukPgNrxcQ74tcb6gRKnpomdw00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjFBdhCW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjFBdhCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285521F00A3A;
	Thu, 30 Jul 2026 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421688;
	bh=FhNeMNyJlDiP180yCMQXQuHlgallBSmqrbFWrPsgi2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjFBdhCWFRqodBofviL32T/FHZomf5Dd7G+bvypVDZnia4TFioyfi8OwPplSSxnej
	 BKc40wrt7YOyGo8hXJve09T4DPvznrcUuKNoyREVoq2EPzNxV4sJ6Mg+Ng07c+vSxx
	 E5uIrDZl2brR2N0hZDxgSAdUQin9VtHNDCJ3/IE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 189/744] wifi: carl9170: bound memcpy length in cmd callback to prevent OOB read
Date: Thu, 30 Jul 2026 16:07:42 +0200
Message-ID: <20260730141448.301821839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 4cde55b2feff9504d1f993ab80e84e7ccb62791c ]

When the firmware sends a command response with a length mismatch,
carl9170_cmd_callback() logs the mismatch and calls carl9170_restart()
but then falls through to memcpy(ar->readbuf, buffer + 4, len - 4).
Since len comes from the firmware and can exceed ar->readlen, this
copies more data than the readbuf was allocated for.

Bound the memcpy to min(len - 4, ar->readlen) so that the response
is still completed -- avoiding repeated restarts from queued garbage --
while preventing an overread past the response buffer.

Fixes: a84fab3cbfdc ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
Link: https://patch.msgid.link/20260421134929.325662-2-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 6833430130f4ca..f6855efc05c0f1 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -150,7 +150,8 @@ static void carl9170_cmd_callback(struct ar9170 *ar, u32 len, void *buffer)
 	spin_lock(&ar->cmd_lock);
 	if (ar->readbuf) {
 		if (len >= 4)
-			memcpy(ar->readbuf, buffer + 4, len - 4);
+			memcpy(ar->readbuf, buffer + 4,
+			       min_t(u32, len - 4, ar->readlen));
 
 		ar->readbuf = NULL;
 	}
-- 
2.53.0



