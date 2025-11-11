Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2787E2E413;
	Tue, 11 Nov 2025 01:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825513; cv=none; b=CWfvY/MSNtOXrUtXSy3e2bc7abeliXYOyto2zo6vYhPQYB4R0IhZsEgK9PCfrXUJ0OtuD3BGf0y2XkpzPywZkgjXNagon5U93LakcCi8Xnj8NuYieXRr1oMdU/d6mWfEZDDITLdWsK9A9VtD/Sztq9NdolcqPMD0ckZnPqbJ8iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825513; c=relaxed/simple;
	bh=dA6vPA8CHK+A4E32FfcOu3kLpEApP3FCysAX9r54HWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEt8KmK6ojy66K/kTeP2pKQNtXtblEcXc99v/7whZ6eX8EoCkYoz/l6blaPpud2jHuEtGNgTdaoVdbpPOASrx9irdNozwcAsloPPi2x06r68O9a8tixiJWnGpI288nSsVB5WgUtTFGDZSba+l/ZgnYMlPD4LGhpKKIByRj3IbaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flTbPgJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flTbPgJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FF6C4CEF5;
	Tue, 11 Nov 2025 01:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825512;
	bh=dA6vPA8CHK+A4E32FfcOu3kLpEApP3FCysAX9r54HWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flTbPgJ7cPCRTdRjNRsNqOqb57LPJTVagFJHxCq8c8oymkRiMfe6MEVgPbDTDkcwS
	 NFyG1XprllaGUvBeiI/pSIWdfKBe0ZgSZOrebkNLO9XQvZFsQ0CLUdO1ki5Mo2qxEi
	 Kaww5GNAuFbWYr+EmaUrSB5qvKE+4diyXRaOM0D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.17 833/849] scsi: ufs: core: Add a quirk to suppress link_startup_again
Date: Tue, 11 Nov 2025 09:46:43 +0900
Message-ID: <20251111004556.565158758@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit d34caa89a132cd69efc48361d4772251546fdb88 upstream.

ufshcd_link_startup() has a facility (link_startup_again) to issue
DME_LINKSTARTUP a 2nd time even though the 1st time was successful.

Some older hardware benefits from that, however the behaviour is
non-standard, and has been found to cause link startup to be unreliable
for some Intel Alder Lake based host controllers.

Add UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE to suppress
link_startup_again, in preparation for setting the quirk for affected
controllers.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251024085918.31825-3-adrian.hunter@intel.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    3 ++-
 include/ufs/ufshcd.h      |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5060,7 +5060,8 @@ static int ufshcd_link_startup(struct uf
 	 * If UFS device isn't active then we will have to issue link startup
 	 * 2 times to make sure the device state move to active.
 	 */
-	if (!ufshcd_is_ufs_dev_active(hba))
+	if (!(hba->quirks & UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE) &&
+	    !ufshcd_is_ufs_dev_active(hba))
 		link_startup_again = true;
 
 link_startup:
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -689,6 +689,13 @@ enum ufshcd_quirks {
 	 * single doorbell mode.
 	 */
 	UFSHCD_QUIRK_BROKEN_LSDBS_CAP			= 1 << 25,
+
+	/*
+	 * This quirk indicates that DME_LINKSTARTUP should not be issued a 2nd
+	 * time (refer link_startup_again) after the 1st time was successful,
+	 * because it causes link startup to become unreliable.
+	 */
+	UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE		= 1 << 26,
 };
 
 enum ufshcd_caps {


