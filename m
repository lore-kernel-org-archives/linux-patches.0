Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6423D34A3A5;
	Fri,  4 Sep 2026 05:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501029; cv=none; b=kjMT0/1RIoHOYMTI7ytRHroALLADQ074ag3y4o7av536X/e4P6SWHJ7jW0AI92Rxh+oPNPYkCB9dCwwkq/kuCNaM/NZ3bAr8fFqvfxPBOzmzo9E1uGHcbcGZHbMparOSjXc/yLzSvhljJ38OrnrF9o5vXuf3hnpQ/AE7C/KE0rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501029; c=relaxed/simple;
	bh=ayK5UhSeclb2NNMgSUMWzEvZzAYFGdOPkBZA7rL0+8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOi8a8ErU5Io6MZPwMLakcNy+cozGAJ0X1eg5LqGlrjW+uVXW0lW88gsfjyXrJ+z0WD+IXMPO9FEUS8fUqcfN1vKnyOVfSuNnTprnPUvlxzf8qfoe54zb+hiMTG6LB9ASs5B9dNktR9M/BpI+mFzS8cHSvVVC+cEa2s+IGmU3TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7pRgGC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7pRgGC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00381F00A3D;
	Fri,  4 Sep 2026 05:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501028;
	bh=SYrcfyMWfkgWMYt9NfhIBdLadRaaMzSkYnufC+RdgaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7pRgGC1GY5658RK2Ume6sn/SEEz+ve1B9yuMwXdXIkFtoAIlbcYXAAdoD/JxHad2
	 d7ybOQKIRFAydGWuf3N3YIGL8qkpOWMuxGc4zg8XJbCIDtbf7zENWrS9hWIOO1YPPO
	 KfP35xzwqbyRpJZc62J1CaWJQi97ZNLMSxyy0hFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6.18 266/552] mailbox: qcom-ipcc: fix duplicate channel allocation across holes
Date: Fri,  4 Sep 2026 06:57:03 +0200
Message-ID: <20260904045755.966644010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>

commit 66c7bcad72430a02c860521031350b84b31ad9a8 upstream.

The IPCC of_xlate() both scans for a free mailbox channel and checks
for duplicate references to the same underlying IPCC channel. When a
channel has been shutdown it might have left a hole in the channel
list, which would terminate the search without considering duplicates
later in the list.

Continue the traversal of the channel list to detect and reject
duplicates, while keeping track of the first free channel.

Fixes: d6fbfdbc1274 ("mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/qcom-ipcc.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -167,7 +167,7 @@ static struct mbox_chan *qcom_ipcc_mbox_
 {
 	struct qcom_ipcc *ipcc = to_qcom_ipcc(mbox);
 	struct qcom_ipcc_chan_info *mchan;
-	struct mbox_chan *chan;
+	struct mbox_chan *chan, *free_chan = NULL;
 	struct device *dev;
 	int chan_id;
 
@@ -180,16 +180,21 @@ static struct mbox_chan *qcom_ipcc_mbox_
 		chan = &ipcc->chans[chan_id];
 		mchan = chan->con_priv;
 
-		if (!mchan)
-			break;
-		else if (mchan->client_id == ph->args[0] &&
-				mchan->signal_id == ph->args[1])
+		if (!mchan) {
+			/* Keep scanning past holes to reject duplicate channel requests. */
+			if (!free_chan)
+				free_chan = chan;
+		} else if (mchan->client_id == ph->args[0] &&
+				mchan->signal_id == ph->args[1]) {
 			return ERR_PTR(-EBUSY);
+		}
 	}
 
-	if (chan_id >= mbox->num_chans)
+	if (!free_chan)
 		return ERR_PTR(-EBUSY);
 
+	chan = free_chan;
+
 	mchan = devm_kzalloc(dev, sizeof(*mchan), GFP_KERNEL);
 	if (!mchan)
 		return ERR_PTR(-ENOMEM);


