Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8A31428F0;
	Thu, 13 Jun 2024 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280008; cv=none; b=B4vLT7yGQyrdfMKKTB5g6pYV3FR6vLYk/03pHl8XlrUfA6Yx5tHAiYJquODNZywlOF7Qhxv/jt/bx4XyivXbQwbZV6l9pxq15qHFHBWSRYUmHAOdOh9cUyZURIxxDTvLeb5IfacHWeqOlEGb+ORzUxgJM0tVozwJDLJr6Ay5KWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280008; c=relaxed/simple;
	bh=sJGSwo/1On3tMuuR+Rg4kdWuwI7nhqsH2UvO/pZio+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WytPV7iBArhPQ1PUU05AkiinN6lLOpMmANumBlg2EoWpNam1RHrfQAOuKmiiBeSRerUsRUwnaEjQu++ETj/WDxSpVesPoyk3QQK8gExsQlVDFxAEC1dCEl67c4zm+YQE2NvPhzTC8umjCd51iL6Lx/7HieS2fZK+ykHdTl3EjzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFXffDRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFXffDRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F23C2BBFC;
	Thu, 13 Jun 2024 12:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280008;
	bh=sJGSwo/1On3tMuuR+Rg4kdWuwI7nhqsH2UvO/pZio+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFXffDRV5hDCp01l8cb0ilGUHyK+gBO1siZCsmQcLYPT45PmI+tWztbGjjjYghLPU
	 LgcVpWrmY4/AnxK0i6NpHJOtRJMYHK2Cd1aJGy0CjtIJQDSGZ3xh60MoiQUJV4CROp
	 +I1V1ckgoJwOP6L+IB5KCHlS0mPPbCkUsXqKkgwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <chris.wulff@biamp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/202] usb: gadget: u_audio: Clear uac pointer when freed.
Date: Thu, 13 Jun 2024 13:33:29 +0200
Message-ID: <20240613113232.045353658@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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
index 53b30de16a896..994316d51a0e1 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -624,6 +624,8 @@ void g_audio_cleanup(struct g_audio *g_audio)
 		return;
 
 	uac = g_audio->uac;
+	g_audio->uac = NULL;
+
 	card = uac->card;
 	if (card)
 		snd_card_free_when_closed(card);
-- 
2.43.0



