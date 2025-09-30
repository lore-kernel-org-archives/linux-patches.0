Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B074F1487F4;
	Tue, 30 Sep 2025 15:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245032; cv=none; b=hh2svEpb/fitCcxaA9fdqhrvMN20wNDSf9XlhfgTyRokGw56Rvs/btYEjidtXCZuWO+luANg1gwfiQsiENPqTszS4DHDPlcKxEHTLB/O+VAMP1gzv2w89iDRidY80XrDzlqIBhWKWw0eryB7IPVoV+0wL/8MepWxgKYmMOoHBtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245032; c=relaxed/simple;
	bh=p+jl7LPnFODa1Zuvs0OBMM3JivFZbMAgyeegqy3DrUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xv9txcRrjRZpfrexONyR55k9II6Bt/TO0m8Tq7vvu+maKEyGvMAtXrDDG29Z3uqqdrMFzHMo7Zc0HKBZEK5ZyAfAaFRNRENXAO9NNNiox4moTwZcw6evu1xYd6RsBleCs7liGkqAvzVRvH7c/M1m/Vaoyp31AKzrHAAa82WNA6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OM6mzx/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OM6mzx/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D92C4CEF0;
	Tue, 30 Sep 2025 15:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245032;
	bh=p+jl7LPnFODa1Zuvs0OBMM3JivFZbMAgyeegqy3DrUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM6mzx/HUfyVADJI/Sp8XBRMKHjSXscHSVHdTwqWbStdqcslUmdDJxDZDOHAd4TB6
	 mBJaBjH+ORyvkv9Uuul8qhYRvtB6x/1IXng+ry+S7Cxqbw9XzwXwmlDli+DmXBnnjr
	 YNes2whtDhY0W/dENXh7ThNPAYHqaGbPQDtDFbbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/151] can: j1939: j1939_local_ecu_get(): undo increment when j1939_local_ecu_get() fails
Date: Tue, 30 Sep 2025 16:46:15 +0200
Message-ID: <20250930143829.402247914@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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



