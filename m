Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2C92517AC;
	Mon, 22 Sep 2025 19:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570362; cv=none; b=V5cdKinbYAcw93+a9X5YN/f9R5f1WLCd9f6v0lloKjl5fAD6KFWnoHBAjxd9ls3c0E7DGwrwt3we7rHiDK4mwXMWUQkaLly4UTKMbP+hG1q1u99KQPtlzzBNPV7pQXYMZrWHAYufAzWJ4zzOUwtY1tdBOrGd2jcLijbrGBs4sfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570362; c=relaxed/simple;
	bh=QvbzhkXA7Y90/IF0Wol7tv+cl/JiZZtgmfkPDwTxk+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TI12L/kSFn/v0sRHQ9RaHlt973I6whqeLGIbsvwKLcR0IVidscBuESaB19r/KBtrAcOpgpClrwioxWf33vQAU18CVsQiwwE3xZyW+GkRRf91oOX5S+Nb5o9+xj1aPrQOaAJkM/hTQB5ZFXoetRaxP7CVv3KVmB9zwfRRHlRbn+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfzOGUC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfzOGUC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA87C4CEF0;
	Mon, 22 Sep 2025 19:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570362;
	bh=QvbzhkXA7Y90/IF0Wol7tv+cl/JiZZtgmfkPDwTxk+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfzOGUC8qMpVq/uPhveweJrXntKZytOOx14Da9n6CdXYJ2rMvXh52rO0oDfKovl/a
	 sPsHlpcpTg7fNvY1bPuYxpWoFXGDszzYu2QV1BNelxDxORgP+gSCPL64cnpRLgsFKl
	 P3Q9xataKgTEeX8MVpjUmzKfaicRJxElua2972vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 111/149] ASoC: codec: sma1307: Fix memory corruption in sma1307_setting_loaded()
Date: Mon, 22 Sep 2025 21:30:11 +0200
Message-ID: <20250922192415.673694733@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 78338108b5a856dc98223a335f147846a8a18c51 ]

The sma1307->set.header_size is how many integers are in the header
(there are 8 of them) but instead of allocating space of 8 integers
we allocate 8 bytes.  This leads to memory corruption when we copy data
it on the next line:

        memcpy(sma1307->set.header, data,
               sma1307->set.header_size * sizeof(int));

Also since we're immediately copying over the memory in ->set.header,
there is no need to zero it in the allocator.  Use devm_kmalloc_array()
to allocate the memory instead.

Fixes: 576c57e6b4c1 ("ASoC: sma1307: Add driver for Iron Device SMA1307")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aLGjvjpueVstekXP@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sma1307.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sma1307.c b/sound/soc/codecs/sma1307.c
index b3d401ada1760..2d993428f87e3 100644
--- a/sound/soc/codecs/sma1307.c
+++ b/sound/soc/codecs/sma1307.c
@@ -1737,9 +1737,10 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 	sma1307->set.checksum = data[sma1307->set.header_size - 2];
 	sma1307->set.num_mode = data[sma1307->set.header_size - 1];
 	num_mode = sma1307->set.num_mode;
-	sma1307->set.header = devm_kzalloc(sma1307->dev,
-					   sma1307->set.header_size,
-					   GFP_KERNEL);
+	sma1307->set.header = devm_kmalloc_array(sma1307->dev,
+						 sma1307->set.header_size,
+						 sizeof(int),
+						 GFP_KERNEL);
 	if (!sma1307->set.header) {
 		sma1307->set.status = false;
 		return;
-- 
2.51.0



