Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DDF3644BE;
	Sat, 12 Sep 2026 07:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199865; cv=none; b=TXaD4uvQ1zYPZ5pZrQeOlSEHHorxeISlCzvRAAgmsvLXkWdVMkmZ1QaVI6zD+W3lL2Koqv1XFpY7fHcWFB+hkscvo6F+pbs8yPbLq1sdui9DPDqFr7XxrJnQPiar2oRr06pZWIuWB1AVERowYeubyrJ2OP7sUasxScBcUUykJdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199865; c=relaxed/simple;
	bh=SrCHW1J3yOKN5hzjXDB+CaqcgkTMJg6Ky49ub1oB/YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czFkJg685oSx5c6rkGeToDlhK0jK5x9gUvzLfYz5+ZtftMVon9kXLLO4rga0Wb8ujWLsab+n+dJkXAdXo0rtwOsuF5T7lyeZqdMOtcvkml8Cb1naaDdFb69ctzpCvpCrcIuZLsJiVnQEaoxoHTtzKe0Zf9SzM1EHk86Wmyuv7ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISghTvoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISghTvoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F171F000FF;
	Sat, 12 Sep 2026 07:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199863;
	bh=L8b57jpcyrR0M3xnfDLoFH2U/gHPLyzTu4YcEDfPaOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISghTvoyx+jIAn310c7imMWKRVK231Xz33MmprusHKaZ9jVWEVlyJadFcXK+qEr0U
	 ku76Ofhoo4Z62DxF2Kn/ei8ZuM027EYGkdl1/Dzm2HOHvs86HenJe6DqGhL0ggd3qX
	 ROtHFsN3k7lC058ZfVreyFNIHf3FWpaSAHz3Tgtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0671/1815] scsi: ufs: rpmb: Validate request frame length before parsing
Date: Sat, 12 Sep 2026 08:40:21 +0200
Message-ID: <20260912065704.639765763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit a947b8edbdcec8415a80ca55e9f38801322ffdd3 ]

The RPMB core only verifies that request and response buffers are
nonempty. This callback reads req_resp at the end of the first request
frame before validating the request length.  Require a complete frame
before that access.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Link: https://patch.msgid.link/20260717153914.26321-5-liqiang01@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-rpmb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 62120dc2e9da7..3a0888eaa2ce7 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -69,6 +69,10 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 	hba = ufs_rpmb->hba;
 
+	/* req_resp is at the end of an RPMB frame. */
+	if (req_len < sizeof(*frm_out))
+		return -EINVAL;
+
 	req_type = be16_to_cpu(frm_out->req_resp);
 
 	switch (req_type) {
-- 
2.53.0



