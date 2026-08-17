Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D1B3F326E;
	Mon, 17 Aug 2026 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975666; cv=none; b=fSlV8BXR2KJmqCSbBKpO0I5dTHAd2+E8B5ciR9pA5AUaX78Dq3rHEJEnlMWgFan5hXsYn77Vk1ulnaYJ2JcnY9EmeoTqu+eawKLoUqSqFJcxavY3dDiNs+sf6Wz0zPVOaRc7skHMe+SZRY6M8k/xvNZkzCzqRC0nCLqA6hiiIeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975666; c=relaxed/simple;
	bh=uleS3sXHIHzEqTkl+VteSquPKFEUcikB8KylN43HUBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVgkq/KsCpx8IZzKr3BIVzGOp+pgQcXVegnKq6NVHSI3ZbYfsgyjRh+/KtWDz//SAx0UwKKGIlQDKe1m2u45Y2ux1Iu0VSqOLNKD6wjbyk04wU1uZ0AI6sYYv27Zk4uWLCxeDijUorkw7wvnzK8VNQKpRuMSWFzJq4oGVp4NaOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyRztFdc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyRztFdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AC01F00A3A;
	Mon, 17 Aug 2026 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975664;
	bh=6fteWhMuv1KBO2ISiE5Emp/Ksut0VMb6EXrxHaEfAFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyRztFdcKK+9VjuNkzpQtGUqQDF2Taw/EQbQpPfw4x0WoPXk5sPAgdcWV6BKHTN8I
	 ro/h90QzQI4urwvSQ7fLRE3/No9F2E8YzpGz0OdEE4zL3H92IVjGQGsM/DbWFaY8DP
	 z1MAHsZCG+724k9oVAakZIsYFqGlANo/+oNTGv3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/389] wifi: carl9170: fix OOB read from off-by-two in TX status handler
Date: Mon, 17 Aug 2026 15:28:28 +0200
Message-ID: <20260817132541.795929725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit a3f42f1049ad80c65560d2b078ad426c3134f78d ]

The bounds check in carl9170_tx_process_status() uses
`i > ((cmd->hdr.len / 2) + 1)` which is off by two, allowing
2 extra iterations past valid _tx_status entries when the firmware-
controlled hdr.ext exceeds hdr.len/2. Fix by using the correct
comparison `i >= (cmd->hdr.len / 2)`.

Fixes: a84fab3cbfdc ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
Link: https://patch.msgid.link/20260421134929.325662-3-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 43050dc7b98dfd..743c088dffb098 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -692,7 +692,7 @@ void carl9170_tx_process_status(struct ar9170 *ar,
 	unsigned int i;
 
 	for (i = 0;  i < cmd->hdr.ext; i++) {
-		if (WARN_ON(i > ((cmd->hdr.len / 2) + 1))) {
+		if (WARN_ON(i >= (cmd->hdr.len / 2))) {
 			print_hex_dump_bytes("UU:", DUMP_PREFIX_NONE,
 					     (void *) cmd, cmd->hdr.len + 4);
 			break;
-- 
2.53.0



