Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32F3224B12;
	Tue, 11 Nov 2025 01:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825510; cv=none; b=IG4NxOFEJ0da9piMCZTn/7CwhF7X7tjKGhXKx5pQFPhx7RVFtHSbX6ZY+8gClMAAb2GnfhW1rfGTlfBsBNLme7X+fkbO1PvQhs0DDSJAWMONK7ILykRZTZTZ776DtAQcGLUvmadG3bLhgaiArld3Oc37LPfLIqO4Egs/RdsMmS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825510; c=relaxed/simple;
	bh=9awgsDrhxAFblDFBCuIRB4dShVBgscUqcHaZKcmd4cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqxCB6XRbZCJ18ophPRQdd7/CnFAfLbI0Fd+7xGmT8rVD60hwxTTxt0vCF5GbgA0JBiR+Ry8IPFqc3ulabZTm/7FckRCohFRIw1ojY/4dQuSpNze7Z5yKjDFwlOIXtmgcvysw9fRAElg0mZltgaQNJto4ID8ZezQJgJbnrvYvVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKyIFttN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKyIFttN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB77C19422;
	Tue, 11 Nov 2025 01:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825510;
	bh=9awgsDrhxAFblDFBCuIRB4dShVBgscUqcHaZKcmd4cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKyIFttNodoaIrQ6ykQOLkpxvoCYB1IYkUMV0YTlnR4lpf3c8RlXfWiKfKMdXyKB8
	 +SmERu2k44xzZ3KjWfm6WdUqhMxwMiMy1zGEgpOvC/qkk+v34D57ZgPg9xO4E4Iya1
	 0u9lpq5ARCZ6wHI/UpMh8SaHVgrtyrY0mXNTIM3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.17 832/849] scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL
Date: Tue, 11 Nov 2025 09:46:42 +0900
Message-ID: <20251111004556.540523681@linuxfoundation.org>
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

commit d968e99488c4b08259a324a89e4ed17bf36561a4 upstream.

Link startup becomes unreliable for Intel Alder Lake based host
controllers when a 2nd DME_LINKSTARTUP is issued unnecessarily.  Employ
UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE to suppress that from happening.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251024085918.31825-4-adrian.hunter@intel.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufshcd-pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -428,7 +428,8 @@ static int ufs_intel_lkf_init(struct ufs
 static int ufs_intel_adl_init(struct ufs_hba *hba)
 {
 	hba->nop_out_timeout = 200;
-	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8 |
+		       UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
 	hba->caps |= UFSHCD_CAP_WB_EN;
 	return ufs_intel_common_init(hba);
 }


