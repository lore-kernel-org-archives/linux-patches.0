Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40AF7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6C4C433C1;
	Wed,  2 Nov 2022 03:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358250;
	bh=/64A47Zois16J6kKGY2wZR1mJEK/7BKHL4FDGvGucDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXAGT+lrbd+DwfuoDYkLBVYBlzA7loeOUN2BArjnjGc6U4vuv2dz2wwhx4laM9ZHj
	 I12Mv30aTNfP5nrqu8tfT4gQ5meyJFU3HghBO/cl2ThMWVdLTN/0KubEofrsOjcq8L
	 xaUmJL7pZprDl8OyTE+lxm+ovb4WwW8CCBcHfhuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/132] ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()
Date: Wed,  2 Nov 2022 03:32:52 +0100
Message-Id: <20221102022101.336975803@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4881bda5ea05c8c240fc8afeaa928e2bc43f61fa ]

If device_register() fails in snd_ac97_dev_register(), it should
call put_device() to give up reference, or the name allocated in
dev_set_name() is leaked.

Fixes: 0ca06a00e206 ("[ALSA] AC97 bus interface for ad-hoc drivers")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221019093025.1179475-1-yangyingliang@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ac97/ac97_codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index cb60a07d39a8..ceead55f13ab 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -2009,6 +2009,7 @@ static int snd_ac97_dev_register(struct snd_device *device)
 	err = device_register(&ac97->dev);
 	if (err < 0) {
 		ac97_err(ac97, "Can't register ac97 bus\n");
+		put_device(&ac97->dev);
 		ac97->dev.bus = NULL;
 		return err;
 	}
-- 
2.35.1



