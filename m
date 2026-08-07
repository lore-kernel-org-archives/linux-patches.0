Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F6E3A5E77;
	Fri,  7 Aug 2026 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113859; cv=none; b=Luii1FtFi1hDtbST/EKuRgpj99bw70M5WuT8jO60SDnHaPguI/8DSj/fwW/P4suFINTKIFPXqjdUn+RDwu3n8RGTos8TGmri0XawyydKOkwrY9viCpftudZQ755HNWLBe9GrflbydHdNS/xxgX1wV2K4aIqCejC+0MvaV4OfDS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113859; c=relaxed/simple;
	bh=kW8RNYlb52Ig2G/+LkGPq4dw9qS0ZsSckxD6tOAj63E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIhXvqyMTB0Rgpss2AduWt03wyBAUBxeRq61TamEObHFWgt44wYtKkr4oHA/EpPNrOwtYFJe62/pdw3iTUxlrEdbJxSJDntDxqS7RGDCA6ItZ0ashEpCZrG2Mcyf5YT8qNFEz6YboAXHumqlJQk5XTZMjlsgizjPeyKdQzLc9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/Qycos7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/Qycos7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5681F000E9;
	Fri,  7 Aug 2026 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113842;
	bh=hiPsPaoVHLWDK9N4R0OhmvjOLedkBdi+/PeSgDnEgIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/Qycos7lH4atedGXwhFytabjf8Duich9LkSBzUHdpCKqS5DQ5ytco2mChDiPFXuD
	 DWwu2t7TCX1gN6YO+NpeHrchTvK08WItY48mrqke2Hn9bftvQs2mcB8QRLFnRXaK0J
	 SEh64mwvMT/YSlORRLAygE7Pw72lrY8BUTOmFhbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	HyeongJun An <sammiee5311@gmail.com>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/337] scsi: libiscsi: Fix stale-data leak into the SCSI sense buffer
Date: Fri,  7 Aug 2026 16:34:17 +0200
Message-ID: <20260807143419.685920696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 29af3722ea220..0f169f243475f 100644
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



