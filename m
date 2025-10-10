Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A34C2F5482;
	Fri, 10 Oct 2025 13:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102353; cv=none; b=L5XNft3oYC59qjb/U6iQh15lqqJbVw4fXjCNOGY3NknW3zSlipfbmanxQhUYS9EiOYJWq0+1cfK0r8Ub1TSZv+wXcI5dKhLvcDUGJseoOH6wWRRIain0GargenrAP8djwOkS2QVyrVhmfPgtioGAxZf6SeI4RjcGUYtRz0N+kgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102353; c=relaxed/simple;
	bh=nyGGYOHrZJGUtDhhjuvpX8nHl7P+UyzPC1mfWxnp8zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8CZJpnUS9T77GlBLQa6JYzqdEf2fmc8HgcJ20t6RfCHNJaHWcN1zTlvueQUuhGnwG6IagwMo3u1Dme/5cT30qQxXLQWlSNyVCrZidIspqu0wN8bsBB0yPFwIkl/FFR4ysLJffmYTpTiYaN6wzsZ5P8MIs6rYkxbtSSVZAKozJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQxQnO+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQxQnO+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3A2C4CEF1;
	Fri, 10 Oct 2025 13:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102353;
	bh=nyGGYOHrZJGUtDhhjuvpX8nHl7P+UyzPC1mfWxnp8zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQxQnO+Zpr5EXo6kfLgjOIdmineO9i6yLaEf7dbKW+DITh/xMTWWJqiar0cltMIAl
	 wO/9r516gGgR2uxKorkJup+3nnkJLNwE3+8dBwNlUkzPiWhycvJb0R2S+yByahqI5f
	 a5dspMDR9jTWr91XkqpATDp5xyCAsyWvYX2+at/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Tranh Ha <tranh.ha.xb@renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 26/41] can: rcar_canfd: Fix controller mode setting
Date: Fri, 10 Oct 2025 15:16:14 +0200
Message-ID: <20251010131334.365158106@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duy Nguyen <duy.nguyen.rh@renesas.com>

[ Upstream commit 5cff263606a10102a0ea19ff579eaa18fd5577ad ]

Driver configures register to choose controller mode before
setting all channels to reset mode leading to failure.
The patch corrects operation of mode setting.

Signed-off-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Signed-off-by: Tranh Ha <tranh.ha.xb@renesas.com>
Link: https://patch.msgid.link/TYWPR01MB87434739F83E27EDCD23DF44B416A@TYWPR01MB8743.jpnprd01.prod.outlook.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 7f10213738e5c..e2ae8d6a9de64 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -870,9 +870,6 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 	/* Reset Global error flags */
 	rcar_canfd_write(gpriv->base, RCANFD_GERFL, 0x0);
 
-	/* Set the controller into appropriate mode */
-	rcar_canfd_set_mode(gpriv);
-
 	/* Transition all Channels to reset mode */
 	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_clear_bit(gpriv->base,
@@ -892,6 +889,10 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 			return err;
 		}
 	}
+
+	/* Set the controller into appropriate mode */
+	rcar_canfd_set_mode(gpriv);
+
 	return 0;
 }
 
-- 
2.51.0



