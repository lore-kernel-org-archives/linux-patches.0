Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685CB31618C;
	Sat, 12 Sep 2026 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221438; cv=none; b=BAhYRXDQASCNmnbkpMrm9Ik3FEYg9B0xKiR5hKYbxxnkz/P0yg0OV9IBkXAF9nAdHAXMyDEThUvWvCovvvZ26Pa9K1m6WDqEaqfAf+nru/rg97D2NChYHEzgs+0Hb50ZXj5JZ1yln9rzNEm2pRiZHgJW32B1+3A6W8k9eEsRpdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221438; c=relaxed/simple;
	bh=FF5Kd7z4e0RM/esE9hVjwki09MFjsfj7x2B4Epte5uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGsKLH9R8q6WJLLpHi4lnKnYL2RZS7Z24anwc6wquW1sRurgtXZEe61oXF1ouyM2VVpQRn6P4Urj4bSDhu+C9YjuN60UAfPZ4BjrcrgYWjICEHB41OGmrBZdPSZaBVzE/BwVWDlLStu977ntbFvb1RaFRKq0PImjNKBptogQ+g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qQceSZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qQceSZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6E81F000FF;
	Sat, 12 Sep 2026 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221436;
	bh=7rw/aSC3G+o+ZPzZ7HoJi7PNGYPGzUbwLfwX56mGbn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qQceSZKmLxjiNSGj5cGyQqi5kLhJ1S4MxQr0vFH4Cu2gpGmeTdCVOwMH6RTCq5Uw
	 TceHP00q4zAtGg8YGag4e1DOVsxrgSSUzogNtprzNG9vGEztXMByAeGrWLVw/+9OuJ
	 X9YTm+jjPzxYZGOFEJVGt4y2ZDEbEE7PFmFSiD1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 0381/1424] powerpc/pseries: Handle and log pseries-wdt registration failures
Date: Sat, 12 Sep 2026 08:46:53 +0200
Message-ID: <20260912065615.824641985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


