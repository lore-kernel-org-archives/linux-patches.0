Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D65A355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301102; cv=none; b=R7gGrOgbeHmK/uKNuraLwaPT8ImMrACtKrV0ce65wIw1HfloTyqxujyAbFKl2BCtvQSdfvkPsM0fYSmHbXMpxXQ0g0J5D1ahQaFZJCndAJ2jM474TkrUo+KI6kHdSQj3C7V3M2nLSlY68OnVrBquCcYfG4B/9mH7BSiApYpAsx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301102; c=relaxed/simple;
	bh=AEUpNpqoAuQ2Q1xqxf2wsmHdmVN+sS86TFOl6l60ZFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1WAlE+o/G7BwmFVBkZzChM7lJp2YlHK6oNGRtpg3bPGP4C0LYii7RRg7xMwPSneHCTPjhehj+l6SeVxMwTtg2eLSsV04PE+UnN+TvP9a27m6jBzCUJ8QcctJbKFc3YBkgTHmK1kXNZCD7TFOrjhdppsNCiv2RHdw18tvWVSaeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tD+33uoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tD+33uoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3310CC116D0;
	Sat, 28 Feb 2026 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301101;
	bh=AEUpNpqoAuQ2Q1xqxf2wsmHdmVN+sS86TFOl6l60ZFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tD+33uoaz4oszly7CB7yZGFj+oxIIhplebVveWJ10tn92YZqsrnv78qbyXM1ZjCLk
	 QbJLyKPTo96l9WAhc32ebd8F7rXLdNFD153Gs58zD0m4E9s4KLs7FjNJXP2b6keqOp
	 DN+RzsjUGGry9TNJRGiz8nxcxzLV9HGNJk5tsyOM4Bis/r74/M1LzAj5SfHyaEmpwl
	 GHbNF2DibLXEhqc7m0QFZPLjspPQH6xtGgkpEEzk/kuiOMSIrX7Wcads9EwL8r1P+v
	 Dhw7xO4PgE5NwWE5YJcH/u38Tzd6L3VEnYJB7v8LxbEZjjeXQ/sEbcLbVnMGHOO2eS
	 S+ZVy1am5lKeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mingj Ye <insyelu@gmail.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/752] net: usb: r8152: fix transmit queue timeout
Date: Sat, 28 Feb 2026 12:39:25 -0500
Message-ID: <20260228174750.1542406-254-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mingj Ye <insyelu@gmail.com>

[ Upstream commit 833dcd75d54f0bf5aa0a0781ff57456b421fbb40 ]

When the TX queue length reaches the threshold, the netdev watchdog
immediately detects a TX queue timeout.

This patch updates the trans_start timestamp of the transmit queue
on every asynchronous USB URB submission along the transmit path,
ensuring that the network watchdog accurately reflects ongoing
transmission activity.

Signed-off-by: Mingj Ye <insyelu@gmail.com>
Reviewed-by: Hayes Wang <hayeswang@realtek.com>
Link: https://patch.msgid.link/20260120015949.84996-1-insyelu@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 6a43054d5171f..da8de7b1a4891 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2449,6 +2449,8 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 	ret = usb_submit_urb(agg->urb, GFP_ATOMIC);
 	if (ret < 0)
 		usb_autopm_put_interface_async(tp->intf);
+	else
+		netif_trans_update(tp->netdev);
 
 out_tx_fill:
 	return ret;
-- 
2.51.0

