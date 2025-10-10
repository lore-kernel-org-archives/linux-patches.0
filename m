Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475A621579F;
	Fri, 10 Oct 2025 13:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102445; cv=none; b=UDheOTcvdQ8vX2uRbCtUq+EpbPU1nNmBAwIaQXZkGlzoL0XJlNYV3djKQKrnUF4C2rcNv4yoPnOkTYlEuc071xQ9k4nwdpb0CCcYbE+SLS7T8vLizJg1PcBvrLzukiqKKoiJOvxdgafpQXaKA5W8WZdedhHpTT9ApO6L7ih6qCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102445; c=relaxed/simple;
	bh=FZQlJ/2bL0YOM8kKk6HNAVYbZ1/XcNhZ33DoyDlPvRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e362XNhyePGLS5HxxTGLdSk3ycZHBxzpAeq0vXSi2lwmcnxuigXNqY7sDQLknZsmvSL74NB48Rs1eCOk4pg3LxCQJgbnihkLJ49QXD3EbT0y/VoYnPS5DhhRgM1KrnpdEh9tR/OTv8YOANuXiaI24W0RZ1UVUj562oEUXOFHh78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pND8nTXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pND8nTXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6873C4CEF1;
	Fri, 10 Oct 2025 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102445;
	bh=FZQlJ/2bL0YOM8kKk6HNAVYbZ1/XcNhZ33DoyDlPvRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pND8nTXdtjiYZksjXhSUACEiuVizMXn/bLNTgSz+LM9AQ/gNnv8vX1wjushx3BmU1
	 4Q3Pmp3W9gS4INsSAGzVfXDBFVN8+7KzVi7ib274Cndu6Iz8il4oiHT4KI8VueV/7o
	 2FTGPFGAaVx5wxOqDWJy46gQThFZdhJ18dGfNsKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Tranh Ha <tranh.ha.xb@renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 17/35] can: rcar_canfd: Fix controller mode setting
Date: Fri, 10 Oct 2025 15:16:19 +0200
Message-ID: <20251010131332.416692187@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa3df0d05b853..24dd15c917228 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -732,9 +732,6 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 	/* Reset Global error flags */
 	rcar_canfd_write(gpriv->base, RCANFD_GERFL, 0x0);
 
-	/* Set the controller into appropriate mode */
-	rcar_canfd_set_mode(gpriv);
-
 	/* Transition all Channels to reset mode */
 	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_clear_bit(gpriv->base,
@@ -754,6 +751,10 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
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



