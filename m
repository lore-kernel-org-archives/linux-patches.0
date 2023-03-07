Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E99BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D24FC4339B;
	Tue,  7 Mar 2023 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210672;
	bh=JR5J6PlA1qykPmiHqWswLlG/WSrMdyaJnOCzvFt3h8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+yJzM1hxDv0PYDKmb9jeb3ijnLQBYTIGDxgGxxzr56m3SZRMEGQGnfxHd88hRWX6
	 IGEYrPKV98Se6q17axOiN+IxYVG62SxRg/qEv22tQQRHMDGGVgKk5XeVbKt9tMB42D
	 aoWqSaiA9mBLNsSIZJXVvyvBJsYGaIc7JOIyQdec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0616/1001] rpmsg: glink: Avoid infinite loop on intent for missing channel
Date: Tue,  7 Mar 2023 17:56:28 +0100
Message-Id: <20230307170048.271115582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 3e74ec2f39362bffbd42854acbb67c7f4cb808f9 ]

In the event that an intent advertisement arrives on an unknown channel
the fifo is not advanced, resulting in the same message being handled
over and over.

Fixes: dacbb35e930f ("rpmsg: glink: Receive and store the remote intent buffers")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230214234231.2069751-1-quic_bjorande@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 115c0a1eddb10..bb917746ad4bb 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -954,6 +954,7 @@ static void qcom_glink_handle_intent(struct qcom_glink *glink,
 	spin_unlock_irqrestore(&glink->idr_lock, flags);
 	if (!channel) {
 		dev_err(glink->dev, "intents for non-existing channel\n");
+		qcom_glink_rx_advance(glink, ALIGN(msglen, 8));
 		return;
 	}
 
-- 
2.39.2



