Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2624F129ED2;
	Mon, 18 Dec 2023 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcBkpwkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F5FC433C8;
	Mon, 18 Dec 2023 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907700;
	bh=FIe++Ig7vRce/8OWJbIE2pGeyJegRZkiwItepLlQGPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcBkpwkX7jkd1om50qbsro71zf+mPu8Eu7B6KvTxlCjxb/xeuYCn9YVasmu+zL7gb
	 zWDC7PBRWxlyPfwMfLUmfhiIY/8xgpfU8kV6uBRMFQrRUdK2evef+WJfNUK6MXlkqN
	 GjmO1b1nlxwUHn+uM1KoovnI8sfbwJ7yCJcGpdFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/106] bnxt_en: Clear resource reservation during resume
Date: Mon, 18 Dec 2023 14:50:29 +0100
Message-ID: <20231218135055.609402257@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 9ef7c58f5abe41e6d91f37f28fe2d851ffedd92a ]

We are issuing HWRM_FUNC_RESET cmd to reset the device including
all reserved resources, but not clearing the reservations
within the driver struct. As a result, when the driver re-initializes
as part of resume, it believes that there is no need to do any
resource reservation and goes ahead and tries to allocate rings
which will eventually fail beyond a certain number pre-reserved by
the firmware.

Fixes: 674f50a5b026 ("bnxt_en: Implement new method to reserve rings.")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20231208001658.14230-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e81cb825dff4c..44d88bc1fcbd6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13882,6 +13882,8 @@ static int bnxt_resume(struct device *device)
 	if (rc)
 		goto resume_exit;
 
+	bnxt_clear_reservations(bp, true);
+
 	if (bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false)) {
 		rc = -ENODEV;
 		goto resume_exit;
-- 
2.43.0



