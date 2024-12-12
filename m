Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2AC22540B;
	Thu, 12 Dec 2024 17:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025608; cv=none; b=iMNR+SbS2JM1X0UD2pv7JE0UymEvF84vC6+KR/5G65/vH69VBvyBNw51T1cwMbYsz4S+t7cAE6l12PtxYvxv7JxZF2rTUnFDh4r8A+OcNRdOlqohxiYbq1FHPn/nv30mJA6XeVt69Wmg8Ap33Y5MGwMaXb4JTEa6rgtqipsMcBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025608; c=relaxed/simple;
	bh=sVnp4+04EqbjpHBW9PRbeKoPc/tb99MTDSsDlum64jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1xRCSFkpF2mPsykNK1flJfxt3XAGqgWC9bAH+wkgjwlh8tP3LAra/orXNwMI5hYKvs9sA2a8kiQ4AItFuGjKdkynSAMu1fb7KAG8Ra1hRr29gK4H680YI29TEl4K6tiTKlpoEg4W+j9hSOCjQaciAN5IYx1+CT0IqMmsDOhDXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzbfEvy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzbfEvy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72D6C4CECE;
	Thu, 12 Dec 2024 17:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025608;
	bh=sVnp4+04EqbjpHBW9PRbeKoPc/tb99MTDSsDlum64jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzbfEvy1UKAnKharcuGy/xMkOKeaMuiiNfaLy+aCtn77B1mY2URJx7mmUeUxpyfwW
	 aMAxCcX9oBzZpT47nVLvY/rBfqP3V1eT7DVqc0tBVoAif4yUi2YGsQotkruBaslzBz
	 uq5QShBi08jp7DVhsYduIDpt0gulv/GQJtsii9hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d4e8dc385d9258220c31@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 226/321] can: j1939: j1939_session_new(): fix skb reference counting
Date: Thu, 12 Dec 2024 16:02:24 +0100
Message-ID: <20241212144238.904098361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1d926a0372e61..7cef19287a3ff 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1489,7 +1489,7 @@ static struct j1939_session *j1939_session_new(struct j1939_priv *priv,
 	session->state = J1939_SESSION_NEW;
 
 	skb_queue_head_init(&session->skb_queue);
-	skb_queue_tail(&session->skb_queue, skb);
+	skb_queue_tail(&session->skb_queue, skb_get(skb));
 
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(&session->skcb, skcb, sizeof(session->skcb));
-- 
2.43.0



