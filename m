Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ACE6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD35C433EF;
	Mon,  3 Apr 2023 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533030;
	bh=QHiqBaDd7TKi3Fgb4EqKzNbkcwRu76OmI/eB7btnxU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoZVOnGcy+J77E6lyVZDLSKqGkXkaO+PgvXJNSIMpY5kM/afW+8E7uQLs2NYvvCmr
	 O9vQQZ8bkRvva6F92bda5eAUy7GOjV6zfswqBD4thX8zVNke+Y7C1dCFuf96eGYVkh
	 zKVmwTJWVodHvV8Nioh3l2iMinEUr/lPcBbS2HXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Malainey <cujomalainey@chromium.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Curtis Malainey <curtis@malainey.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 028/187] ASoC: SOF: ipc3: Check for upper size limit for the received message
Date: Mon,  3 Apr 2023 16:07:53 +0200
Message-Id: <20230403140416.932927084@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 989a3e4479177d0f4afab8be1960731bc0ffbbd0 ]

The sof_ipc3_rx_msg() checks for minimum size of a new rx message but it is
missing the check for upper limit.
Corrupted or compromised firmware might be able to take advantage of this
to cause out of bounds reads outside of the message area.

Reported-by: Curtis Malainey <cujomalainey@chromium.org>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Curtis Malainey <curtis@malainey.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307114917.5124-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc3.c b/sound/soc/sof/ipc3.c
index 1fef4dcc09368..fde8af5a1f485 100644
--- a/sound/soc/sof/ipc3.c
+++ b/sound/soc/sof/ipc3.c
@@ -970,8 +970,9 @@ static void sof_ipc3_rx_msg(struct snd_sof_dev *sdev)
 		return;
 	}
 
-	if (hdr.size < sizeof(hdr)) {
-		dev_err(sdev->dev, "The received message size is invalid\n");
+	if (hdr.size < sizeof(hdr) || hdr.size > SOF_IPC_MSG_MAX_SIZE) {
+		dev_err(sdev->dev, "The received message size is invalid: %u\n",
+			hdr.size);
 		return;
 	}
 
-- 
2.39.2



