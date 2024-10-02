Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34DE1D0B8A;
	Wed,  2 Oct 2024 13:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877329; cv=none; b=QRX/4IwfeH5vCPlD+Hnkm84wXihCXYqqT8VVPSO0+ovm4hu9gjpdL/6T9QSQIrimIUT5GambzrGu/OFT3tDNGA6/fhHHugor43uWKLXpOcxup1zg2atmxz0jKZPvhmKXfcSI/eHWnYuq9GYR7zuNgOKnXZRlvCG1TAgZNLXUSpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877329; c=relaxed/simple;
	bh=/zXMkF6+ywu7APOMuxg49zYH+5eIZaxBk3ipeCMfpO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bn4DoGACC2crXvWdzgxAKWF0QtNmDEPSe068TUL1VdVoImNbHAuDtatqFr7LoIvSmQpajU/seSyrVhh45SBPKJoSzecSlNwE/lRquYt3mV3XbzZLv+zauOpPS1RiaZ++aitSE6kyIomZ+57DgWjg9lzlX907bFQX2t/85nIL90k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+Z7p4y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+Z7p4y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040BCC4CECE;
	Wed,  2 Oct 2024 13:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877329;
	bh=/zXMkF6+ywu7APOMuxg49zYH+5eIZaxBk3ipeCMfpO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+Z7p4y7FFkEdiKVQMEk1+0lDObJtnEVNQ5NZMUVHQhJ2siiavN7+31lU8S/QnJT3
	 Xd515glOz5+cxVDw7v4IkvHucF3Z/LqA+AMHQKUE4CKz2lCLvPiLiqY7LLXRKwK/Lo
	 ltxEpNS0yvVtTfsEukmrUBMAEksZ1n6q/ip0MNXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 045/634] ACPICA: Implement ACPI_WARNING_ONCE and ACPI_ERROR_ONCE
Date: Wed,  2 Oct 2024 14:52:25 +0200
Message-ID: <20241002125812.881758569@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 632b746b108e3c62e0795072d00ed597371c738a ]

ACPICA commit 2ad4e6e7c4118f4cdfcad321c930b836cec77406

In some cases it is not practical nor useful to nag user about some
firmware errors that they cannot fix. Add a macro that will print a
warning or error only once to be used in these cases.

Link: https://github.com/acpica/acpica/commit/2ad4e6e7
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c82c507126c9 ("ACPICA: executer/exsystem: Don't nag user about every Stall() violating the spec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/acoutput.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/acpi/acoutput.h b/include/acpi/acoutput.h
index b1571dd96310a..5e0346142f983 100644
--- a/include/acpi/acoutput.h
+++ b/include/acpi/acoutput.h
@@ -193,6 +193,7 @@
  */
 #ifndef ACPI_NO_ERROR_MESSAGES
 #define AE_INFO                         _acpi_module_name, __LINE__
+#define ACPI_ONCE(_fn, _plist)                  { static char _done; if (!_done) { _done = 1; _fn _plist; } }
 
 /*
  * Error reporting. Callers module and line number are inserted by AE_INFO,
@@ -201,8 +202,10 @@
  */
 #define ACPI_INFO(plist)                acpi_info plist
 #define ACPI_WARNING(plist)             acpi_warning plist
+#define ACPI_WARNING_ONCE(plist)        ACPI_ONCE(acpi_warning, plist)
 #define ACPI_EXCEPTION(plist)           acpi_exception plist
 #define ACPI_ERROR(plist)               acpi_error plist
+#define ACPI_ERROR_ONCE(plist)          ACPI_ONCE(acpi_error, plist)
 #define ACPI_BIOS_WARNING(plist)        acpi_bios_warning plist
 #define ACPI_BIOS_EXCEPTION(plist)      acpi_bios_exception plist
 #define ACPI_BIOS_ERROR(plist)          acpi_bios_error plist
@@ -214,8 +217,10 @@
 
 #define ACPI_INFO(plist)
 #define ACPI_WARNING(plist)
+#define ACPI_WARNING_ONCE(plist)
 #define ACPI_EXCEPTION(plist)
 #define ACPI_ERROR(plist)
+#define ACPI_ERROR_ONCE(plist)
 #define ACPI_BIOS_WARNING(plist)
 #define ACPI_BIOS_EXCEPTION(plist)
 #define ACPI_BIOS_ERROR(plist)
-- 
2.43.0



