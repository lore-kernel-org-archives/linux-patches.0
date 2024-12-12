Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEB4217707;
	Thu, 12 Dec 2024 15:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017482; cv=none; b=ZR/ve1rWxGWdpbwGPJ/Cy43Kf2/convFmSxFiUroE2dBHmD56JNFsjejluanWrbuWW8WQor8HTXH7fp1PcGbCZbLDgrAnEmCpsFflEKHq5KgYxKjwoYpTQuxyXTPEcju8ZopLESnokKqkh55YlnTGFBYt5Z0Txt5U5XoDHxinfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017482; c=relaxed/simple;
	bh=xK4+KTNgN/GgQW7K+IEjBGtCOgGiPeCphuq6qOWO+Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el76AdlTFL8kqiEDtI8k4Lfa7R2cd0s6A5ryvmADg5l5dpU7T2VXyFihAtOJmg7nJIejmHdxN6kWpVcEcpevHJHlmVIAZdgKX0I6rzLo1OvnCxhqdhFgGEEMmGL+PJB79RTZg0Mbr88MC2tC5urOioslAzsBa//1ul/tBSXs2KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHUe8DWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHUe8DWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D80C4CECE;
	Thu, 12 Dec 2024 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017482;
	bh=xK4+KTNgN/GgQW7K+IEjBGtCOgGiPeCphuq6qOWO+Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHUe8DWp6ncisTgb/ID42F1D7DHUq/tG/iBY/VY7xhhxX+cHHszkB9zgs1ipibPy1
	 pZ3O3IFmHaz76SZ+fXL18TUOv/1GqZhsY8FhJ7zpOl3ZmIvJpRMtLGba1MAxf5He/D
	 zwG3yXucxz+NKmQrLW9ZMUkvwD3iDzcmZMTb01gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d4e8dc385d9258220c31@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/356] can: j1939: j1939_session_new(): fix skb reference counting
Date: Thu, 12 Dec 2024 15:55:44 +0100
Message-ID: <20241212144245.624833652@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit a8c695005bfe6569acd73d777ca298ddddd66105 ]

Since j1939_session_skb_queue() does an extra skb_get() for each new
skb, do the same for the initial one in j1939_session_new() to avoid
refcount underflow.

Reported-by: syzbot+d4e8dc385d9258220c31@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d4e8dc385d9258220c31
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20241105094823.2403806-1-dmantipov@yandex.ru
[mkl: clean up commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 319f47df33300..95f7a7e65a73f 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1505,7 +1505,7 @@ static struct j1939_session *j1939_session_new(struct j1939_priv *priv,
 	session->state = J1939_SESSION_NEW;
 
 	skb_queue_head_init(&session->skb_queue);
-	skb_queue_tail(&session->skb_queue, skb);
+	skb_queue_tail(&session->skb_queue, skb_get(skb));
 
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(&session->skcb, skcb, sizeof(session->skcb));
-- 
2.43.0



