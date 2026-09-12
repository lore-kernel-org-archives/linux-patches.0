Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B03742CB1C;
	Sat, 12 Sep 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227151; cv=none; b=e/NCkMP0Hwv5xEbjra0IDZsZAHmBN5Cbmy5TvrX/HcNQoHiwO7QTOPszf6ij3x4j95mdwvncMTOi4gqAiYmuJn3dvjEIdw1Ua1bTEJshiFN17vGiiW281MDXqGAw5kxcnPsA/yl4GPeD+vidWl1l8iKsEPNXArZUN9L5hvz1Iyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227151; c=relaxed/simple;
	bh=VCrd4BLhnJ/4szb03SKsBhg4gGySNlE+/xRU0A/yijY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixrCGiXGz3FNgwVh4lrQavKtcKydK+lPWm1in5PD6W8/gCm913Hqmulr01a097cXVofccSyDXvVP8hjsOGhHfd+ftXZJFO0S1Ajw15e/FTl6KZQb+D5z+sa18ZAFFXuoNfMiZV9sfmpeCbL8hMiTvLXBmkbyqLMmynPvRzktEJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/UIJ/85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/UIJ/85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3751F000FF;
	Sat, 12 Sep 2026 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227150;
	bh=yJ/4yTnGfJDxDH4MP62vhlPLRefZssGE+cF0/21gIYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/UIJ/85QK2m8y+KJFWxI+2NlFJq0I58hGf9LU3fLVxee9HdzRQIzKAtnJv3f+t7e
	 hvmxLUjZeXCPnlIR7L/AUfr3LPLpWFhHOm0EkRcobYS4YBFwj7hkTJC+oo8lU6vIaX
	 46/D5vXzElGSi+hYZADVjNOR0qqfHJWWPZQZyih4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6.1 0122/1191] mailbox: qcom-ipcc: fix duplicate channel allocation across holes
Date: Sat, 12 Sep 2026 08:47:30 +0200
Message-ID: <20260912065550.930659675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -165,7 +165,7 @@ static struct mbox_chan *qcom_ipcc_mbox_
 {
 	struct qcom_ipcc *ipcc = to_qcom_ipcc(mbox);
 	struct qcom_ipcc_chan_info *mchan;
-	struct mbox_chan *chan;
+	struct mbox_chan *chan, *free_chan = NULL;
 	struct device *dev;
 	int chan_id;
 
@@ -178,16 +178,21 @@ static struct mbox_chan *qcom_ipcc_mbox_
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


