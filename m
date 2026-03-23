Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B7223B612;
	Mon, 23 Mar 2026 14:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277659; cv=none; b=ltt3EM/pleOIC4WJ62fxszfa5prIj9c7VL++NVwsU27/0NBqkw3eSmsIsn0XncQC/Zq8x1GUempO1hxxNj6eX0FVGz53KpXHH1AaFV/FFOY47pL7v5/XHxBYudFmxcdlkPLMko+Smz8VMY+QejGWG4+G+DjKIdlpRakfMSd92Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277659; c=relaxed/simple;
	bh=0/McgpR0lKK1+XVYMDceAAvpvYdZ+F4v+ifImx3nHq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1KjWlcoF6KGCH8RKtNR1b1r4oHWiJ0zMfPPiwN1FaH2kzmCRA2n3cSd+K4oc234kmu5o2npk/aWwDVh9wmVcfJYPygqkJvjam2FqY8j4G+PcWMV9vjAVrwTKr5R8MnrKfdifeVG8v1FgsM7Px7K2aTQkvjO/R8AGQg+56jx4x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpzawO+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpzawO+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7C6C4CEF7;
	Mon, 23 Mar 2026 14:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277659;
	bh=0/McgpR0lKK1+XVYMDceAAvpvYdZ+F4v+ifImx3nHq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpzawO+SHcVPOY0tk97DY71zNDapFpYHRzuw1cHsSYJKakhUTR443kEcJSQ2H6ADP
	 L79hMyLN7Pz75gESlGglC1mGCVNh1St+zWvI5zsw6raxEVZ4KoCuk+7qHJ6kjz+zj+
	 ev2jTA7ZGUap0kHEYGzXSlmyfbDoajhKPYs5h53I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/567] mailbox: Use dev_err when there is error
Date: Mon, 23 Mar 2026 14:39:43 +0100
Message-ID: <20260323134535.379290591@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 8da4988b6e645f3eaa590ea16f433583364fd09c ]

Use dev_err to show the error log instead of using dev_dbg.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: fcd7f96c7836 ("mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 693975a87e19e..4c27de9514e55 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -322,7 +322,7 @@ static int __mbox_bind_client(struct mbox_chan *chan, struct mbox_client *cl)
 	int ret;
 
 	if (chan->cl || !try_module_get(chan->mbox->dev->driver->owner)) {
-		dev_dbg(dev, "%s: mailbox not free\n", __func__);
+		dev_err(dev, "%s: mailbox not free\n", __func__);
 		return -EBUSY;
 	}
 
@@ -413,7 +413,7 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 	ret = of_parse_phandle_with_args(dev->of_node, "mboxes", "#mbox-cells",
 					 index, &spec);
 	if (ret) {
-		dev_dbg(dev, "%s: can't parse \"mboxes\" property\n", __func__);
+		dev_err(dev, "%s: can't parse \"mboxes\" property\n", __func__);
 		return ERR_PTR(ret);
 	}
 
-- 
2.51.0



