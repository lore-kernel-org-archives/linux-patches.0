Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989A6171B9
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A193EC4339B;
	Mon, 15 May 2023 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173808;
	bh=3uXLQhFuehqv2m+UKoPyw6Whi0a16ZNBeXlzce5QyAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=go1smsqizFBhc4DU+NXLSOioxK65AUQOZW1yxFLB4GzYA4iq0LpGNIp5B5Eh/xafB
	 gvaqtwHS0fQFBj4HXMTH5mt7qwJPhEIroYSfVJJ4V1jZr7SlsLn0cgdDWDNOjXdUTo
	 TE9V9cK4dSNbmJfKkB7sansDCQKrcgEOg1rgKGFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/282] mailbox: zynqmp: Fix counts of child nodes
Date: Mon, 15 May 2023 18:29:52 +0200
Message-Id: <20230515161728.654539811@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tanmay Shah <tanmay.shah@amd.com>

[ Upstream commit f72f805e72882c361e2a612c64a6e549f3da7152 ]

If child mailbox node status is disabled it causes
crash in interrupt handler. Fix this by assigning
only available child node during driver probe.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230311012407.1292118-2-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 1abeff7656462..bb7bb17386475 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -634,7 +634,12 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 	struct zynqmp_ipi_mbox *mbox;
 	int num_mboxes, ret = -EINVAL;
 
-	num_mboxes = of_get_child_count(np);
+	num_mboxes = of_get_available_child_count(np);
+	if (num_mboxes == 0) {
+		dev_err(dev, "mailbox nodes not available\n");
+		return -EINVAL;
+	}
+
 	pdata = devm_kzalloc(dev, struct_size(pdata, ipi_mboxes, num_mboxes),
 			     GFP_KERNEL);
 	if (!pdata)
-- 
2.39.2



