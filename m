Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316218654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CE4C433C8;
	Wed, 20 Sep 2023 11:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210485;
	bh=Rt++2RrF+t++AKnvZZmF8F7OnMny93GfIOIkohOUkXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRcc5moclGK5pTz+CcjuUMbR3gKqRPIK1RXXrZUXv8Ti706bPit6oCAnE9n3+CSTn
	 xEPBAz96vjl0yVK/4+rgNcbUQADIZP+4ZFw2kyEDQGbNTxUbopgZuONVam49eo1tr4
	 8qa47vDq9RGYnJRd9tJU0VyoB+W6pKIqFz4rMJ44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 093/211] ASoC: SOF: amd: clear panic mask status when panic occurs
Date: Wed, 20 Sep 2023 13:28:57 +0200
Message-ID: <20230920112848.696784581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 3d02e1c439b4140215b624d423aa3c7554b17a5a ]

Due to scratch memory persistence, Once the DSP panic is reported, need to
clear the panic mask after handling DSP panic. Otherwise, It results in DSP
panic on next reboot.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20230823073340.2829821-6-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp-ipc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/sof/amd/acp-ipc.c b/sound/soc/sof/amd/acp-ipc.c
index 8a0fc635a997c..d07dc78074cc3 100644
--- a/sound/soc/sof/amd/acp-ipc.c
+++ b/sound/soc/sof/amd/acp-ipc.c
@@ -168,6 +168,8 @@ irqreturn_t acp_sof_ipc_irq_thread(int irq, void *context)
 		if ((status & SOF_IPC_PANIC_MAGIC_MASK) == SOF_IPC_PANIC_MAGIC) {
 			snd_sof_dsp_panic(sdev, sdev->dsp_box.offset + sizeof(status),
 					  true);
+			status = 0;
+			acp_mailbox_write(sdev, sdev->dsp_box.offset, &status, sizeof(status));
 			return IRQ_HANDLED;
 		}
 		snd_sof_ipc_msgs_rx(sdev);
@@ -197,6 +199,8 @@ irqreturn_t acp_sof_ipc_irq_thread(int irq, void *context)
 	acp_mailbox_read(sdev, sdev->debug_box.offset, &status, sizeof(u32));
 	if ((status & SOF_IPC_PANIC_MAGIC_MASK) == SOF_IPC_PANIC_MAGIC) {
 		snd_sof_dsp_panic(sdev, sdev->dsp_oops_offset, true);
+		status = 0;
+		acp_mailbox_write(sdev, sdev->debug_box.offset, &status, sizeof(status));
 		return IRQ_HANDLED;
 	}
 
-- 
2.40.1



