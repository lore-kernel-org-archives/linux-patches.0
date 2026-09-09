Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0875540A7;
	Wed,  9 Sep 2026 13:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962117; cv=none; b=n3doaGR+v3KH+Uh+MyoRUqAQRKOzlSHvs6QOh1tHTunvvrlhVA7C4k/ZtGoPpWNOeAtI3KUkO5JG7+mLG/zmZwyT755lfBEDr+NzbYIVpvdjC03APfgCBIDOXlfLlQSqIrYP7szMKUz5VxDu7R/KSDYINkSFgTFGXWItMZ6/TzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962117; c=relaxed/simple;
	bh=COPYzXG11yLTwiTd00aOTo298eyYkTTUHmbR7pq7CG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXc/N8VU0onzavc0gc6XnXuA9eHX+GSVPNUSTYPKKtQ+0RGgmO/yzRzz/u5hKuKn7pBx5TXMQU4Us99ejtOfzq2S07FxZhsPqFozyrUqj1KWPCFFHkTZhOEveKNo9IxKlgsR1JkDhLqC1OxTn8v/C2/n1AgdIhqOcNRynxdOWcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cx7Imn0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cx7Imn0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E301F00A3A;
	Wed,  9 Sep 2026 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962115;
	bh=6Yn2QD78r4JCo7ax7oDFhrEkVHHV4bhdjNjwzRnr8l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cx7Imn0xV/cxAV04VNjZ+YsxbGdm9GYK+MwbnmA1lhhNh56GsaLPiwrWHJIe6IekZ
	 kvTH7gcXC32r9ZY3gD5M5n9FvslL8fW+wPRgecWL7kjQq4zy5LBd1x9Pq/5gayQqsf
	 ZV5unGVXi9LNamp61i8WiIehKslFE4cHqbNAGhI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.2 180/556] powerpc/pseries: Handle and log pseries-wdt registration failures
Date: Wed,  9 Sep 2026 15:37:40 +0200
Message-ID: <20260909134236.744082950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

commit e65b526affa621b50646cafdf6b06505af07032e upstream.

The pseries watchdog initialization registers the pseries-wdt platform
device using platform_device_register_simple(), but currently ignores
its return value.

Check the returned pointer for errors, log a descriptive error message
when registration fails, and propagate the failure code to the caller.
This avoids silently ignoring platform device registration failures.

Cc: stable@vger.kernel.org
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260727053416.276317-3-sourabhjain@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/setup.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -191,8 +191,18 @@ static void __init fwnmi_init(void)
  */
 static __init int pseries_wdt_init(void)
 {
-	if (firmware_has_feature(FW_FEATURE_WATCHDOG))
-		platform_device_register_simple("pseries-wdt", 0, NULL, 0);
+	struct platform_device *pdev;
+
+	if (!firmware_has_feature(FW_FEATURE_WATCHDOG))
+		return 0;
+
+	pdev = platform_device_register_simple("pseries-wdt", 0, NULL, 0);
+
+	if (IS_ERR(pdev)) {
+		pr_err("Failed to register pseries-wdt platform device\n");
+		return PTR_ERR(pdev);
+	}
+
 	return 0;
 }
 machine_subsys_initcall(pseries, pseries_wdt_init);


