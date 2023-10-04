Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBF91D54A
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2AAC433C8;
	Wed,  4 Oct 2023 18:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443113;
	bh=WTLYbaxWFfCrpXJnDsGPeHjBxdpdrnxtBB5naFqI9yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxVscakCQTc1Zo6XIU8vhzT7pdZLflN3KZdcqmHSodlfI+HNTufj0P+aYJgudErCA
	 vRMP5eSHTWIwJy6L5WzfbrfhmbCvg5nqv04pHbPdbeCuGcnQWhdAq5la3iiMNl9hyL
	 Ym7SZeQjtw0imVtrLS7cZi/Wnw0651oKBBOQtKRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/259] ASoC: rt5640: Fix IRQ not being free-ed for HDA jack detect mode
Date: Wed,  4 Oct 2023 19:53:34 +0200
Message-ID: <20231004175219.330655448@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8c8bf3df6b7c0ed1c4dd373b23eb0ce13a63f452 ]

Set "rt5640->irq_requested = true" after a successful request_irq()
in rt5640_enable_hda_jack_detect(), so that rt5640_disable_jack_detect()
properly frees the IRQ.

This fixes the IRQ not being freed on rmmod / driver unbind.

Fixes: 2b9c8d2b3c89 ("ASoC: rt5640: Add the HDA header support")
Cc: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230912113245.320159-6-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 0f8e6dd214b0d..37ea4d854cb58 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2624,6 +2624,7 @@ static void rt5640_enable_hda_jack_detect(
 		rt5640->irq = -ENXIO;
 		return;
 	}
+	rt5640->irq_requested = true;
 
 	/* sync initial jack state */
 	queue_delayed_work(system_long_wq, &rt5640->jack_work, 0);
-- 
2.40.1



