Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B492D23A4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000E6C4339B;
	Mon,  8 May 2023 10:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541970;
	bh=96dNKuJP4PiWompaW8BIUDBKHiI+2cxwQWqWEjNDkgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njEiObuIYScwQbUJvWiM/sF8Gzxxbj0p6Hny0/VMim/nOr6cY13yPDNDpzAQETyP9
	 D61X/xSNFEtzSvO/fhK0tDuBNtCBd7BIX8IA50F3bfgpBj45chIOISGJP++X3oX0T/
	 8O+mrfXXFdoS4CFxy/EqIXNNjjflx627Yyhla9u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 277/663] rpmsg: glink: Propagate TX failures in intentless mode as well
Date: Mon,  8 May 2023 11:41:43 +0200
Message-Id: <20230508094437.230983585@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index 35df1b0a515bf..67e7664efb0dc 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1348,8 +1348,9 @@ static int __qcom_glink_send(struct glink_channel *channel,
 	ret = qcom_glink_tx(glink, &req, sizeof(req), data, chunk_size, wait);
 
 	/* Mark intent available if we failed */
-	if (ret && intent) {
-		intent->in_use = false;
+	if (ret) {
+		if (intent)
+			intent->in_use = false;
 		return ret;
 	}
 
@@ -1370,8 +1371,9 @@ static int __qcom_glink_send(struct glink_channel *channel,
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



