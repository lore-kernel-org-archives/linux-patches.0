Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70C92F7ABF;
	Wed, 17 Sep 2025 12:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113183; cv=none; b=owvJUsHZzyHrXRDCtSJW1BDkxBDAPYbvYX8AeacVUpONLMgPcSNYjVPhfXYNRD2eztj6jwQjagVugX1IOEMmiBhDZCcoZXlC8mbKKVwJXjpR+bWtRBcow8aLpc6BIcPWOxqnRokwJuyCUGOF3qLwC4Essvxu+7LCtSWb+W1OHQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113183; c=relaxed/simple;
	bh=zWfa27CMUIpb2MWTfvCbZ053Q5j9mhwvMclYMsqOfR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRae3he+MKVD95/D3sPs7XEW/32BM6pXZ22LCXLKH6k34IWpBgL3edq8HkENyOj1vXsbHl64+2FWjtYv5+GeI2tSKRrakUdE9ZkU65kMMzUoUsxhfLNts8ZmXAZowRVccMyE1qJ8yXtg+eoNcRZitdTXN/G/ZtVxzBLgOtACj84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbCJrdMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbCJrdMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69CDC4CEF0;
	Wed, 17 Sep 2025 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113182;
	bh=zWfa27CMUIpb2MWTfvCbZ053Q5j9mhwvMclYMsqOfR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbCJrdMbAgAkXFY7vLLW/HZ7n3jiJuFLvXlbwoCa3UUbKzTzGdlHA9jtwn3tYan62
	 yzqEemP7EC+vRMAtbDwrhbHKuC0IRuNCkcvCPSZyS7ix52E3yIRAz8AAfWBPRL0Ixe
	 v04oRfTNIriTefNVwXmkLzTdlKvfx+B1L1VAHnHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 150/189] can: j1939: j1939_local_ecu_get(): undo increment when j1939_local_ecu_get() fails
Date: Wed, 17 Sep 2025 14:34:20 +0200
Message-ID: <20250917123355.534167818@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 39844f14eed86..797719cb227ec 100644
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



