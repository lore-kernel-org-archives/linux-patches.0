Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB6679D8;
	Sat, 30 Dec 2023 12:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KQv5Dex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50232C433C8;
	Sat, 30 Dec 2023 12:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937911;
	bh=GC29kCB/122GV85MjTvZ5OOSFhyOGS4psnLZp1ROVk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KQv5DexIHxwhPT2GIebZ2ZRSpD2ZNIUpqZBvgOK01TZW1QZdOrY3BTcn7CpD/0vI
	 8lBH/9PbsERdkCUd3Kq9+NOeAie079dHxxWsrIqkN7v88sK3Jg644XVsHjdu/os/ZS
	 YkSxWosuw4GFW/SA9k5mZdYp+KBwxdQgS54hITHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/156] scsi: ufs: qcom: Return ufs_qcom_clk_scale_*() errors in ufs_qcom_clk_scale_notify()
Date: Sat, 30 Dec 2023 11:59:01 +0000
Message-ID: <20231230115815.199901049@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: ChanWoo Lee <cw9316.lee@samsung.com>

[ Upstream commit 9264fd61e628ce180a168e6b90bde134dd49ec28 ]

In commit 031312dbc695 ("scsi: ufs: ufs-qcom: Remove unnecessary goto
statements") the error handling was accidentally changed, resulting in the
error of ufs_qcom_clk_scale_*() calls not being returned.

This is the case I checked:

  ufs_qcom_clk_scale_notify ->
    'ufs_qcom_clk_scale_up_/down_pre_change' error ->
      return 0;

Make sure those errors are properly returned.

Fixes: 031312dbc695 ("scsi: ufs: ufs-qcom: Remove unnecessary goto statements")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
Link: https://lore.kernel.org/r/20231215003812.29650-1-cw9316.lee@samsung.com
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index b1d720031251e..fc40726e13c26 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1399,9 +1399,11 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
 			err = ufs_qcom_clk_scale_up_pre_change(hba);
 		else
 			err = ufs_qcom_clk_scale_down_pre_change(hba);
-		if (err)
-			ufshcd_uic_hibern8_exit(hba);
 
+		if (err) {
+			ufshcd_uic_hibern8_exit(hba);
+			return err;
+		}
 	} else {
 		if (scale_up)
 			err = ufs_qcom_clk_scale_up_post_change(hba);
-- 
2.43.0



