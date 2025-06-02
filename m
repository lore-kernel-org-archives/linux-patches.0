Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D082222CA;
	Mon,  2 Jun 2025 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875400; cv=none; b=D3lGTUHNg0W6gLFrrZ9pSYmtYQsnyrEBFxT0Wg/qyS4IXzwnn1sSzgzSHr++0yB7unZv8RVLtHAOzBmM8E16epcqI0poPcowXUxA4e7fuuaPSHw0GgJgpaVJD1ZCGB3ydvP2/FhvW44ee+fofjJ60yswDCKI8yTItYusL+mgLeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875400; c=relaxed/simple;
	bh=lOrVRUN5nXCnCknhC3ynTERNeAWgrfDBlW3MUEyRNM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9aJQfIRSDSvafplVOq6Hn5ZmKZoNixfkvbDfldzcH2SohmXnMEwPLx/F/ahAneUgdQqLDzSwEbDHE4+QsFZmP4Jq8+XN88tUatMPtC7bejUsfkS09wNSqWXVoa3/IhPlXXyyu4IwGPvmJ54S0pwb4atG5vXZLT55MRpUKMHzLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6AP7AVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6AP7AVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02726C4CEEE;
	Mon,  2 Jun 2025 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875396;
	bh=lOrVRUN5nXCnCknhC3ynTERNeAWgrfDBlW3MUEyRNM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6AP7AVEL/ujNUWwULb4waobsMI4L28Fo1gz8Yq6/fmQbTqVdrBx5Fd8GGhfcdI0J
	 FYG/bLUqwj7T4r+hyFmX6rhUEVKLgxw3P29u96gjdeK9LM3I6GCI6XeTMQ+DkhSMnS
	 wlDm9twLD4CX9q4VrRn28lQD93PuTuAYFRvS0Ev8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/270] mailbox: use error ret code of of_parse_phandle_with_args()
Date: Mon,  2 Jun 2025 15:46:46 +0200
Message-ID: <20250602134312.171959812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 24fdd5074b205cfb0ef4cd0751a2d03031455929 ]

In case of error, of_parse_phandle_with_args() returns -EINVAL when the
passed index is negative, or -ENOENT when the index is for an empty
phandle. The mailbox core overwrote the error return code with a less
precise -ENODEV. Use the error returned code from
of_parse_phandle_with_args().

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 4229b9b5da98f..6f54501dc7762 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -350,11 +350,12 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 
 	mutex_lock(&con_mutex);
 
-	if (of_parse_phandle_with_args(dev->of_node, "mboxes",
-				       "#mbox-cells", index, &spec)) {
+	ret = of_parse_phandle_with_args(dev->of_node, "mboxes", "#mbox-cells",
+					 index, &spec);
+	if (ret) {
 		dev_dbg(dev, "%s: can't parse \"mboxes\" property\n", __func__);
 		mutex_unlock(&con_mutex);
-		return ERR_PTR(-ENODEV);
+		return ERR_PTR(ret);
 	}
 
 	chan = ERR_PTR(-EPROBE_DEFER);
-- 
2.39.5



