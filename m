Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1B31C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A039C433EF;
	Mon, 20 Mar 2023 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325734;
	bh=Rdp0lPLgZfuXrqNugPBx0+te+ciYiE3AY757693/yxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlQ/SvNRhSTwijgqyls5KkzjhPd+J0W1KD4yv9oYOgf2TN54+Zny8MDHnsYq+oA6q
	 WdIoNr75ZzAlFU0zU5Zr6dDvh+Cjz4L/7T4Z6c7B1NhHglkYRcfiaWBPTwGepdFjIq
	 oUvqVFwjI20BrQyEEeY5gvBm79ClC103DmVux/u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.1 134/198] interconnect: qcom: rpm: fix probe child-node error handling
Date: Mon, 20 Mar 2023 15:54:32 +0100
Message-Id: <20230320145513.161517290@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit bc463201f60803fa6bf2741d59441031cd0910e4 upstream.

Make sure to clean up and release resources properly also in case probe
fails when populating child devices.

Fixes: e39bf2972c6e ("interconnect: icc-rpm: Support child NoC device probe")
Cc: stable@vger.kernel.org      # 5.17
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-7-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/icc-rpm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -544,8 +544,11 @@ regmap_done:
 	platform_set_drvdata(pdev, qp);
 
 	/* Populate child NoC devices if any */
-	if (of_get_child_count(dev->of_node) > 0)
-		return of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (of_get_child_count(dev->of_node) > 0) {
+		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+		if (ret)
+			goto err;
+	}
 
 	return 0;
 err:


