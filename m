Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F52E222D4C;
	Thu, 12 Dec 2024 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024553; cv=none; b=EyuR7X+TQh9GipITw59AN8zCjiwXpDxWQANzKRYk5nryQ4y6tybICmJrh3wlD3G80mJ0OJLnHkbPKKkIFQ5WkIrUac23COp/3LyL+03HUX23HawgX9RMDsfctBfCBsLDxuUkmQmyiPJ44X2An9CkxkQq/jHSC33SN0ad19vV2j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024553; c=relaxed/simple;
	bh=6xYqisBupcpvqghjWLQ/PHLHyRMnlvpDBhvleHtDhb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAr6mpS+qmuXXBqZJPqtbahuaayJ4OoAMoUZNS3pk2tcOOF4wYDaYZaKC7fIjL5u22zu4CmHzS0HtnUYwFUtBMpBsHSRbiVnytJs+u1RAUOmx79pXPznQQa8y2+zMLQoK+RLFYFKaMjievTNV3ceULREVkVlFYEHR1nBfNvlecI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsuA5zTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsuA5zTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094E7C4CED0;
	Thu, 12 Dec 2024 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024553;
	bh=6xYqisBupcpvqghjWLQ/PHLHyRMnlvpDBhvleHtDhb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsuA5zTXInrNd5btzEx3Ki2XNQ3B0nWS6E5U3A4GCZvXXz6UkcFrutsntQII5DPaq
	 r2qIxcvZg73dGRJPnpVxsdqPfW3n8moSSqpks4fvTlpiQn9BvOKa1TY/h/2giHHhDF
	 L9F8aM6AdokLlJBeYOwd3IiV+bIjALjVJ3hkTLt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d4e8dc385d9258220c31@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/459] can: j1939: j1939_session_new(): fix skb reference counting
Date: Thu, 12 Dec 2024 16:01:12 +0100
Message-ID: <20241212144306.855769133@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a86256ab14022..84d63fb29ca1f 100644
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



