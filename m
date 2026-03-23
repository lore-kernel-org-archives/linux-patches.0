Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1C92737E3;
	Mon, 23 Mar 2026 14:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277650; cv=none; b=eVWuSLJUFuwW/mV8jM0lAghHUwuZkupwHn7RrEj+/YBP5c2gpCfY2fh7YqgZrkWtZH1F4jTIhMp9QhYl3mRl/pV4Ihq3pS1nPmfKLH9w7bfHOaDbiQc9Sp8OAQ/ZSsXIq0a+xj5J3qiM7FRFqsJwGTvRWGkUltimVmqhJrveSas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277650; c=relaxed/simple;
	bh=mzB/1/5OQUEyckQMG6URysq1k2Cv/9VQKb5CFO5gnjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG/VaW0jVoHvprPz+G+VIT1tIpxJ353mV6s+hKupQsvdBX2AezRbThO2sJCGcQD/UKNwDp39170Jy7mdM4r06tTfgBgG69zcwuWm+i6iqA0wkUUBvqCH+zqECHL80ZC5UdMqLGvHdqJ6KdcLsDaI5aWg4disuBEP9IbkBztswu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfc65aFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfc65aFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECF8C2BC9E;
	Mon, 23 Mar 2026 14:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277650;
	bh=mzB/1/5OQUEyckQMG6URysq1k2Cv/9VQKb5CFO5gnjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfc65aFpJG6672NJA8sJMTe55B/N+pz8pMS3sri6qEuaclucRwZi53GIRvGQhUK4y
	 4uLgdmSWBCZQpmJvE+fXlhxBGkbztRMCD6qP8/+CC0ms73k52Let9oQE6mwt0gqbSk
	 mUHfUqb7wkO9E/od1CTyf8vWb12jq0nYvTf1yNcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/567] mailbox: dont protect of_parse_phandle_with_args with con_mutex
Date: Mon, 23 Mar 2026 14:39:40 +0100
Message-ID: <20260323134535.300805189@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 8c71c61fc613657d785a3377b4b34484bd978374 ]

There are no concurrency problems if multiple consumers parse the
phandle, don't gratuiously protect the parsing with the mutex used
for the controllers list.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: fcd7f96c7836 ("mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 92c2fb618c8e1..87de408fb068c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -413,16 +413,15 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 		return ERR_PTR(-ENODEV);
 	}
 
-	mutex_lock(&con_mutex);
-
 	ret = of_parse_phandle_with_args(dev->of_node, "mboxes", "#mbox-cells",
 					 index, &spec);
 	if (ret) {
 		dev_dbg(dev, "%s: can't parse \"mboxes\" property\n", __func__);
-		mutex_unlock(&con_mutex);
 		return ERR_PTR(ret);
 	}
 
+	mutex_lock(&con_mutex);
+
 	chan = ERR_PTR(-EPROBE_DEFER);
 	list_for_each_entry(mbox, &mbox_cons, node)
 		if (mbox->dev->of_node == spec.np) {
-- 
2.51.0



