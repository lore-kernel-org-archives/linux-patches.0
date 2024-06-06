Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC211A2C35;
	Thu,  6 Jun 2024 14:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683208; cv=none; b=lL3NSCSGB0mnOOfdhHWCx9NeoODgmWAUKTFUwk10EuGhEl4yYINKpgtH7WECzqux4mptq+0766cslwkXo1oHfLIhPWA69iSDDnUhasjjynK555TBCb3miAMLsHUujd/thvaR0zlE/O5aEQsFq5uwVwFoZSDuasY6kr1+V2TEcck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683208; c=relaxed/simple;
	bh=K2ViiHRyRSMtqIL9KH8+zgs3iF4haKfxaDnnoqNyZag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsSdQDodpSTQfd5dNRkpjDHDVQJMeKHvIEiYLEHxsDJEFQQkuabrYdX/lXlmhgEpnSJsuw/57q2o8XP/bTwWZnQq0mk/RnnAaPh2h+QJpSbk5Vx3EvXxXBjqiRQ1ZlC+4ELYq2X4sJWAD1mb8pfGpzH8dFlDZ8jlHlBxOKyuYMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bZBpmmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bZBpmmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1186EC2BD10;
	Thu,  6 Jun 2024 14:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683208;
	bh=K2ViiHRyRSMtqIL9KH8+zgs3iF4haKfxaDnnoqNyZag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bZBpmmf+UgBVcr7WMDrNukZRi4R81vA3nVU89AUcp7q9a6Y/SMkhHh+oNrSnPw+F
	 FTZCDJ38ycoXlM74sS53F2HqzPuH+Yp2/9JyhvdlIlFy1u+W08hu33bmqvcsJisTRO
	 xD7nZkodLlIcUiuHoEK4GE2hHrW/bdC3dtn83g3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/744] scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US
Date: Thu,  6 Jun 2024 15:57:03 +0200
Message-ID: <20240606131737.262005910@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit a862fafa263aea0f427d51aca6ff7fd9eeaaa8bd ]

Currently after writing to REG_UFS_SYS1CLK_1US a mb() is used to ensure
that write has gone through to the device.

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s purpose
wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-2-181252004586@redhat.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 797219db026bc..559b4cab16a3e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -597,7 +597,7 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
 		 * make sure above write gets applied before we return from
 		 * this function.
 		 */
-		mb();
+		ufshcd_readl(hba, REG_UFS_SYS1CLK_1US);
 	}
 
 	if (ufs_qcom_cap_qunipro(host))
-- 
2.43.0



