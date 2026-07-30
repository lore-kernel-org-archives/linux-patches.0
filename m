Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A576643E08D;
	Thu, 30 Jul 2026 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421692; cv=none; b=TSWozgbdbfYXym1kYJT3Mo32AKMFLqKThZt0cYEnrzrYOEY9NQM0E+o+h35G0ssINmCk+TxfhRID7GLGfZapDDKLV8MUuLf+20eUWweE6xULsY/CMhpCsWZ/9kvEpWkGPRBSG73IYlvZ0BinaVWmfYZMRX2/D/4X0HUmvMdN2U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421692; c=relaxed/simple;
	bh=qazMgzhcvGIA222QzGYC5GtVrt3xLHPtxaWAapaNSPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWESQYTkPlB+WNEz6xIXA05khx77el33D+eejaaxgOXYp+VztVQATLPI/PeUDrDED+jKhnwYAlSY5bx2S8dGWqqnE9UFKzPb+Nx/q+Pn4hsAr+o3ZvESyiaoVKVVx+SiUJYd4pfX9MFYl4EuqGbs8Y6xi4R/FFfIfjnU8qwO3/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0G8dVNqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0G8dVNqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F371A1F000E9;
	Thu, 30 Jul 2026 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421691;
	bh=oF5L2RyvxP/3BOjrYdFvJNeY8QrDxmi+YibIKqIfkNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0G8dVNqAxhcw6pRuDMV8wzPOnk2k78Nt1dLJU9sSG/ZBNXWMm9Eg09BcbvszWst6n
	 zF0o5PRDtsA25xtmNqMSjPTpDYizhr53ceKE25ZroDajKKQ5NKxkgFgKFQmtJz5Nal
	 Lqbmr1tgchx79FZETJfqjb2ClK4N1eTNn2Xu9NEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 190/744] wifi: carl9170: fix OOB read from off-by-two in TX status handler
Date: Thu, 30 Jul 2026 16:07:43 +0200
Message-ID: <20260730141448.321882669@linuxfoundation.org>
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
index 59caf1e4b15893..06aaf281655b1e 100644
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



