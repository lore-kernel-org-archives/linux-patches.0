Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11172F1FDF;
	Mon, 17 Aug 2026 15:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979183; cv=none; b=GmMqS9Jy7/zcZtHjb7/DNYScf+JWlx5dYPyTnMICHbQ1CXrglfe7RmIEaXfjirH4daxh73SUncksv6wVqIaNnMwcVVjDTcJklpnyNezANjgCAagLCSw9qB4xImEgml4YQS6zYDJbcto2YBE2LvBfCTnyl+N83yz1ueIEHQQEWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979183; c=relaxed/simple;
	bh=oysxu0YyiuCqN5h9F+8qKNqmSpiVtV6+marJyKOR51s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgxhBANAbtIvmekKYg0C7Y0rpwF+vyNPdFeVQYAi8n9nhcpI5RWkrOocj11seLTPu06bw2aVY51wDf8/6s/CFVm1PXduk4DCws5Lctai1tc5jLQpIJ3KtKxvzuNQThlC76vykSBJEpMurgM6Ku6mUicATGOKNF8R6SczJ8NTkcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CryNsBdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CryNsBdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F271F000E9;
	Mon, 17 Aug 2026 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979182;
	bh=X9XCeP5AnFwxe9pwqBVKNHcqy6v468EnWzEd/KrejPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CryNsBdh4XE1KiMGbuAVvI9czEmzLi0FED0BSnENUFvy9/jaQ6jk0voALtWMDkrVL
	 fpvGeAXI31gHCUqWKX3MNU0bSdgAhPfzgSl1uNICoApisJ1GETa0ZECwmyME1Hj2l9
	 bJvUjWlzpQ8Zslbv3wSecFLFj6UFCC71rsiBBoqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/609] wifi: carl9170: fix OOB read from off-by-two in TX status handler
Date: Mon, 17 Aug 2026 15:26:46 +0200
Message-ID: <20260817132547.425365620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 88ef6e023f8266..d036ebb42c0d24 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -693,7 +693,7 @@ void carl9170_tx_process_status(struct ar9170 *ar,
 	unsigned int i;
 
 	for (i = 0;  i < cmd->hdr.ext; i++) {
-		if (WARN_ON(i > ((cmd->hdr.len / 2) + 1))) {
+		if (WARN_ON(i >= (cmd->hdr.len / 2))) {
 			print_hex_dump_bytes("UU:", DUMP_PREFIX_NONE,
 					     (void *) cmd, cmd->hdr.len + 4);
 			break;
-- 
2.53.0



