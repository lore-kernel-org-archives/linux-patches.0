Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF81277CB8;
	Mon, 13 Oct 2025 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367307; cv=none; b=JrkMZUc+OO1bN2xYQYN/VPB81dKp1XiPbugrM/IIzU5znUoujZbz3ksY1ZFa8ODRzNH+JoQ1m8hevZwVWCJzW5+n1KJ+k4/RCxgvjEm+9pKpPK041zquu3UQ9UlPD/y5LkXThjNC/mU1FvDjqoIYbqTmfRq5teP+NBOqhJ3+xNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367307; c=relaxed/simple;
	bh=cg/oa+ODSucqD2UVRkB49b2mda2UrsTYcngLl1e0zKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLTmdR92ofx3a0LhEMgStOlJNzz8RvdyT15yFDGONRHSCeiRFF/9ygTrLh7wnOHT2MN8jM/AJB9nSUhVHMtwk8mWQL4VCPrevwjaZgGDxTS9cTPt7XIoZVSqGj01pJ9N8Y3ecM9fyeuUjUFoiKbou8oQrw4M/m5CkwITXHW5moA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxRGCtp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxRGCtp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C67C4CEE7;
	Mon, 13 Oct 2025 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367306;
	bh=cg/oa+ODSucqD2UVRkB49b2mda2UrsTYcngLl1e0zKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxRGCtp0RWfRZJG20A7IyP0e/rk4cYUxBxLAQMZpClFeX5IeT0kmy3bphtRH0Qace
	 QynqUzuj7vBIQqsay+zE8aP6dxJtdBoqkzMFDFOyAmq6Hek4VoJm/8Gzpe68a5dYcZ
	 An7AN3vX1f0CIsrJRs60NFX+U/kBmG89L39F71jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/196] scsi: qla2xxx: edif: Fix incorrect sign of error code
Date: Mon, 13 Oct 2025 16:45:03 +0200
Message-ID: <20251013144319.397389413@linuxfoundation.org>
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

[ Upstream commit 066b8f3fa85c1be7fb7dbae202231e131d38f7bc ]

Change the error code EAGAIN to -EAGAIN in qla24xx_sadb_update() and
qla_edif_process_els() to align with qla2x00_start_sp() returning
negative error codes or QLA_SUCCESS, preventing logical errors.

Fixes: 0b3f3143d473 ("scsi: qla2xxx: edif: Add retry for ELS passthrough")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Message-ID: <20250905075446.381139-2-rongqianfeng@vivo.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 969008071decd..482c04ac06ba4 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1755,7 +1755,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	switch (rval) {
 	case QLA_SUCCESS:
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(EDIF_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < EDIF_RETRY_COUNT)
@@ -3621,7 +3621,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		       p->e.extra_rx_xchg_address, p->e.extra_control_flags,
 		       sp->handle, sp->remap.req.len, bsg_job);
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(EDIF_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < EDIF_RETRY_COUNT)
-- 
2.51.0



