Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E852E54A7E7;
	Wed,  9 Sep 2026 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963718; cv=none; b=HJabYCTca1Dle4hmfaF9fWAZ1btxq2cyaeSFBOwfO4ejRBBoQF+x8NuNh1zTajQ3u5sG6J7/sQumNW8cCDlECAiOWrdND4G+C6vDkhfKEEnAhlS8RWVLMTs5kRcgOHocJrdwkTXpb5B/AZnuPOtRWyA7O3EBzObmHpB6QCq/6/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963718; c=relaxed/simple;
	bh=JcdcHcxAoYiwbcHdf/FVQH9NkCLWoHxNuCYsjCbGPJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4bRNNYGHyo1jKjI+cklxfWqv3in2y3ggBM3U3upChyMwh5ws/jhqMhGp71HNly/fIvYgG+N1z9B+64sfY9nTV3rEslMbn6e3h96Ff1839GzWgsHqsHRgOGmN0vhcLcKvo4Tx2Abg7hU3iJChAHDmnYyVt98nI4oAlk8Zqx5kAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSgT3Am+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSgT3Am+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B481F00A3A;
	Wed,  9 Sep 2026 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963716;
	bh=IXbso3LOncvcyAo5X1ZvvftAZ0mPYZgrNIg1yvPMlL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSgT3Am+qmQii1sfvv4PSINotglCO/uTY3HWfgHh0A/lh69kLoi8s8Jzbd95zUQ3W
	 JvOOGkl9Me/FZVr9khcdR00zpODzKTmEkkJJ6NSyzQ1Cy5bqJK/8eUkT1hasHsj3lO
	 SwY3IfveopnRG4TzR6EvoUCP0uRI2bOxz6CguAcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 124/583] powerpc/pseries: Handle and log pseries-wdt registration failures
Date: Wed,  9 Sep 2026 15:36:49 +0200
Message-ID: <20260909134242.435290921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -193,8 +193,18 @@ static void __init fwnmi_init(void)
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


