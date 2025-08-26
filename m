Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2C828FD;
	Tue, 26 Aug 2025 13:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213641; cv=none; b=AGqPcuYDEQytUjOV7Oz3D983U+k/XCG7mXOawtPa4+ztyru0cUu0lLCRslXgVQGmnHjj1eiRZDQ2cHmthcfXPldE+OqwnOFrwDIUE2iBboUvocSEln3FOWmToLJnD+9LKyFjqMlGuozdOP1E6nKsfuc7MghniphN0eMBN+FWRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213641; c=relaxed/simple;
	bh=RUk/p38orSiVjK1buMoSPOdGHaXXTZTj/1Ju93R/b0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7x3c/7xYRCCI+6YX5IUWZmpl3MBnbcPfc+CRtb1nig6sstUvMDspDmFsvmHAnUvdN4c+JOnzxYrPMWPMqwHqKpKfrBnORl3sqzMWJUGfoARXVr6m12ad+TgPIW+4g1ddMpMwM1gkNFqcoc+Dr+uA/vH7qEI52Q9P2eQv+7z9p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwKFM3hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwKFM3hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D03C4CEF1;
	Tue, 26 Aug 2025 13:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213641;
	bh=RUk/p38orSiVjK1buMoSPOdGHaXXTZTj/1Ju93R/b0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwKFM3hpRSkoGCNH5HmMRuDFZvY6rIAQGaLnjf6C7MBO9/lRpEjDgz+Y/hkFze9cH
	 JVURpYd9tpCSPRQIyk1Qy3dxFYzNC3rBtFgGYkOYl0dGp/lIffSdRwWfEREZKd1bJ/
	 FfIZlb0WOqDAINqc2dvXjz2oZgKKWODBhJERSBc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Govindarajulu, Hariganesh" <hariganesh.govindarajulu@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 425/587] ACPI: pfr_update: Fix the driver update version check
Date: Tue, 26 Aug 2025 13:09:34 +0200
Message-ID: <20250826111003.751337896@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


