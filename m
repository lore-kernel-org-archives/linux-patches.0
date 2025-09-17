Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C1931618F;
	Wed, 17 Sep 2025 13:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114140; cv=none; b=Ytd1uz7UDe5dyAWBJoeLDyqBINqSVVvlG35vu6srWodHjlNZ4WsH1zIDPBme73I6Iv95bQ2Ny3c03Ac1pqLRV+LlrUAKJ8+VQT2F28/pY1630j1uUWlDzgMV4vEUOLTIHdO+qxidUvWljARf94Rfn+cRFSJoa0dtSoXRZC4+mg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114140; c=relaxed/simple;
	bh=GPph3sYwaEoP8AWlMydlCwshtGNC6a6UuoLOCUxnPf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcksRCM6KMw2DvD9u8I7UUCHznsbzKtp5tCQwR33l00zqFtzZdzAzhgHrvhGhScdKNf9swLDRsjsyMsCOrIsTLBEn8lySWde63IsXws5UdTNiZkhRdLZt7W+7RYFf+6E89pnvlrPMY6saQtYxXB5PCD239w91C3dZDR+pLRBOAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKwrQfCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKwrQfCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67120C4CEF0;
	Wed, 17 Sep 2025 13:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114139;
	bh=GPph3sYwaEoP8AWlMydlCwshtGNC6a6UuoLOCUxnPf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKwrQfCrtWxZpfDlYRgKlCyHIxNns2WEzu2lzd/RCAC0CMkrUdwXmUhiSMW8EGfAt
	 yS4yJX2t/j452MVJ1nTlP8LDtvf8jzkvwdYHTWgqJuJiguU7I4o8N9imAvRkia3RD2
	 4aNjeDQABKTbKqCvmqfDYaxZL7tQT/Wi00Efn6+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 57/78] can: j1939: j1939_local_ecu_get(): undo increment when j1939_local_ecu_get() fails
Date: Wed, 17 Sep 2025 14:35:18 +0200
Message-ID: <20250917123330.961828155@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 06e02da29f6f1a45fc07bd60c7eaf172dc21e334 ]

Since j1939_sk_bind() and j1939_sk_release() call j1939_local_ecu_put()
when J1939_SOCK_BOUND was already set, but the error handling path for
j1939_sk_bind() will not set J1939_SOCK_BOUND when j1939_local_ecu_get()
fails, j1939_local_ecu_get() needs to undo priv->ents[sa].nusers++ when
j1939_local_ecu_get() returns an error.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/e7f80046-4ff7-4ce2-8ad8-7c3c678a42c9@I-love.SAKURA.ne.jp
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/bus.c b/net/can/j1939/bus.c
index 4866879016021..e0b966c2517cf 100644
--- a/net/can/j1939/bus.c
+++ b/net/can/j1939/bus.c
@@ -290,8 +290,11 @@ int j1939_local_ecu_get(struct j1939_priv *priv, name_t name, u8 sa)
 	if (!ecu)
 		ecu = j1939_ecu_create_locked(priv, name);
 	err = PTR_ERR_OR_ZERO(ecu);
-	if (err)
+	if (err) {
+		if (j1939_address_is_unicast(sa))
+			priv->ents[sa].nusers--;
 		goto done;
+	}
 
 	ecu->nusers++;
 	/* TODO: do we care if ecu->addr != sa? */
-- 
2.51.0



