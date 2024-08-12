Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180DE183CD9;
	Mon, 12 Aug 2024 16:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479048; cv=none; b=KhEkHqx+0wNbjlwoH0L2wzpL4bQdVQjY5Mf7NvmZ1E3X0lUUk9JMt/j10zHtEjKe2BwzCmEP1Ia0RmzMphZf/OG8HoDu2IXGvV0P5o671FmDJnjuu5z5nvuwhQOn0qNBnTRgdiVfkQQq7FDJrvvOtyZ3AE4V9kg14+4rTFUYb2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479048; c=relaxed/simple;
	bh=8dN1fRLfesoJphi5uDBCrmhqi7gqzhq4pp9pZp1mIs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3CbvsSJZEYO8BKO6JwjP6n+l1ON0DNpWc+PS7pMiWrCdjut15CU1jdnzQDLZOgJazTFaPJF+M8sC1QCTnSvAfI52hEtejp89IKG0MGmR2IUNCYPL1ikIW4V+vkvoLi61a6Er2XQFTw85xEws72lrCFE8M3wj31BhagbhYKOObM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDgxzlp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDgxzlp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880C2C32782;
	Mon, 12 Aug 2024 16:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479047;
	bh=8dN1fRLfesoJphi5uDBCrmhqi7gqzhq4pp9pZp1mIs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDgxzlp/jrAW9pd+bzKaUsY9mWju1EhCBTz5uAeAdg/F1doebjnTLl2LI5qP00KXx
	 mrrG0DsuucfMFWIFuWoAjbbdiTF6w5nbSSAsQd7855rhu5qlLizc3IaQ+1aRrTWy/H
	 GNzoPpQ4rP64uoSGsySf5C9bKOYmQ9j9BxuyB0w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 116/150] power: supply: axp288_charger: Round constant_charge_voltage writes down
Date: Mon, 12 Aug 2024 18:03:17 +0200
Message-ID: <20240812160129.637965934@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 81af7f2342d162e24ac820c10e68684d9f927663 upstream.

Round constant_charge_voltage writes down to the first supported lower
value, rather then rounding them up to the first supported higher value.

This fixes e.g. writing 4250000 resulting in a value of 4350000 which
might be dangerous, instead writing 4250000 will now result in a safe
4200000 value.

Fixes: 843735b788a4 ("power: axp288_charger: axp288 charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240717200333.56669-2-hdegoede@redhat.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/axp288_charger.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -178,18 +178,18 @@ static inline int axp288_charger_set_cv(
 	u8 reg_val;
 	int ret;
 
-	if (cv <= CV_4100MV) {
-		reg_val = CHRG_CCCV_CV_4100MV;
-		cv = CV_4100MV;
-	} else if (cv <= CV_4150MV) {
-		reg_val = CHRG_CCCV_CV_4150MV;
-		cv = CV_4150MV;
-	} else if (cv <= CV_4200MV) {
+	if (cv >= CV_4350MV) {
+		reg_val = CHRG_CCCV_CV_4350MV;
+		cv = CV_4350MV;
+	} else if (cv >= CV_4200MV) {
 		reg_val = CHRG_CCCV_CV_4200MV;
 		cv = CV_4200MV;
+	} else if (cv >= CV_4150MV) {
+		reg_val = CHRG_CCCV_CV_4150MV;
+		cv = CV_4150MV;
 	} else {
-		reg_val = CHRG_CCCV_CV_4350MV;
-		cv = CV_4350MV;
+		reg_val = CHRG_CCCV_CV_4100MV;
+		cv = CV_4100MV;
 	}
 
 	reg_val = reg_val << CHRG_CCCV_CV_BIT_POS;


