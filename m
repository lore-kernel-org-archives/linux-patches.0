Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7551C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC45CC433EF;
	Wed, 28 Dec 2022 16:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246088;
	bh=o/RLTwYcn3FUB5QhdZ+EThc5jKECceOLlq/kNdEogCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykz29P6RzGnfKSzu3mvklpPeQI0krmuV6jF9Ox3cgYQAOO/5CNh0f04W7MtFd5gxl
	 RM3K0/kA+bjs+ZvZ0Zi+AG1/cXCuVTlXGEpZCtFAUqVW0UWj3aPp8Pzsmrwk0qy1o8
	 oFOG2XV95As+3hDIF2HU1ax95XUXLmAFn6WhrVTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1010/1073] ASoC: rt5670: Remove unbalanced pm_runtime_put()
Date: Wed, 28 Dec 2022 15:43:18 +0100
Message-Id: <20221228144355.596781059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 60dbfa2a54f1..c75045e371b2 100644
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -3311,8 +3311,6 @@ static int rt5670_i2c_probe(struct i2c_client *i2c)
 	if (ret < 0)
 		goto err;
 
-	pm_runtime_put(&i2c->dev);
-
 	return 0;
 err:
 	pm_runtime_disable(&i2c->dev);
-- 
2.35.1



