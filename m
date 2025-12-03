Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF4131A077;
	Wed,  3 Dec 2025 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779962; cv=none; b=smFuN2xdGeha9xaVyxX2aF1z6CTHTgvPv6DVuxjq8P00TYroFVJtozkNw4IFHLepGwFbOKo++28N3Aa2XydNeRSzmMihmYEL6ci7aqa90gKbCPcp3HUKcLBb8ki6Grrw/IkvDIR1o/EqovaF9SuyFBgc/AQ7LNTGvjPII2FWjX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779962; c=relaxed/simple;
	bh=ISVmKsGFflGMg7Ukkgt2WrHx+4ZVyaN1/0eKmzuwA5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0ET2MlPo8uRUwiLyVw87u9OH1Bzrdo+hK0UrOhEDKYnvEFxnb3YMrneiMiSo5yio7GU2O0BSt6jiWYrPVgZkP97o1Fcog+M4yUpIM+S3DMD7q7p235AeTbB7fN05yQpeqLZiBN0q9zfsfJ/gxGP6Alpquzbp/uWTtN4uXpABWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRludL3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRludL3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7931C4CEF5;
	Wed,  3 Dec 2025 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779962;
	bh=ISVmKsGFflGMg7Ukkgt2WrHx+4ZVyaN1/0eKmzuwA5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRludL3TwjXgCfR3y/4xoKYzv6LdsX+0a5FiwCVSKlhMyeTaCwE7y8cuCDXduyhqL
	 p3J5Vol2Edql0SiNVf1ul0NKti0rPA0y+ETdiQqSe+5edwhTzUSPxrwv4JOK6l9sGC
	 IjZsBlxKn1tu5v0N9Z4pd8MR9ywG4HcmXPpIbeMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 414/568] scsi: ufs: core: Add a quirk to suppress link_startup_again
Date: Wed,  3 Dec 2025 16:26:56 +0100
Message-ID: <20251203152455.856124103@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

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
@@ -4778,7 +4778,8 @@ static int ufshcd_link_startup(struct uf
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
@@ -592,6 +592,13 @@ enum ufshcd_quirks {
 	 * auto-hibernate capability but it's FASTAUTO only.
 	 */
 	UFSHCD_QUIRK_HIBERN_FASTAUTO			= 1 << 18,
+
+	/*
+	 * This quirk indicates that DME_LINKSTARTUP should not be issued a 2nd
+	 * time (refer link_startup_again) after the 1st time was successful,
+	 * because it causes link startup to become unreliable.
+	 */
+	UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE		= 1 << 19,
 };
 
 enum ufshcd_caps {


