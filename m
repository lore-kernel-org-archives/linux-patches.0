Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A738DC72;
	Sat, 12 Sep 2026 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228098; cv=none; b=h56YrMknV/bhmfte1jWDhvWMmX3qZXNq3ot3I/MiSw/xkgsT0m+w/hOAOCr/EroDZsCmrm1lKUmFlQZEJA539N8DyYIpFN76Es61PPrCCf3AJ+qNE1NpPmhdKnJuXOi4JtwEJzTe/jLJDCS8ukNPGNOXAxhQU4cl9uA9qnTcXb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228098; c=relaxed/simple;
	bh=tiOoMAjxFL0/ZEEOx5ymD69CvbM4e+SZXof9PKYbfn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuOu5qRavbO7wy7ylozJu+8TVMScZGuKVndg46iFi6hv4X7pQnB1X4/xH+r1/x4eEbuqqi5zuUUHayZhFhskQQMiRB8Vnj1rwdr73wxSiF4YzhqjUKCbdjL8WDlcjHNvc3FObq9b8bZnSjQ+7Lm0s59UuNgVi+0pTwGfP6848iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+sguTfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+sguTfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F111F000FF;
	Sat, 12 Sep 2026 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228097;
	bh=sFrSU9fjyVhGYf5tgFQk+P9r1nR3zKH84qAfXiMvTHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+sguTfJcAEPI29mPn2NO66aOXmHeEe7LsZSiq4MdescEgAiT66swlRoIuD4q12Fc
	 6bQh88bblvg3+d1xB6AdVToWBFENrTYs5G//RuuoDKypduzVmqv0rIq3MfkIFWOyJJ
	 ESvERLi+YkigEFhtfjo2Ar9KLG1HeOR5KB8wM2OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 0315/1191] powerpc/pseries: Handle and log pseries-wdt registration failures
Date: Sat, 12 Sep 2026 08:50:43 +0200
Message-ID: <20260912065555.305539679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -192,8 +192,18 @@ static void __init fwnmi_init(void)
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


