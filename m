Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2F31C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0B7C433D6;
	Wed, 23 Nov 2022 09:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196671;
	bh=bt+U0+RQChoFilcbIYKL1pVrSvg8SmRx5bItGCzlLug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlmUAVoVnXXQJEzFfXIVXsWGyO9Sne4eVQ5oyNXdTjYxWtmfjbt4IxsE4A9kRY2HS
	 32nL6GHOKgDMyTzdRaADfFI9uP+XcLJXfUReHsry/qXw9uwYwloJLqQfcN25g5ctDU
	 aLvFKxKzDhnkQCRxr2lVXIPOMrsoANct39SzlhJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Dehaes <jos.dehaes@gmail.com>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 092/314] ASoC: tas2764: Fix set_tdm_slot in case of single slot
Date: Wed, 23 Nov 2022 09:48:57 +0100
Message-Id: <20221123084629.659838600@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit faac764ea1ea6898d93e46c403271fb105c0906e ]

There's a special branch in the set_tdm_slot op for the case of nslots
being 1, but:

 (1) That branch can never work (there's a check for tx_mask being
     non-zero, later there's another check for it *being* zero; one or
     the other always throws -EINVAL).

 (2) The intention of the branch seems to be what the general other
     branch reduces to in case of nslots being 1.

For those reasons remove the 'nslots being 1' special case.

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Suggested-by: Jos Dehaes <jos.dehaes@gmail.com>
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20221027095800.16094-2-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 39902f77a2e0..6c87c3cf5ef7 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -386,20 +386,13 @@ static int tas2764_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	if (tx_mask == 0 || rx_mask != 0)
 		return -EINVAL;
 
-	if (slots == 1) {
-		if (tx_mask != 1)
-			return -EINVAL;
-		left_slot = 0;
-		right_slot = 0;
+	left_slot = __ffs(tx_mask);
+	tx_mask &= ~(1 << left_slot);
+	if (tx_mask == 0) {
+		right_slot = left_slot;
 	} else {
-		left_slot = __ffs(tx_mask);
-		tx_mask &= ~(1 << left_slot);
-		if (tx_mask == 0) {
-			right_slot = left_slot;
-		} else {
-			right_slot = __ffs(tx_mask);
-			tx_mask &= ~(1 << right_slot);
-		}
+		right_slot = __ffs(tx_mask);
+		tx_mask &= ~(1 << right_slot);
 	}
 
 	if (tx_mask != 0 || left_slot >= slots || right_slot >= slots)
-- 
2.35.1



