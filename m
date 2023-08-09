Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAAF171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59055C433C9;
	Wed,  9 Aug 2023 11:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578874;
	bh=r0g9GxzUGSTdqOkbuz2kuMqv0eDJcNVSyXX9Lf+wHlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETkTsPjEdNmFeVP7ZumXjpPt/XFxMO2G8w88IO52NtPE4F/ELMfLTJYF4ymPuVBw+
	 2EtgKjxQqlf/t4TULFxx+oTRvfC4QwlA+ynhL1rmIAwInN4ZNY1aGfJCWG69fistRQ
	 rfCrf+Zal9yvGKRulUcAjhe2qvYRTUyw7+Hk5lJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.15 59/92] firmware: arm_scmi: Drop OF node reference in the transport channel setup
Date: Wed,  9 Aug 2023 12:41:35 +0200
Message-ID: <20230809103635.634009715@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit da042eb4f061a0b54aedadcaa15391490c48e1ad upstream.

The OF node reference obtained from of_parse_phandle() should be dropped
if node is not compatible with arm,scmi-shmem.

Fixes: 507cd4d2c5eb ("firmware: arm_scmi: Add compatibility checks for shmem node")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20230719061652.8850-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/mailbox.c |    4 +++-
 drivers/firmware/arm_scmi/smc.c     |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -106,8 +106,10 @@ static int mailbox_chan_setup(struct scm
 		return -ENOMEM;
 
 	shmem = of_parse_phandle(cdev->of_node, "shmem", idx);
-	if (!of_device_is_compatible(shmem, "arm,scmi-shmem"))
+	if (!of_device_is_compatible(shmem, "arm,scmi-shmem")) {
+		of_node_put(shmem);
 		return -ENXIO;
+	}
 
 	ret = of_address_to_resource(shmem, 0, &res);
 	of_node_put(shmem);
--- a/drivers/firmware/arm_scmi/smc.c
+++ b/drivers/firmware/arm_scmi/smc.c
@@ -78,8 +78,10 @@ static int smc_chan_setup(struct scmi_ch
 		return -ENOMEM;
 
 	np = of_parse_phandle(cdev->of_node, "shmem", 0);
-	if (!of_device_is_compatible(np, "arm,scmi-shmem"))
+	if (!of_device_is_compatible(np, "arm,scmi-shmem")) {
+		of_node_put(np);
 		return -ENXIO;
+	}
 
 	ret = of_address_to_resource(np, 0, &res);
 	of_node_put(np);


