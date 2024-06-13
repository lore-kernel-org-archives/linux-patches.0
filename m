Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C30A14388E;
	Thu, 13 Jun 2024 11:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278876; cv=none; b=aB5RyousV5pwylzzj9h53RKc3ain1OLY6ipVR1HeLNkqqPj5odCkCddQ83lzbYj996ph6hD/dQcW38b05xQEqZrDqwmwrBu24Egoi9f2KCvFse4CNIo2fzzTT3n/NTrnCBnqLc90Cv4FzmVgpVA0Un/mMkMicV5CrJO5j2lciao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278876; c=relaxed/simple;
	bh=DcMWXBjhnO5/011n5xySqPTSxvESynmLui1G7CRy6Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws9W08g2QDMZ16GB2EgomD5hZtOEppg096qkmJtQPNgkBoyWhk7K45ER/QN/Em7N4VcRSW9CIg1j2luBG/jLCBX7gFP1O3TSVyvHyVT85o0Zi3xqFVUqFEqvP+xfpQx8Yz8jvU9f83K/4PoO3PDKrY6Pe+JKOW+2ZEhoKYhQ6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCjlofae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCjlofae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0E7C4AF1A;
	Thu, 13 Jun 2024 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278876;
	bh=DcMWXBjhnO5/011n5xySqPTSxvESynmLui1G7CRy6Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCjlofaeb1T3ByoY6oxk+WQLGGxr0IJ3HD5VKc6JWEVC6QWgaGCVp50qQTQWXAGcU
	 bWFS4CeA/u4Rky2plv1uiUgai82UAQPlnziID5eUs2JOcVymFbcIj/oq342wt33amj
	 f93lfOt3fDkguYTY8sUGmaXmSGgsF+5nGkndvPFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <chris.wulff@biamp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/213] usb: gadget: u_audio: Clear uac pointer when freed.
Date: Thu, 13 Jun 2024 13:32:27 +0200
Message-ID: <20240613113231.827681818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3136a239e7828..f7c610b7e3fd3 100644
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



