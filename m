Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9485C30B51A;
	Mon, 13 Oct 2025 15:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367753; cv=none; b=XpZOTA9qxjP1NMNRIgzfRasKmTRlY3+/cvF8tHyhMllZe0jZcRg90sEXFZA6XmpCAfv+/KUukU9ojG1hvfXJvh+LeAHmOLzJDzPcVG0irvxJo3pzDIUL0/DjpEM0e5UY6eE4M6LqCoMMl950LekeYcGlz0EISWpwoWj3IjvquBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367753; c=relaxed/simple;
	bh=9uPVAuZWL4VMzJ35uUNTiSSuQED25LeY2C9HoQGJQhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+rWcJfRHnJsjwcbhGWKqDNImMXTjOqwCdjDf39ZPuIXpcCMTiAMLNUsk8BsUxL7zjfYs4uhMTpu/SjOphia47rrjjlusezSm8yWPbAG73rMt1FXCqZ1ELPRGbzHOhvyZw0cN40qGnGjm3xHwo3y8g9u8Lio6HSRTd+luEoyY5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFfoUTlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFfoUTlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198CAC4CEFE;
	Mon, 13 Oct 2025 15:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367753;
	bh=9uPVAuZWL4VMzJ35uUNTiSSuQED25LeY2C9HoQGJQhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFfoUTlD+E3H6KtCxBQ+yH7S9+Y/AhCkqgHvQ3sNxGKnc/ggkA3DLI7reYMZnp05P
	 aPJLOqYqSc6Qzt/A7OZnBhZGsxF1Mnxl7AeipLUYIaN0TmF9MogzIG/LM3d2kjwoio
	 +v1yk8Vl/qgdklg9N+xrS5wt+IAKsN1IXnd2HRDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/196] scsi: qla2xxx: Fix incorrect sign of error code in qla_nvme_xmt_ls_rsp()
Date: Mon, 13 Oct 2025 16:45:12 +0200
Message-ID: <20251013144319.686563241@linuxfoundation.org>
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
index 8f4cc136a9c9c..080670cb2aa51 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -420,7 +420,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
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



