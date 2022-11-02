Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE31633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E57FC433D6;
	Wed,  2 Nov 2022 03:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360216;
	bh=Okiqjy0eOyuBdTsXjr99V8bEzDsWqk4YajMM0bU+XrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOfF7OTErIQAZqFePuFTHhk1f2htDQZytvQxpqfe47hs2IO9VTREhwBGNycICOAix
	 uvDVRlmXjbZr1KSxRPNO5skLbFqw1F7m997uVn8FdlmDXHa3vqYSjS9SqyW615ed67
	 jbWONvYsboMA2Dsnt9DJaZKUWaXez4XiQ6p6ucL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/78] ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()
Date: Wed,  2 Nov 2022 03:34:36 +0100
Message-Id: <20221102022054.476599638@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
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
index 34d75d4fb93f..a276c4283c7b 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1965,6 +1965,7 @@ static int snd_ac97_dev_register(struct snd_device *device)
 		     snd_ac97_get_short_name(ac97));
 	if ((err = device_register(&ac97->dev)) < 0) {
 		ac97_err(ac97, "Can't register ac97 bus\n");
+		put_device(&ac97->dev);
 		ac97->dev.bus = NULL;
 		return err;
 	}
-- 
2.35.1



