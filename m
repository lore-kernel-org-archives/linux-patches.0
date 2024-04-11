Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DFD1F5FA;
	Thu, 11 Apr 2024 10:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830184; cv=none; b=oCNkRji16+GZ8imep6DnLjdtvGBjQMNnufM0j0s3NFyTi7c1yyBk6Fkor1LWP3Gd8Hg+uiu0PC8oHzwSucFOu+MQxgoKzqImh/pvryemBKx7xUwnuHWguFJjdst1jbMkz0WbWZXUB7lo5o5NKJFaKhZ3iycAi124NjORvUzhN6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830184; c=relaxed/simple;
	bh=b4VnElRLTuk9Or90sm5QDjFPW8GyS0X8UBhdRsyKn9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGZAzFfL3ThoVcuf51wCchz+cewqU8G+ioXByO+pezNcJ3D43Vst08dWt+WUNZeH1O9wjXXEt6XexmN0CJtvZjK7FbGT7s4eRb0+Dl5lnA7KH0GZWNl7CNOkjUqNsleAZgwIov03yv+VGvqpXvwE37WjK3aIYxQqMPWvhfRN+n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xadiSLCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xadiSLCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB92C433F1;
	Thu, 11 Apr 2024 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830184;
	bh=b4VnElRLTuk9Or90sm5QDjFPW8GyS0X8UBhdRsyKn9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xadiSLCcM3cNaEIKhNrjhhaFVGGMxoPRuEzDHXKaPenb0hn5UIVS8ShPv1vFurNW5
	 0+YKLmdJMprR0eNY/q9N6UtsyFEXzFT6nhBBJCprpWOU+Q5S/qQlzaijRxgW5Nyrm/
	 AE18yiblWZCl1xJgGNEqxwHbEThbjcBGuov3MXp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Chanudet <echanude@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.8 064/143] scsi: ufs: qcom: Avoid re-init quirk when gears match
Date: Thu, 11 Apr 2024 11:55:32 +0200
Message-ID: <20240411095422.842529080@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Chanudet <echanude@redhat.com>

[ Upstream commit 10a39667a117daf0c1baaebcbe589715ee79178b ]

On sa8775p-ride, probing the HBA will go through the
UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH path although the power info is
the same during the second init.

The REINIT quirk only applies starting with controller v4. For these,
ufs_qcom_get_hs_gear() reads the highest supported gear when setting the
host_params. After the negotiation, if the host and device are on the same
gear, it is the highest gear supported between the two. Skip REINIT to save
some time.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
Link: https://lore.kernel.org/r/20240123192854.1724905-4-echanude@redhat.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8775p-ride
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 3d43c7ac7a3f8..f532e2c004a25 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -738,8 +738,17 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 		 * the second init can program the optimal PHY settings. This allows one to start
 		 * the first init with either the minimum or the maximum support gear.
 		 */
-		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-			host->phy_gear = dev_req_params->gear_tx;
+		if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
+			/*
+			 * Skip REINIT if the negotiated gear matches with the
+			 * initial phy_gear. Otherwise, update the phy_gear to
+			 * program the optimal gear setting during REINIT.
+			 */
+			if (host->phy_gear == dev_req_params->gear_tx)
+				hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
+			else
+				host->phy_gear = dev_req_params->gear_tx;
+		}
 
 		/* enable the device ref clock before changing to HS mode */
 		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
-- 
2.43.0



