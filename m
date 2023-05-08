Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5F5168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D59C433D2;
	Mon,  8 May 2023 11:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544249;
	bh=lu3ggu9njnwH7Ijt2g4C9gEUy7XTQd6IRqs+E3CViQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NM4oJBzw/rsIcKtieU8GhCFzIOKGFYRKowol2TdMirRBoSbNYDyf8BuLMa2wiNkf
	 eZ031KE7k3J5arDy06PxZeWXwvUaVMFXd0aF4jFfW7gSg23m7VWQ4ajuqkdXoCKlhN
	 G1tB3cka2EXQX+eSL5uWJcxgf5OO2IWGWu4s2U8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 318/694] rpmsg: glink: Propagate TX failures in intentless mode as well
Date: Mon,  8 May 2023 11:42:33 +0200
Message-Id: <20230508094442.621114536@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 7a68f9fa97357a0f2073c9c31ed4101da4fce93e ]

As support for splitting transmission over several messages using
TX_DATA_CONT was introduced it does not immediately return the return
value of qcom_glink_tx().

The result is that in the intentless case (i.e. intent == NULL), the
code will continue to send all additional chunks. This is wasteful, and
it's possible that the send operation could incorrectly indicate
success, if the last chunk fits in the TX fifo.

Fix the condition.

Fixes: 8956927faed3 ("rpmsg: glink: Add TX_DATA_CONT command while sending")
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230418163018.785524-2-quic_bjorande@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 01d2805fe30f5..62634d020d139 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1356,8 +1356,9 @@ static int __qcom_glink_send(struct glink_channel *channel,
 	ret = qcom_glink_tx(glink, &req, sizeof(req), data, chunk_size, wait);
 
 	/* Mark intent available if we failed */
-	if (ret && intent) {
-		intent->in_use = false;
+	if (ret) {
+		if (intent)
+			intent->in_use = false;
 		return ret;
 	}
 
@@ -1378,8 +1379,9 @@ static int __qcom_glink_send(struct glink_channel *channel,
 				    chunk_size, wait);
 
 		/* Mark intent available if we failed */
-		if (ret && intent) {
-			intent->in_use = false;
+		if (ret) {
+			if (intent)
+				intent->in_use = false;
 			break;
 		}
 	}
-- 
2.39.2



