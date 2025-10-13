Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE930C614;
	Mon, 13 Oct 2025 15:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369807; cv=none; b=IRONxCpQAi8slnCK0QtqlF28jU+X70nRDa9CU4+v0BJPSdKe+qMVFm93oVblA02LQowE7KXVLMkMzCLyy1bntq+cChy4MorxpDuKIVTPaV8dP/S26BhaNa78F1PJdMuqyQFjaEQGbBA6sDpRWF8nP32NkaL6lvEx//o1lrQYOzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369807; c=relaxed/simple;
	bh=67F7clzCZL84ZwplXOoI6Bze+e6g8y7rRoxO0yq1xXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCuso5ked+SazlbSY6RJsX3qoLW4+SSCuIYhB4b4nrRJxdEBpQigLocS/T9nGrOPl9xCumLclZnVG72lQXkm/MuHJ7YbmwRiUbY1JnafB9V+6EDJPBZIShhpcpCpQrWRJ1sLDhhtAdn6b5/o7uptlMl/so8OVRCYW82ikKwq0rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qa9jayW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qa9jayW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C981C4CEE7;
	Mon, 13 Oct 2025 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369807;
	bh=67F7clzCZL84ZwplXOoI6Bze+e6g8y7rRoxO0yq1xXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qa9jayWesiy7St4a8bzHzq7jWmGuAMLMjo6GlZ3TORIzu1P1+vlUbK+ms5vuQply
	 g9AFr5/FOrG/FUi3tUFBxSokYp9uN8NShug2F9hD1sb/p/ILc7CvbU5UXc1e53qdyb
	 04oi8EaXfTnG85SIJhKtY/pcJium750sBN4Y/2Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 374/563] scsi: qla2xxx: Fix incorrect sign of error code in START_SP_W_RETRIES()
Date: Mon, 13 Oct 2025 16:43:55 +0200
Message-ID: <20251013144424.824428724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index be211ff22acbd..6a2e1c7fd1251 100644
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



