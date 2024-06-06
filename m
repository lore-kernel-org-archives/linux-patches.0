Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3051991BE;
	Thu,  6 Jun 2024 14:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683653; cv=none; b=haB6fiuouxEd8dLKqyo1G3c0kS6aPQ4CXWQLQWe7EK9t1x2CxHvaX7d3g5xTGO7jJ7kRAmh1th9oCErpLgaj0zmzsDosH1hAGqjHhkj8O9h3yJr5mXIENBDBoCxXMzgIJN3CtN9mQgARsxnCd5MBPXHTm30jVsMJ9f/t6EQSYKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683653; c=relaxed/simple;
	bh=2SMoHp+eP9pPR2/IjSRJXWyvd4cHMr3HCERqA75Lr6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spA8Ttew4llIQbx7SRxFK8W4PE9ErNHcoEuMvi6VRIUOirNMMMoQ4TBOXn893zUp+76b2gl97xQsi6doHZyI3OrEbcJp78qppbTacXp9n27vRopMlCT5ydBVSXJbNyv/dhLVJ2n1agIRFODNc2i6WdhTy5PpkgoYJ3+Xd7mJ42s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKTkEgT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKTkEgT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B926BC2BD10;
	Thu,  6 Jun 2024 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683652;
	bh=2SMoHp+eP9pPR2/IjSRJXWyvd4cHMr3HCERqA75Lr6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKTkEgT9U5LN9wEaFhxf4UKN0HvtUbtnOIkRT0ZgEuEvdn8H+eLIQRGgWfJXr23+K
	 OfJfA4Onh5rTgLXpPDkznoVBP2gE1V/RqFm2znxUCy4fTVNpc28BXcn/4tf9YQ88Wx
	 fcohqw/tQtZuYz83EZi9D4JoGEtFmo8nij9Hakj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <chris.wulff@biamp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 488/744] usb: gadget: u_audio: Clear uac pointer when freed.
Date: Thu,  6 Jun 2024 16:02:40 +0200
Message-ID: <20240606131748.102793833@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



