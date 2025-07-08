Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44318F5E;
	Tue,  8 Jul 2025 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993536; cv=none; b=ra3eK9kfcv0bbhUzqB3psJne2A9tePx+fr+XYZSvKatiBNw4FHUlFs0XQmUPLNJqti6u0lH8xhO5ULPCimsrmmXuorG06A6DFuVNy0M6rIZNMOQ6Gvtd1vpthSZ59JE2d0sMa8IVn1LPsgZvwKUDIsgsnPFeVQYPbidp47hhcEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993536; c=relaxed/simple;
	bh=1H6p0z8LC+acOcDWudYRaiVfW1DJs3tXoFi7pUmP7PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZXcoZGuyZ6tbFTEOKQ9f7o/wT3X4sEh6XT4nSCLCvzSUctaK4Pc5KUkTTNgAoFFFV2Xemhyi2GVfH4O+IU2A0PmssbOcSOK6Qp5VlNEonKphQuZZ9/xNdoKqGOuhEvOCZxZ9cy/iCjcFx9euG1EAPpEuLo6nXDzxL+VagujBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjLVm/6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjLVm/6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CD2C4CEED;
	Tue,  8 Jul 2025 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993535;
	bh=1H6p0z8LC+acOcDWudYRaiVfW1DJs3tXoFi7pUmP7PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjLVm/6xcinnuaUY8h5OzvIdoUwjXmion0FBJPGzL8UddBDiGwd/4RNC135EBHEPD
	 CuCaVf8RdjrZOCiYS85ez+wuGwLMcJy72q8rp05cXd+AXKRbVXRpsR0MejCgJVWpir
	 9b2TjZ+MtpMPHWwhzgeNRFFKCSo//rVQG39eHSug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 077/178] nvme: Fix incorrect cdw15 value in passthru error logging
Date: Tue,  8 Jul 2025 18:21:54 +0200
Message-ID: <20250708162238.689787745@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 2e96d2d8c2a7a6c2cef45593c028d9c5ef180316 ]

Fix an error in nvme_log_err_passthru() where cdw14 was incorrectly
printed twice instead of cdw15. This fix ensures accurate logging of
the full passthrough command payload.

Fixes: 9f079dda1433 ("nvme: allow passthru cmd error logging")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d253b82901110..ae584c97f5284 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -382,7 +382,7 @@ static void nvme_log_err_passthru(struct request *req)
 		nr->cmd->common.cdw12,
 		nr->cmd->common.cdw13,
 		nr->cmd->common.cdw14,
-		nr->cmd->common.cdw14);
+		nr->cmd->common.cdw15);
 }
 
 enum nvme_disposition {
-- 
2.39.5



