Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415A30BB9F;
	Mon, 13 Oct 2025 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367210; cv=none; b=DldV6eOLgz0aOc7P0qKN46zXJzApPhgr5SxQEKof8bOFaj8Eh3vco/i8c42TBB+IY6go3bpLiUUceRwxsl9xgq7oUMXLYqmEhjHTtTDxoGHUMVNe21FQbmwQoAihsL05Ywmp9uRaT2m74fAdb3B7+5+ct9shsoDXuWi3ckwPdh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367210; c=relaxed/simple;
	bh=g2QRpZj1BD3FaylkdL+TFSigx9cbhCtsnXDR5aBOHIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tin1R4tOxCbwVw4UG4VbMCveBwr63DU2994YTfqAsZwnbdwepc3aaLiX+EAaIG9AiNiF5qAkhm5rk3ep7nmWdA3j9i+BXhf/iHKToQ2NYfPGoIaK/h5NdhTb28+ASDpvxhXh2OykWGPJbBdYRRpdsZ7oogtC7gIj8oUlZf6464U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEuJv0Nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEuJv0Nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5CCC16AAE;
	Mon, 13 Oct 2025 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367209;
	bh=g2QRpZj1BD3FaylkdL+TFSigx9cbhCtsnXDR5aBOHIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEuJv0NjKx7HSTKP/+UJnr7Aiac2MNbLm78DKCqWCCp7G0ZfGMIoB/1wJTtMUdzul
	 jFLo6rJJC200sS7GYGli/OTdneCmb0JWv5nVZ8+LRlGdZ9+W2/U7TkHudp3jARno9Q
	 PeIQHZwnc/ky/9jSz6V+msQlZ+cQp3mulYcwi+c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/196] scsi: qla2xxx: Fix incorrect sign of error code in START_SP_W_RETRIES()
Date: Mon, 13 Oct 2025 16:45:04 +0200
Message-ID: <20251013144319.433547492@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index 682e74196f4b0..d2243f809616d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2060,11 +2060,11 @@ static void qla_marker_sp_done(srb_t *sp, int res)
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



