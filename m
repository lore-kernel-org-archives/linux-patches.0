Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277977E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DD9C433D7;
	Wed,  2 Nov 2022 02:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357860;
	bh=lt4ODK7q561exU9L7glSBJMdspMOqRXaoq3qZoLUqps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaKKHFiINcArtgX9uk7URDJ+b8oaxR0PBraNhy/76t8tICCVAikA+vfYL3mGaw8yI
	 zXO2K/3Ogjy8yc71L5A3D3Bjpv5b//hoZmtP/U5OVFsqwTE8QDP1FKR7VxQ2H2/4X9
	 GmxcVrWnKJG0InjARmRZqosydQxjnqzBUHxD9wyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 213/240] ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
Date: Wed,  2 Nov 2022 03:33:08 +0100
Message-Id: <20221102022116.217036888@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

[ Upstream commit 4a4c8482e370d697738a78dcd7bf2780832cb712 ]

dev_set_name() in soundbus_add_one() allocates memory for name, it need be
freed when of_device_register() fails, call soundbus_dev_put() to give up
the reference that hold in device_initialize(), so that it can be freed in
kobject_cleanup() when the refcount hit to 0. And other resources are also
freed in i2sbus_release_dev(), so it can return 0 directly.

Fixes: f3d9478b2ce4 ("[ALSA] snd-aoa: add snd-aoa")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221027013438.991920-1-yangyingliang@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/aoa/soundbus/i2sbus/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index faf6b03131ee..f6841daf9e3b 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -302,6 +302,10 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 
 	if (soundbus_add_one(&dev->sound)) {
 		printk(KERN_DEBUG "i2sbus: device registration error!\n");
+		if (dev->sound.ofdev.dev.kobj.state_initialized) {
+			soundbus_dev_put(&dev->sound);
+			return 0;
+		}
 		goto err;
 	}
 
-- 
2.35.1



