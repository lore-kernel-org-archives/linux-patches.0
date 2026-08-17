Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3974E3BF689;
	Mon, 17 Aug 2026 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976743; cv=none; b=VHJrU9aBA/c8OlwZut+symKkepAnjuX7H9wTOXe9o5W7S+lvFHeDEyqLBSgY7HkmbAN0VbALpTb2YcabMtHqra7cjAj7xNl0z9ZhaQPOMSuBe/m2ZNWbC1cqhLx/Dv7qLYmHNc2PAHxt/Hf0uHlpZ4wNRTjEeU7FtGQ4UKGonts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976743; c=relaxed/simple;
	bh=SVUukVs4SCisCeEU5uweleM9D7sI9gKP4EFdXPZVHjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmnTI7ma1xHgOxywDPpF1KRMTXYe3hpy7vhwDeHYPyWddb9wQYrkhbbW9Fhu7Y7PvyUuvVHqh/d/gxjCd2eYSqvctAlbzES4niXV0f1Tlzd7tuJojbsfu4HMVyB+lOoHUrNRVkx8bQFolPZKMXWw1AJdvF1/RPIC1cB+0ybT0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ck0yUer; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ck0yUer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931A21F000E9;
	Mon, 17 Aug 2026 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976742;
	bh=scxIOm/ycEd/0JH0oRlcfrFnRSYiSn/HBXXYQeMPZCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Ck0yUerQTm7Z47rEZRqNyQ62MtmIkS40GEUvhM4MULkNiu7rye7lJXK9nufB4Q9W
	 G1ao7vLa5YcHki0USHfb/61xt6Tc9Gw9KIfIGOpUaN8I7F0lgJTzy5BKz+IGLnJ4pd
	 6U8oanfE2/lhHfI/rlDy3ZYwhnMiLWmsDi4HAE34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/456] wifi: carl9170: fix OOB read from off-by-two in TX status handler
Date: Mon, 17 Aug 2026 15:27:57 +0200
Message-ID: <20260817132543.521468426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index f9e1306ac74fe3..db49f334e52e2d 100644
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



