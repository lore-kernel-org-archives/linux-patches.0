Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A55E3A75A3;
	Fri,  7 Aug 2026 15:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114835; cv=none; b=Prje117FkhG2j+dc7tSTe/sm2z+5Y/FdWyZVuAfS9vwj40DYsJxebFO3ZU+NI++fFTRQh0CJRfNxdOnIbN5hAO9fasKqWHYrArHbffQgWT7tF5O+MlZHkheWpuapZIfg3fNWcDt0DKZnsPwgpO2s9mT0L0IFjUFykLbLrHOKRYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114835; c=relaxed/simple;
	bh=UA2R6JgohTkG1kbROAE0fT08G+yEzkOVyQ+uQrj3IS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyuPctd64BFeNPSrHAekNKpwOo+x5iJYtSRrjK0izpSm/ov52VJ3D35NCX3SefbeR9Mn9rrSnhsFRppARlMp9AH4auXnnHt56sV90WxnikcBAlMpaUFgHW+0J3kq4EF4scnTNWyRYPNplA1JojxsICWRySjp1AvfgpxHKWFQksM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHMBamxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHMBamxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C2D1F00A3A;
	Fri,  7 Aug 2026 15:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114834;
	bh=NXtV45UfDaJg9ONAeYwYXtn7veMyGXI+kBvK1YTSfYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHMBamxg/oLcFipOnAtmIOXcHX1gxtDrN8BpjhtCHCW1wzIs/UoKehFrvXT1enbsN
	 hvRp0S7aLGd73Na57TbV51T2Kl83HvLmyXOzQnCWluJd/JLazYFp6ZFP0A0wuooO/y
	 gDljSDXJ8PGYbLUZV9SmZt72lViZcvH9sql5kWCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	HyeongJun An <sammiee5311@gmail.com>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/396] scsi: libiscsi: Fix stale-data leak into the SCSI sense buffer
Date: Fri,  7 Aug 2026 16:33:44 +0200
Message-ID: <20260807143425.654591039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 98b87885de4b7f605533a2860685f5689fce8e82 ]

iscsi_scsi_cmd_rsp() copies the sense data of a SCSI Response from the
target-supplied data segment.  The segment carries a 2-byte sense length
followed by the sense bytes, so it must hold 2 + senselen bytes, but the
bounds check only requires datalen >= senselen:

	senselen = get_unaligned_be16(data);
	if (datalen < senselen)
		goto invalid_datalen;
	memcpy(sc->sense_buffer, data + 2,
	       min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));

A target that returns a SCSI Response whose datalen equals senselen
(with senselen <= SCSI_SENSE_BUFFERSIZE) makes the memcpy() from data +
2 read up to two bytes past the received data.  Those bytes are stale
conn->data contents and end up in the command's sense buffer, which is
returned to userspace.

Account for the 2-byte sense length prefix in the check.

Fixes: 7996a778ff8c ("[SCSI] iscsi: add libiscsi")
Suggested-by: Sashiko AI <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Acked-by: Chris Leech <cleech@redhat.com>
Link: https://patch.msgid.link/20260714104934.1404423-1-sammiee5311@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c9f410c509783..e2adebc80b3a9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -918,7 +918,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 
 		senselen = get_unaligned_be16(data);
-		if (datalen < senselen)
+		if (datalen < senselen + 2)
 			goto invalid_datalen;
 
 		memcpy(sc->sense_buffer, data + 2,
-- 
2.53.0



