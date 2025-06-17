Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD022ED149;
	Tue, 17 Jun 2025 16:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177106; cv=none; b=YpD8NJUKf9I1k14V/YlA+wdQzeIQmdfLul4QlZzahlp2a+gBGSJt461jHWuC9Kj4gV1Qceroy9OzqUhtbAHiXbO15Ml9/CxTV0lzHWIDbXDJLZdj0WJlA1eejwzgFxqUh5izqS5T42ClsAMAF9qFWbmvI/OBPbAbbkc92o9e6VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177106; c=relaxed/simple;
	bh=FoIjAmIACGwv37wMLn35XpUbPWFEIUyxCTP8S8uw8TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZSOdszhm+gRiXzxhHcDwOzvSUb3dtJTpDHYIdOTrSFH/wd4kj1OBuBcOUqN+y0HEvCsQkVrsln7YrjPgElcRXD78m2qfz+9sQ9zhbrL9ZDsrIInNIn2tZ1TrIXYIXU6B0FE8zMrz+XgNbgNjD4owea4+yXG17LEM8cU9E/XB4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BV60iA0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BV60iA0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1567CC4CEE3;
	Tue, 17 Jun 2025 16:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177106;
	bh=FoIjAmIACGwv37wMLn35XpUbPWFEIUyxCTP8S8uw8TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BV60iA0IgFrCX1tJMJgtOFVYVS6iTFPp6EZoPxENpv3OPGNsTh72NFK+t89elRrEx
	 xvIYUD8ag1FlfA6f5V4mak5g0Z7vtDPSe2rvRuctsKquX+9GagE2KDfq5toszo/w9t
	 nQ3Zg2x6xMFHV9fk9I7lz1KHvG77x/zAC9gybjKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 257/780] of: unittest: Unlock on error in unittest_data_add()
Date: Tue, 17 Jun 2025 17:19:25 +0200
Message-ID: <20250617152501.923602911@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 493e6cb63a21e9f009dc4c209fd311f2bb777656 ]

The of_overlay_mutex_unlock() was accidentally deleted if "of_root" is
NULL.  Change this to a goto unlock.

Fixes: d1eabd218ede ("of: unittest: treat missing of_root as error instead of fixing up")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/aBHZ1DvXiBcZkWmk@stanley.mountain
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 64d301893af7b..eeb370e0f5077 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -2029,15 +2029,16 @@ static int __init unittest_data_add(void)
 	rc = of_resolve_phandles(unittest_data_node);
 	if (rc) {
 		pr_err("%s: Failed to resolve phandles (rc=%i)\n", __func__, rc);
-		of_overlay_mutex_unlock();
-		return -EINVAL;
+		rc = -EINVAL;
+		goto unlock;
 	}
 
 	/* attach the sub-tree to live tree */
 	if (!of_root) {
 		pr_warn("%s: no live tree to attach sub-tree\n", __func__);
 		kfree(unittest_data);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto unlock;
 	}
 
 	EXPECT_BEGIN(KERN_INFO,
@@ -2056,9 +2057,10 @@ static int __init unittest_data_add(void)
 	EXPECT_END(KERN_INFO,
 		   "Duplicate name in testcase-data, renamed to \"duplicate-name#1\"");
 
+unlock:
 	of_overlay_mutex_unlock();
 
-	return 0;
+	return rc;
 }
 
 #ifdef CONFIG_OF_OVERLAY
-- 
2.39.5



