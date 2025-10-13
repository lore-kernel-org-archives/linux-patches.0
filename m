Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B5F2FD7A5;
	Mon, 13 Oct 2025 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368423; cv=none; b=FEjlo80wAAJdBzGpmRsd/CdR9S+foJ5jgws8AVOVfUlD7AsEswD8D/O3NNvK8kb/913nWiOGi8/11YgVz5a0criC830khjhgrmKwKql46ekDLGPYWawdCNwvFlfyG9XSdaDbc2RIs9eVSyfaqpeJyUdNAFjHyGNlJrD9PBTCCGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368423; c=relaxed/simple;
	bh=5KzS5zCpHMIcFMPyRydXAIPA77f8vYjwD+emJJ/xTMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8/0SRv0afyYFyAs3/PkMGJzdRiLvokDUX+gKtGS3w4hvJ3OjnctUgCR84LZmKARhVWRMcPIbSfXtm/PBKuwgzlCzNn2R6B8brDpfUudaIb/q9zO7rBHy3yBE+mHm2gOMg4EEFKSj1/YtamUDIt/jDM2vHzcd/mC1WyuyX1odCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3WvXfvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3WvXfvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD17C113D0;
	Mon, 13 Oct 2025 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368423;
	bh=5KzS5zCpHMIcFMPyRydXAIPA77f8vYjwD+emJJ/xTMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3WvXfvxrhqOQRbpU6AnamMa/FFZ0ZuVZOtKA8ira4+2xCvIDbOl1byrX+7W7A9kK
	 BgSu/3O7qptuMVpUUHPT1aueh75wLODpr50dmj+BEyiKh0hctR1IEvx8iUVxVH0uey
	 uPlGJa0XNPWlqoWdaUskFkd8RNFVX1BfYRoLifgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/262] scsi: qla2xxx: Fix incorrect sign of error code in START_SP_W_RETRIES()
Date: Mon, 13 Oct 2025 16:44:59 +0200
Message-ID: <20251013144331.776117164@linuxfoundation.org>
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

[ Upstream commit 1f037e3acda79639a78f096355f2c308a3d45492 ]

Change the error code EAGAIN to -EAGAIN in START_SP_W_RETRIES() to align
with qla2x00_start_sp() returning negative error codes or QLA_SUCCESS,
preventing logical errors.  Additionally, the '_rval' variable should
store negative error codes to conform to Linux kernel error code
conventions.

Fixes: 9803fb5d2759 ("scsi: qla2xxx: Fix task management cmd failure")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Message-ID: <20250905075446.381139-3-rongqianfeng@vivo.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 79cdfec2bca35..8bd4aa935e22b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2059,11 +2059,11 @@ static void qla_marker_sp_done(srb_t *sp, int res)
 	int cnt = 5; \
 	do { \
 		if (_chip_gen != sp->vha->hw->chip_reset || _login_gen != sp->fcport->login_gen) {\
-			_rval = EINVAL; \
+			_rval = -EINVAL; \
 			break; \
 		} \
 		_rval = qla2x00_start_sp(_sp); \
-		if (_rval == EAGAIN) \
+		if (_rval == -EAGAIN) \
 			msleep(1); \
 		else \
 			break; \
-- 
2.51.0



