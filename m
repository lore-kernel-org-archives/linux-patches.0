Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055AC2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5A7C4339B;
	Tue, 18 Apr 2023 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822161;
	bh=jaQaabwiGAugIc2jTfWH15Ai29yX7+57k6YWU76NwQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhGmVK+uftztBd6E+JmM7Jy9Mx30nGQiHKT1S7YblpBEFIBpa+gCQBoIeCJHLvYJt
	 q6r/C6WvccuF/x0ryNk2uP5aQgUkL0IBooMk0FKP+Mr3jkK5IM23T+nF1ZHdNwzSU1
	 2WXupmIsBwQ2ORAAgYe+JRr19oK/z29LVEs6wXaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 046/139] dmaengine: apple-admac: Fix current_tx not getting freed
Date: Tue, 18 Apr 2023 14:21:51 +0200
Message-Id: <20230418120315.402175893@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
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

[ Upstream commit d9503be5a100c553731c0e8a82c7b4201e8a970c ]

In terminate_all we should queue up all submitted descriptors to be
freed. We do that for the content of the 'issued' and 'submitted' lists,
but the 'current_tx' descriptor falls through the cracks as it's
removed from the 'issued' list once it gets assigned to be the current
descriptor. Explicitly queue up freeing of the 'current_tx' descriptor
to address a memory leak that is otherwise present.

Fixes: b127315d9a78 ("dmaengine: apple-admac: Add Apple ADMAC driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20230224152222.26732-2-povik+lin@cutebit.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/apple-admac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/apple-admac.c b/drivers/dma/apple-admac.c
index b9132b495d181..4cf8da77bdd91 100644
--- a/drivers/dma/apple-admac.c
+++ b/drivers/dma/apple-admac.c
@@ -512,7 +512,10 @@ static int admac_terminate_all(struct dma_chan *chan)
 	admac_stop_chan(adchan);
 	admac_reset_rings(adchan);
 
-	adchan->current_tx = NULL;
+	if (adchan->current_tx) {
+		list_add_tail(&adchan->current_tx->node, &adchan->to_free);
+		adchan->current_tx = NULL;
+	}
 	/*
 	 * Descriptors can only be freed after the tasklet
 	 * has been killed (in admac_synchronize).
-- 
2.39.2



