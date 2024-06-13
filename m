Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A735A17FD;
	Thu, 13 Jun 2024 12:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282357; cv=none; b=JVDzIbvwLxEIl15uxd+FxRxhWuHWDVgKko7DMJmnm4Rg+3olpsX4Z5Yj8Z9Y2QpwkTv/frByc4jlqk/PA7KhvzQwoEqLKt2ThtlZu3Fwr5x5PPkGH4wc9IkbfzF3BShfK40oLmO4BSsftMWJ7EE5eFO2aNMA3kqOZ2xlSwSShl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282357; c=relaxed/simple;
	bh=fJWHUQoPL34O5J3XBVftLRUa+7kgkv9+RFECOOgXYx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqZ45vaOt893Rw2Kc+mNa3W8HtRVyNY+reuG7BHOlLN+pJEfaeR1vnRLKjB6gjywQujt4uEQMmVMLum+JKCmVj/eOsDQbgMfrP9gxL9G6JRiLHRC1XJVh5+zWu/yQjDX5DkeL2jwLzlJ6YtDBlZ/Eh1pa5WkpH05HVMzJpjgytw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChCwvfDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChCwvfDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC3DC2BBFC;
	Thu, 13 Jun 2024 12:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282357;
	bh=fJWHUQoPL34O5J3XBVftLRUa+7kgkv9+RFECOOgXYx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChCwvfDnqeQc1YXnSGtUOw/qT/X8R+wyD4Ysvzm15V3XA0nB2+cYDeG+WCHbszpmd
	 cMSYHcaOmq+tt8j1uh3jgiI91u/NBkt27gGb11CYBQlrM175osvh+OwSyXAA8HSG2t
	 +r36oi53Xy5v7/lysVPTfiuRNsx/7SOW0Ji+rwtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <chris.wulff@biamp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/402] usb: gadget: u_audio: Clear uac pointer when freed.
Date: Thu, 13 Jun 2024 13:32:56 +0200
Message-ID: <20240613113310.690231574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 200eb788a74b3..5e34a7ff1b63d 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -1172,6 +1172,8 @@ void g_audio_cleanup(struct g_audio *g_audio)
 		return;
 
 	uac = g_audio->uac;
+	g_audio->uac = NULL;
+
 	card = uac->card;
 	if (card)
 		snd_card_free_when_closed(card);
-- 
2.43.0



