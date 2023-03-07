Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE17BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F657C433EF;
	Tue,  7 Mar 2023 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213331;
	bh=/CMlKbgu7ZHcfwgq2kZJq9NL/oI31B5f5/ceCswkJc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+Nwu/r5I7pagTdXau3laKf3mC7+i1wXFoiYUdECuWTwt+M6G69OtXh6u7XMrO2zR
	 T7HBTHwD/dfCUmnTzL5DD9G0A7WCB0dTDnwR1dSOJkKbweRkI6HO1pdUO678mAHMOp
	 U99bhVoJ/VBRT2JIMg1FjpCdtI7BUKWzi57j+/zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 443/885] driver core: location: Free struct acpi_pld_info *pld before return false
Date: Tue,  7 Mar 2023 17:56:17 +0100
Message-Id: <20230307170021.684474008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 0d150f967e8410e1e6712484543eec709356a65d ]

struct acpi_pld_info *pld should be freed before the return of allocation
failure, to prevent memory leak, add the ACPI_FREE() to fix it.

Fixes: bc443c31def5 ("driver core: location: Check for allocations failure")
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/1669102648-11517-1-git-send-email-guohanjun@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/physical_location.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/physical_location.c b/drivers/base/physical_location.c
index 87af641cfe1a3..951819e71b4ad 100644
--- a/drivers/base/physical_location.c
+++ b/drivers/base/physical_location.c
@@ -24,8 +24,11 @@ bool dev_add_physical_location(struct device *dev)
 
 	dev->physical_location =
 		kzalloc(sizeof(*dev->physical_location), GFP_KERNEL);
-	if (!dev->physical_location)
+	if (!dev->physical_location) {
+		ACPI_FREE(pld);
 		return false;
+	}
+
 	dev->physical_location->panel = pld->panel;
 	dev->physical_location->vertical_position = pld->vertical_position;
 	dev->physical_location->horizontal_position = pld->horizontal_position;
-- 
2.39.2



