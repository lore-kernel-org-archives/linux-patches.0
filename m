Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB9F303C97;
	Mon, 17 Aug 2026 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975674; cv=none; b=OmpH3h1JWxVrn6rM/S7o5FmkMyDAhDWS+UD38AMr/ICvzmPDtbdw7eYK+OWimu6bPk84go33/cTiZFIWISS/UfubgmtePdoSDZalMmtwEPHLLtoS06X1pqrtmsjzHwhkQsqK4c0V/93jp+QmtqtgqITsdauPI4TTuf7hIwLvtG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975674; c=relaxed/simple;
	bh=dnLkA/ejc4eyEn6U8QD/OHPgokfN0Yn755BOM41vr1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3vu/mU64t+7+sqIWRPRgCWhOhQIMDcFmINfw4kNv7qTPOVc/GocZ6lp+NgLiMs5/7Pa28qGWgWOJQ4cUmMhCO+RvZi5n+YEQrJcztHgEHp/auXRnFuVeC49JtElM5E3UAjkQMpCUTzY+bNJ9eFXe9/RtoA4tqFVD+8xBqI3OJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBk29W6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBk29W6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5CA1F000E9;
	Mon, 17 Aug 2026 14:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975673;
	bh=Qew0w0K926SOtm0xUya6MqsRuhTMqQyn4jxXdFaSjHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBk29W6XFv6VFqKgcPWgyW3iUG11pO5jnGXI6VjFGuLKadIDMR/yb2BvPwPYr58BW
	 q+9VEk7xCMTFlEpvadlf/Y3PS9ocd4am0ONOiPl3UnFUKXH9vX98V5NuLtbSjNuIan
	 ld8sp8FussiNgCldyB5lkRo9r2CDi39obg4EazpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/389] wifi: carl9170: fix buffer overflow in rx_stream failover path
Date: Mon, 17 Aug 2026 15:28:29 +0200
Message-ID: <20260817132541.833477619@linuxfoundation.org>
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

[ Upstream commit a1a21995c2e1cc2ca6b2226cfe4f5f018370182a ]

The failover continuation in carl9170_rx_stream() copies the full tlen
from the second USB transfer instead of capping at rx_failover_missing
bytes. When both transfers are near maximum size, the total exceeds the
65535-byte failover SKB, triggering skb_over_panic.

Limit the copy size to the missing byte count.

Fixes: a84fab3cbfdc ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
Link: https://patch.msgid.link/20260421134929.325662-4-tristmd@gmail.com
[Fix checkpatch CHECK:PARENTHESIS_ALIGNMENT]
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 9a25c2a540b95f..bda30b1f940459 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -918,7 +918,9 @@ static void carl9170_rx_stream(struct ar9170 *ar, void *buf, unsigned int len)
 				}
 			}
 
-			skb_put_data(ar->rx_failover, tbuf, tlen);
+			skb_put_data(ar->rx_failover, tbuf,
+				     min_t(unsigned int, tlen,
+					   ar->rx_failover_missing));
 			ar->rx_failover_missing -= tlen;
 
 			if (ar->rx_failover_missing <= 0) {
-- 
2.53.0



