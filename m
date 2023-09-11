Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FA311706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63A5C433C7;
	Mon, 11 Sep 2023 14:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444118;
	bh=5SUH6y0eDDjkuhx/VfUQP3+TaYYcAULT6lu7rGTWtxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTmdfqLZQi68OYblcfnlOcCu/m8GVHQqsQDZ+tMgSgf9b3TpM8uGcFwQ5Ee4qqW+L
	 HgtXt4ZnXJf7C/Dd4hpD6ESdgtCTXAcO8pBxPj88DxhTXbry//nmxgTYqMSS73eurk
	 0f1wbgzzmcqNLXzsCK7lUx09xiqxmQcP68MmkTw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 609/737] rpmsg: glink: Add check for kstrdup
Date: Mon, 11 Sep 2023 15:47:48 +0200
Message-ID: <20230911134707.544630368@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit b5c9ee8296a3760760c7b5d2e305f91412adc795 ]

Add check for the return value of kstrdup() and return the error
if it fails in order to avoid NULL pointer dereference.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20230619030631.12361-1-jiasheng@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 1beb40a1d3df2..e4015db99899d 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -221,6 +221,10 @@ static struct glink_channel *qcom_glink_alloc_channel(struct qcom_glink *glink,
 
 	channel->glink = glink;
 	channel->name = kstrdup(name, GFP_KERNEL);
+	if (!channel->name) {
+		kfree(channel);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	init_completion(&channel->open_req);
 	init_completion(&channel->open_ack);
-- 
2.40.1



