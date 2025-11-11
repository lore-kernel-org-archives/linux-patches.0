Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDE52BB17;
	Tue, 11 Nov 2025 01:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824955; cv=none; b=XtdVWBL86Sg066cRmimYBOBg5fKUoMPM573gby/LpSYOv4fimqgpe0lwaB2L6U1WuCbmxYekfU0rvvRmrZpQqCtGImoK/CQNe28SQrQ+aQN6ZI3TaUt7cm8B7dREWUUuY63IfhAToBwp1CURdi5we0yq4fhMHW1lPTFRIxxoP6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824955; c=relaxed/simple;
	bh=xlKM4KeBFZ5PaeQ2So9ZuCI1QD43rr3kGVNj4dLz3z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7HaYcB9w/XV+H2riJVhayu1QtpvrM06n3WEjky6oTArhbS/VzBqwNca/lfJCSKHxgppZ0sVlIy97XVrA4ZqP3ly1rmiDsNFcCv5alLXYJ1EQl0tR/S/7qSVBcEIl2eBFEStmF94f2QTOzpGU3xSb1PAbsg1hLJkRfrN5UCopsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgBxHASz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgBxHASz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787F1C19422;
	Tue, 11 Nov 2025 01:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824954;
	bh=xlKM4KeBFZ5PaeQ2So9ZuCI1QD43rr3kGVNj4dLz3z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgBxHASzEedb8xL1VSrfk4yG71lWo2M5MUfEu82+F16TvHu6KGt/7GsRAbPFfcmXu
	 iheFbymBYGz9MAc6nV+ooylRq09bCcdoBE3r3XFGfi6ZEiVESrdezdC3R47Zzwumck
	 3x5xhwZWxYev/w2rZPQYvrh2MdnXroFlgEAkTyzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 557/565] scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL
Date: Tue, 11 Nov 2025 09:46:53 +0900
Message-ID: <20251111004539.539055257@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -466,7 +466,8 @@ static int ufs_intel_lkf_init(struct ufs
 static int ufs_intel_adl_init(struct ufs_hba *hba)
 {
 	hba->nop_out_timeout = 200;
-	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8 |
+		       UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
 	hba->caps |= UFSHCD_CAP_WB_EN;
 	return ufs_intel_common_init(hba);
 }


