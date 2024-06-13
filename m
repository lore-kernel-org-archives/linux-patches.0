Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2021459FE;
	Thu, 13 Jun 2024 12:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281192; cv=none; b=Dw7Bv+vGGFzg1EyWtDnxupvao58eCgVykhstlUI27xc7VHWiJoiPIteVm+GeYN4L7z3j18/lhF2AikUmC36D6+mf2moOvSz0eCswLlxXhhVWdLUYgUqiMOtqYJgGVUrjie5d25ICYwbP6xo/bcS2pvwqOxgiL7XWxvHX5/4aOEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281192; c=relaxed/simple;
	bh=Yq3UZYQQXklBdMoBdkaeTK4oK7JScBdY8HwrgGrbF+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQrOv7aBn1Fpi/1BSc2gadySxIAFhY5Gt3s9Glf77S83YDmT4H/V3Fk6vrPOXWpV+pBv3GXrj53wWbhryF5WEi9vmcsKQfjzA4DjHKYzAmXbqU/fb4qc4bZkjibQ8Gdvq6xl/Dx4DV+6B+yXLJpmmvCazzVWPPBPfaO17RIBPuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mD/SHaTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mD/SHaTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107F4C2BBFC;
	Thu, 13 Jun 2024 12:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281192;
	bh=Yq3UZYQQXklBdMoBdkaeTK4oK7JScBdY8HwrgGrbF+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mD/SHaTQT9U+oWduu84wn3BR2w6XGmgxqHvGECzu3hijBgvdy9zU7wgOMJ7Af4Wjt
	 08D6rFptOS1lROZBMhI6igeoowTvu/jF32EvfbdsInTewMbCx00y41rZm+6fckW8Dq
	 ZvFz0f9jglRvdvwplBY4GkxwZUVCuZMjbzYKpnsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <chris.wulff@biamp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/317] usb: gadget: u_audio: Clear uac pointer when freed.
Date: Thu, 13 Jun 2024 13:33:10 +0200
Message-ID: <20240613113254.214282291@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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
index 6c8b8f5b7e0f5..a387ff2c8b730 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -611,6 +611,8 @@ void g_audio_cleanup(struct g_audio *g_audio)
 		return;
 
 	uac = g_audio->uac;
+	g_audio->uac = NULL;
+
 	card = uac->card;
 	if (card)
 		snd_card_free_when_closed(card);
-- 
2.43.0



