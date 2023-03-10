Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F812846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737F3C4339B;
	Fri, 10 Mar 2023 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458882;
	bh=dihXK2KufuK8KCz5q2YarGWS68MTaw82lH/IEq0PSKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8j+hfi+2eXdgPCdXjmrDJIHbZfJXWF2cls/A7yJFmxacpz/qeaLJSxPOfyVMLgfw
	 AblSwYvbe+QWxzBNHzaXr4qCSMf055DjDwCGq9eMRlLTtX79Zj7ATqypJF/S8EeqOS
	 2YDxm4xdTz45TwN5lZMF/8zFEjqCIemlkZ8q1LY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/357] rpmsg: glink: Avoid infinite loop on intent for missing channel
Date: Fri, 10 Mar 2023 14:37:44 +0100
Message-Id: <20230310133742.454026633@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index b240830a0aab0..11ba44dc551e4 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -929,6 +929,7 @@ static void qcom_glink_handle_intent(struct qcom_glink *glink,
 	spin_unlock_irqrestore(&glink->idr_lock, flags);
 	if (!channel) {
 		dev_err(glink->dev, "intents for non-existing channel\n");
+		qcom_glink_rx_advance(glink, ALIGN(msglen, 8));
 		return;
 	}
 
-- 
2.39.2



