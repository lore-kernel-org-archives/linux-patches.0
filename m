Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2300174EE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527FFC433C8;
	Wed,  9 Aug 2023 11:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579090;
	bh=B9HGwsEyyzUr9d+CCGYWgb3jVWqorvTJ9M/HE7Nbe9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzyyPhwZQThPlwFPsXovEXDUeYtPU/7hj+l6lL4hHvYwxYG+mDIG24pFSsCCMS6DL
	 pTHXvzs4T6SeHXAxFu4n+2As1eLwkEtmUHhFUR0yxyAQBQyMsb4me8lII7jCGJUz45
	 DTyD/ZlgRAk6UcZb/4Am9jAekwP2epjCVfxnFn2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 071/204] mailbox: ti-msgmgr: Fill non-message tx data fields with 0x0
Date: Wed,  9 Aug 2023 12:40:09 +0200
Message-ID: <20230809103645.019047028@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 1b712f18c461bd75f018033a15cf381e712806b5 ]

Sec proxy/message manager data buffer is 60 bytes with the last of the
registers indicating transmission completion. This however poses a bit
of a challenge.

The backing memory for sec_proxy / message manager is regular memory,
and all sec proxy does is to trigger a burst of all 60 bytes of data
over to the target thread backing ring accelerator. It doesn't do a
memory scrub when it moves data out in the burst. When we transmit
multiple messages, remnants of previous message is also transmitted
which results in some random data being set in TISCI fields of
messages that have been expanded forward.

The entire concept of backward compatibility hinges on the fact that
the unused message fields remain 0x0 allowing for 0x0 value to be
specially considered when backward compatibility of message extension
is done.

So, instead of just writing the completion register, we continue
to fill the message buffer up with 0x0 (note: for partial message
involving completion, we already do this).

This allows us to scale and introduce ABI changes back also work with
other boot stages that may have left data in the internal memory.

While at this, be consistent and explicit with the data_reg pointer
increment.

Fixes: aace66b170ce ("mailbox: Introduce TI message manager driver")
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/ti-msgmgr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/ti-msgmgr.c b/drivers/mailbox/ti-msgmgr.c
index 54b9e4cb4cfa0..0c4d3640fcbf4 100644
--- a/drivers/mailbox/ti-msgmgr.c
+++ b/drivers/mailbox/ti-msgmgr.c
@@ -310,14 +310,20 @@ static int ti_msgmgr_send_data(struct mbox_chan *chan, void *data)
 		/* Ensure all unused data is 0 */
 		data_trail &= 0xFFFFFFFF >> (8 * (sizeof(u32) - trail_bytes));
 		writel(data_trail, data_reg);
-		data_reg++;
+		data_reg += sizeof(u32);
 	}
+
 	/*
 	 * 'data_reg' indicates next register to write. If we did not already
 	 * write on tx complete reg(last reg), we must do so for transmit
+	 * In addition, we also need to make sure all intermediate data
+	 * registers(if any required), are reset to 0 for TISCI backward
+	 * compatibility to be maintained.
 	 */
-	if (data_reg <= qinst->queue_buff_end)
-		writel(0, qinst->queue_buff_end);
+	while (data_reg <= qinst->queue_buff_end) {
+		writel(0, data_reg);
+		data_reg += sizeof(u32);
+	}
 
 	return 0;
 }
-- 
2.39.2



