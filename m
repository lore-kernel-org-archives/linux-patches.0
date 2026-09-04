Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36FB3F4DD2;
	Fri,  4 Sep 2026 06:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502398; cv=none; b=Y7MPBUIVi6+lINaHAQOG2zh5h358qvCWSlrxSwpCczuHE67roTW1p03dzi1l+yaDuVxFWiqqusEWTBS3UU0kWiD852M41zGJ2HI4njTBQcCJ7j82NKmdTE5Jgg7y09rjzOWbPlFMuWkXeX3iJpLJbiSErPg2NywA+nrBLut1cfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502398; c=relaxed/simple;
	bh=tHnBdfOfRtw9MYvbtKUds7fjcSagXsMHoOL3YKVWONc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Keoge5vcZ/5oE8Zh9eph1rT8sxURT/g3ZWm5bqKAzBZKWxYnbexofZg2X7SP+32oopYGZesWqEFrYdJDVggnqWw7g6xkrsUwQmeBBOwDbybSgj20Uji53h3HkMGGOZD0yQw3HIRqo/lahFBA9uWHHD3I33VoeA7eJoqeMquUFck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcIAj8fE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcIAj8fE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FDE1F00A3E;
	Fri,  4 Sep 2026 06:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502396;
	bh=2S56f4avMGI6ncXHZEpnwyb1BWXNfutMds7DlxGQGlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcIAj8fE0qedLx4gZF0hf9WZnn5pWoIVRsiydV4Z7N7xzyZSTn5MhBclir3VDK7He
	 2F3FFSWHHH2vtdKpuC7CBmZMb3bh5xAzeCiG9tPkA8UzMonNgVC6Ji2sHHPzlckVTX
	 JnVwVgjSkPykDWGF7kIfnAcgviVvlfsOlmm5pleA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6.12 194/403] mailbox: qcom-ipcc: fix duplicate channel allocation across holes
Date: Fri,  4 Sep 2026 06:59:57 +0200
Message-ID: <20260904045739.266374394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


