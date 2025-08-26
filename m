Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A275AD4B;
	Tue, 26 Aug 2025 13:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214975; cv=none; b=DocjcLcM1TpfnJzRkclZVCh7V8eX/AUrqrsz7idPeQCS9Z6GZvphZ/wWPbj+gKSl9dceIu7c1W8WyY557yT6DNLG4I/OooKoR3JiPPrHOF/f3GSednigXhqGENg4vZXy2KHZ7nTMsGnnlAkWA/V6HhOQYAyMUEeMEcTgRlAbcLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214975; c=relaxed/simple;
	bh=1SBam0dpFLcuiMe11MJXNRUtGwTen16dJpqtNbjJTH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cv1Wv9xTJlbCSZ2b2ok0OWdgq2ConABRcfwkwK4hKjm/jLThm5AE9ECZg3DWVBdBwCdsg3J74uMYo38fYTqj4wzVuklDDbFiVHygBvpPEeRrrIP0cClUqshrvyOn/0HU++02uW4m9z/m0P16WE6bwnGRAiN0J43TibOcst0BKX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyOHoWLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyOHoWLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0004C4CEF1;
	Tue, 26 Aug 2025 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214975;
	bh=1SBam0dpFLcuiMe11MJXNRUtGwTen16dJpqtNbjJTH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyOHoWLTWNlMVMDp45DbSLdzfOC50ZwaTYORG/bKchUo5BeZlqTGeuYLI8FpWqQet
	 E1HPiA0KboiV68MpQRnUYMt7axIHBgzddMjvYrUyNXsMiE1+luhPj5b+8gQwk9pxM8
	 Vd/JCbd/WoaQPKvnj+2juicAW6vBSMF+rVYaQddA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Govindarajulu, Hariganesh" <hariganesh.govindarajulu@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 340/482] ACPI: pfr_update: Fix the driver update version check
Date: Tue, 26 Aug 2025 13:09:53 +0200
Message-ID: <20250826110939.226980513@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

commit 8151320c747efb22d30b035af989fed0d502176e upstream.

The security-version-number check should be used rather
than the runtime version check for driver updates.

Otherwise, the firmware update would fail when the update binary had
a lower runtime version number than the current one.

Fixes: 0db89fa243e5 ("ACPI: Introduce Platform Firmware Runtime Update device driver")
Cc: 5.17+ <stable@vger.kernel.org> # 5.17+
Reported-by: "Govindarajulu, Hariganesh" <hariganesh.govindarajulu@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Link: https://patch.msgid.link/20250722143233.3970607-1-yu.c.chen@intel.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/pfr_update.c  |    2 +-
 include/uapi/linux/pfrut.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -310,7 +310,7 @@ static bool applicable_image(const void
 	if (type == PFRU_CODE_INJECT_TYPE)
 		return payload_hdr->rt_ver >= cap->code_rt_version;
 
-	return payload_hdr->rt_ver >= cap->drv_rt_version;
+	return payload_hdr->svn_ver >= cap->drv_svn;
 }
 
 static void print_update_debug_info(struct pfru_updated_result *result,
--- a/include/uapi/linux/pfrut.h
+++ b/include/uapi/linux/pfrut.h
@@ -89,6 +89,7 @@ struct pfru_payload_hdr {
 	__u32 hw_ver;
 	__u32 rt_ver;
 	__u8 platform_id[16];
+	__u32 svn_ver;
 };
 
 enum pfru_dsm_status {


