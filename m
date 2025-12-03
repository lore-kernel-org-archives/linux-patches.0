Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397831A077;
	Wed,  3 Dec 2025 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779966; cv=none; b=f6sH8g82P2Qyv2JvcNulRSL/HZUsUM+LNHoxyVwtjPTBjZxK5sNa3UDERpe+aaU2RqD3pQymQegp5GXmI3SAaMOpR0je0PSj5zTsVsr1uEu7XiFD1MPCCXLWFodyAIaByIEwg7rdsGnx0dxhHxrsijX9CFU6C4AY20/EKzIGKeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779966; c=relaxed/simple;
	bh=MSrDtaSGITKm/nIXWMzKPiUtis96Wtd1t65GUdIJCQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0FbtcbKRKbQyrYz7LqMHI5Hagf2kALbJnMSsMHVnhyJhwABPOOJ56o8ZFkOSFmje4FwX/Xwh78hGx3KXubt3IEI5me/CR2AxkfmiGQmZne6EKfPqaeSdKGKDEiCyX/zxzI/WbQ2K/JAI3MdgmmB7RlopZQENZp/Ot2ni8aYQjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsgfVcGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsgfVcGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD95C4CEF5;
	Wed,  3 Dec 2025 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779965;
	bh=MSrDtaSGITKm/nIXWMzKPiUtis96Wtd1t65GUdIJCQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsgfVcGLKQ5VE+TF3hJZQ6hfcZCPrAKWpYYPaXNSePAVuqvoA5sPo2WmqdABpjrDf
	 rmwL6/W78VD+EsY+GWWHS8eHdBF7PnYp80pHKZT8esS8Zizo+098XbJVhL0HAXDusb
	 VkHdxYM0pb1/+430FGSUqsYC1oULSgT3ZmTNp4ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 415/568] scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL
Date: Wed,  3 Dec 2025 16:26:57 +0100
Message-ID: <20251203152455.893404735@linuxfoundation.org>
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

[ Upstream commit d968e99488c4b08259a324a89e4ed17bf36561a4 ]

Link startup becomes unreliable for Intel Alder Lake based host
controllers when a 2nd DME_LINKSTARTUP is issued unnecessarily.  Employ
UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE to suppress that from happening.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251024085918.31825-4-adrian.hunter@intel.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ adjusted patch context line numbers from 428 to 460 due to prerequisite backport ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufshcd-pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -463,7 +463,8 @@ static int ufs_intel_lkf_init(struct ufs
 static int ufs_intel_adl_init(struct ufs_hba *hba)
 {
 	hba->nop_out_timeout = 200;
-	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8 |
+		       UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
 	hba->caps |= UFSHCD_CAP_WB_EN;
 	return ufs_intel_common_init(hba);
 }


