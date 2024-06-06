Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB6F1B4C40;
	Thu,  6 Jun 2024 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683446; cv=none; b=pF0egPY3VOGiXsT+XloiLPcuUPJTOLa+XlI09dY+iRLTg9AxKk1OPmRalV5vE7YF7IOtN2hI12ZDTEKvziSrCh8qiSCLpNY69wp5+vIy4WeLeJjxXYMhlNWoFs2nMXyz7r+3Q1JFLzD6SZIQB3mWIqH3CACz4ftbt7bWqk1tVdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683446; c=relaxed/simple;
	bh=RxxCfO+OXqtz+nxdAhc11dGmTo+YT0iFXGShEmJfCU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaKbHUZmJ5IHTjvEv66MazFkq0tVO5/ZAG1Pr2RGvGVxenPptWWg9tRxb7mf6H1zC1RoKfMg0vBTLMcxM0wrPOKT58/K6M9LYWQf4QQHULbY6CfAeJcUeQKbcGFjH7lb9Je4tw3iEwv5Bl+GWVyhHsHI/0FGlI+TypAIRCXBZu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml5IM6x1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml5IM6x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB676C2BD10;
	Thu,  6 Jun 2024 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683445;
	bh=RxxCfO+OXqtz+nxdAhc11dGmTo+YT0iFXGShEmJfCU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ml5IM6x1p9Rt+EnRqoWdQ991GhXzm6JCaISkGzXyWgEsSy6h+lJL6QjEgryvfNQC3
	 JuicMkIb2eewTfFFTXwlqXgy/pk7+QR34IokG+yR5r/iCatC4kZO/6RhryugGO2Li3
	 S73PYfFe1a3FWRSZ1TzxtiECEJrzw2/lb8oXBaII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <chris.wulff@biamp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 330/473] usb: gadget: u_audio: Clear uac pointer when freed.
Date: Thu,  6 Jun 2024 16:04:19 +0200
Message-ID: <20240606131710.843874981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wulff <Chris.Wulff@biamp.com>

[ Upstream commit a2cf936ebef291ef7395172b9e2f624779fb6dc0 ]

This prevents use of a stale pointer if functions are called after
g_cleanup that shouldn't be. This doesn't fix any races, but converts
a possibly silent kernel memory corruption into an obvious NULL pointer
dereference report.

Fixes: eb9fecb9e69b ("usb: gadget: f_uac2: split out audio core")
Signed-off-by: Chris Wulff <chris.wulff@biamp.com>
Link: https://lore.kernel.org/stable/CO1PR17MB54194226DA08BFC9EBD8C163E1172%40CO1PR17MB5419.namprd17.prod.outlook.com
Link: https://lore.kernel.org/r/CO1PR17MB54194226DA08BFC9EBD8C163E1172@CO1PR17MB5419.namprd17.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index c8e8154c59f50..ec1dceb087293 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -1419,6 +1419,8 @@ void g_audio_cleanup(struct g_audio *g_audio)
 		return;
 
 	uac = g_audio->uac;
+	g_audio->uac = NULL;
+
 	card = uac->card;
 	if (card)
 		snd_card_free_when_closed(card);
-- 
2.43.0



