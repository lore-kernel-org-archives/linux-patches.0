Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9563081D1;
	Mon, 13 Oct 2025 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368426; cv=none; b=RaV8oPa4cfb9ED4p4KPezAQzHfUWUUKOXjaXvoTTMGsbSrWNT+1Eh1iTku45IO4HPInkja1VFgX0/gl3RCbqyc29kZPuhi09X9R+JCCFLxTb5G6DrE9jSmW30WIznhqU8yOOFvytmQ6vam+7QAwmOPOpddFRNNpmQR9FJVI9NSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368426; c=relaxed/simple;
	bh=rp0kz7ZEXL7J6KCX6td5Dwihm5Ak6zUmHttKT7jeAY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez+7RRkJTNDLd2QZhuJ1csNXHBNrgn4gL4eJODM2MVz8hgTGHrtKSGS/QbjL6U4TqkSfKlQoKf0PqPemifHoL4RUAkRBPw2TqReuTdpfrpOe/ow9hs8VaTIbnyAKWjSbBg4ci/h36UmihPpBk4KLmQLCqVjuzr87+x/zUPqWLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdL8ddzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdL8ddzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5404C4CEE7;
	Mon, 13 Oct 2025 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368426;
	bh=rp0kz7ZEXL7J6KCX6td5Dwihm5Ak6zUmHttKT7jeAY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdL8ddzfq/t1xlqt3TrMTzbv2dI1QSr+5YbOki/zzOG2wgobmejsla6Hz79L+f9nX
	 hSTt8/8iVx2TQjVPwRnlVjwiBJp6AyowyMSfkeDnsv2CSjSc5HLUe6o82/CWZvDojl
	 fCmB9Yfdi8BeLPCSTOenWKGuVE34vxPd6Ibv8aS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/262] scsi: qla2xxx: Fix incorrect sign of error code in qla_nvme_xmt_ls_rsp()
Date: Mon, 13 Oct 2025 16:45:00 +0200
Message-ID: <20251013144331.812733249@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 9877c004e9f4d10e7786ac80a50321705d76e036 ]

Change the error code EAGAIN to -EAGAIN in qla_nvme_xmt_ls_rsp() to
align with qla2x00_start_sp() returning negative error codes or
QLA_SUCCESS, preventing logical errors.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Message-ID: <20250905075446.381139-4-rongqianfeng@vivo.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 8ee2e337c9e1b..316594aa40cc5 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -419,7 +419,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	switch (rval) {
 	case QLA_SUCCESS:
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(PURLS_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < PURLS_RETRY_COUNT)
-- 
2.51.0



