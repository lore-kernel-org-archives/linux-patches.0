Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF5D30B51F;
	Mon, 13 Oct 2025 15:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367748; cv=none; b=ix62mTF419fz1KpQIRk+ReAEs/4eUk2e1fjUMohI0wMcU75hDp74PGQ+yecqYR3Pdkp+7grSmy3zauhQ6vUH5U2kYM042TucrQX2MtwUbnzvcf+OWJGOKgoylKSA9LJLS0oMgnbUAG8VvWXq2Ea9B7VuQl1IPp6Chw5NaxIhLkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367748; c=relaxed/simple;
	bh=GFxvUIq4zSXJIHgnJEh1fU6qz2MLI5UgK00NtgZnZB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ/kp+mRxX5QAsbHozffyha7F9D5J4eWUyrY+5VPZSnpbx5tIPnQR36i4OIu/3EaaUphTHffj6UL/lZ9NjSe1CHcCtTS9nt49dFy8m6HP3AXYPpwwSdshbujG3ABsiLZd1OUzzQ4ahvjQhkxNwBfMJ6CEgve8hENQzJCkiabklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAdoSKf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAdoSKf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F937C4CEE7;
	Mon, 13 Oct 2025 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367747;
	bh=GFxvUIq4zSXJIHgnJEh1fU6qz2MLI5UgK00NtgZnZB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAdoSKf6auLZQeBcDmI9MKkz/1Pz+q5Ps32TXeSuTXTWQf+h88WL0TepPp0tfUtqP
	 ie+oDjUCngWhiyLV3pTZLh/ZM6SJeI2SU7fbQIGyzdd/XaEiKv/UvCCFpxlYmLBxrV
	 nnnBnpH8/es/I2n5VE1Tu8o0j9rHoqwLanFX/0dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/196] scsi: qla2xxx: Fix incorrect sign of error code in START_SP_W_RETRIES()
Date: Mon, 13 Oct 2025 16:45:11 +0200
Message-ID: <20251013144319.650504212@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5fa2727c1bea7..e881d704b45d1 100644
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



