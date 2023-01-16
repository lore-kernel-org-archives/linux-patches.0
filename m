Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E1946B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1E3C433EF;
	Mon, 16 Jan 2023 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886459;
	bh=CmzPdli+SvAFF2Rj6v1+X6LB1zChmmJNndJTCUB4iNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMWW9vF2MXF2B3+CnBLh2TU6Z2ORKdbBfDrDjEiXfYKbVvUo95P0NBT2+tLInu/lc
	 xTZF58anIbMAnJVXJIzRudPkUTBVACEksJv8sBkD3yStixsTnwVwZfGNMnUWsHE7fB
	 K007fp0hqM/fN9n4OYhidTEMtUU/BSzpjDPnz9mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 438/658] ASoC: rt5670: Remove unbalanced pm_runtime_put()
Date: Mon, 16 Jan 2023 16:48:46 +0100
Message-Id: <20230116154929.583921335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6c900dcc3f7331a67ed29739d74524e428d137fb ]

For some reason rt5670_i2c_probe() does a pm_runtime_put() at the end
of a successful probe. But it has never done a pm_runtime_get() leading
to the following error being logged into dmesg:

 rt5670 i2c-10EC5640:00: Runtime PM usage count underflow!

Fix this by removing the unnecessary pm_runtime_put().

Fixes: 64e89e5f5548 ("ASoC: rt5670: Add runtime PM support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221213123319.11285-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5670.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/rt5670.c b/sound/soc/codecs/rt5670.c
index f21181734170..fefdd8cbd8f5 100644
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -3185,8 +3185,6 @@ static int rt5670_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
-	pm_runtime_put(&i2c->dev);
-
 	return 0;
 err:
 	pm_runtime_disable(&i2c->dev);
-- 
2.35.1



