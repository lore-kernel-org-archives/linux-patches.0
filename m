Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF65346A0E;
	Fri, 21 Nov 2025 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733555; cv=none; b=a1R2EhO6OZQfp1rHbvvbymHShvezHvBrHuMVcDX9mCF2QK/thnlPA/zLOm9451MDvp2WjdYd6I9xxIuga40Pbcc2sZcI5vNdYZ2TdTMY5n0upQ61FdoNMnzr1sKTA3PbhIQHmlhXw58XRlqpCKTVVaCCuQLpVNJGYkxWBj45NAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733555; c=relaxed/simple;
	bh=MNP4yk98yjVTQYQJchRGAAYdSVioThDDDWQzWTT4h5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FH6m53NdXRtRRMF9QPyHy7odo0doc2/U5GFXgGpwVVRLXjApD/VHz8rNIQGgHvugmu2nJ8pBmEXZbcdTaaH8jk8p5QdMeZ0/YsFvTV7cTODCNy/rfNE/qVkzZE4rhmZEGjmaCJAqdL/MI4xIN+6pU8J/kTbHZ4KdaLnG/v8dzG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0g63yRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0g63yRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0D3C116C6;
	Fri, 21 Nov 2025 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733554;
	bh=MNP4yk98yjVTQYQJchRGAAYdSVioThDDDWQzWTT4h5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0g63yRw+6cmM9CNc5EsiaVH/OBMwkXVFq/1ZIlR8L4jmlEiDT4LMQ1e4vYQWP5xm
	 5XdMsyUVnc19cLIv0zeuH+BNqvxy6wY7m1tf02OUdNc4IbGJnoyoK80C9kiQwL+mWj
	 uERG0Vem9mLCNW5+fXI5iXit/wYQNwKKjh4qXNJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 509/529] scsi: ufs: core: Add a quirk to suppress link_startup_again
Date: Fri, 21 Nov 2025 14:13:28 +0100
Message-ID: <20251121130249.145928949@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit d34caa89a132cd69efc48361d4772251546fdb88 ]

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
Stable-dep-of: d968e99488c4 ("scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    3 ++-
 include/ufs/ufshcd.h      |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4980,7 +4980,8 @@ static int ufshcd_link_startup(struct uf
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
@@ -678,6 +678,13 @@ enum ufshcd_quirks {
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


