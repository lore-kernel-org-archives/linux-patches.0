Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F243FC1B
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044C7C4339E;
	Mon, 15 May 2023 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172901;
	bh=Dxv0V0djtdYeLj6z8vYogg+s4bQ8ZSK+opspWFTIT50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBjOdAbwc2e/GY1Oxckw7QCoBdGea+3UBpz9c7VQdRKojseZfbyYypTy7xpImO3vD
	 0NeD6jF5brIfZrH+n7u8SFqYNiUBSUpCq8ZOvGNkC7qfaDgebE7JxpoRMKHYecflie
	 hGiANMHNEUU7YmpN+Mu4aFCYB6xy/1/cq8Ix8Rk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 304/381] mailbox: zynq: Switch to flexible array to simplify code
Date: Mon, 15 May 2023 18:29:15 +0200
Message-Id: <20230515161750.560894259@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 043f85ce81cb1714e14d31c322c5646513dde3fb ]

Using flexible array is more straight forward. It
  - saves 1 pointer in the 'zynqmp_ipi_pdata' structure
  - saves an indirection when using this array
  - saves some LoC and avoids some always spurious pointer arithmetic

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Stable-dep-of: f72f805e7288 ("mailbox: zynqmp: Fix counts of child nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 05e36229622e3..136a84ad871cc 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -110,7 +110,7 @@ struct zynqmp_ipi_pdata {
 	unsigned int method;
 	u32 local_id;
 	int num_mboxes;
-	struct zynqmp_ipi_mbox *ipi_mboxes;
+	struct zynqmp_ipi_mbox ipi_mboxes[];
 };
 
 static struct device_driver zynqmp_ipi_mbox_driver = {
@@ -635,7 +635,7 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 	int num_mboxes, ret = -EINVAL;
 
 	num_mboxes = of_get_child_count(np);
-	pdata = devm_kzalloc(dev, sizeof(*pdata) + (num_mboxes * sizeof(*mbox)),
+	pdata = devm_kzalloc(dev, struct_size(pdata, ipi_mboxes, num_mboxes),
 			     GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
@@ -649,8 +649,6 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 	}
 
 	pdata->num_mboxes = num_mboxes;
-	pdata->ipi_mboxes = (struct zynqmp_ipi_mbox *)
-			    ((char *)pdata + sizeof(*pdata));
 
 	mbox = pdata->ipi_mboxes;
 	for_each_available_child_of_node(np, nc) {
-- 
2.39.2



