Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DFB3F1AA1;
	Mon, 17 Aug 2026 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977247; cv=none; b=FRuUuH4wojGbFEM7Sf0gS+eQzbGcuF7V9Jn3iG/XjI0r8faChHEQja37Sige7dkZVXOttWVz5lEB1eIIILm/lyz1eHCf4PX5HUmN9b5rKapJThbnXr8smp8SxIMNOfFtpbG/p7ZohOlwPgFk7QgzfAqRwTHEeo3KGNGI4huNvmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977247; c=relaxed/simple;
	bh=9AoNry5IU3tBSnv8nETowDNTYvjOCqNa+UrcId2ntl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAlxIqS8Eq4fgfpmDJzMxGyLhajBWvlUMmQPFyAqU5F+efgysW3IgTM6ZrRcxd5Lm6SU6Nb+sFMKJFYJDx9MN8wcWQ8AgAhlPAqij+LVgXCQbHpIOCuEHlN90B5FMjxk5xhKMUP3VxXdbM4U7edDFmFPwjP2UzBwzIhGgVU4Ooo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+1+zF6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+1+zF6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E231F000E9;
	Mon, 17 Aug 2026 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977246;
	bh=da94yPbyb7EWwB8Z6Hj9ipNRLpWhBUwADrM+JuDLbzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+1+zF6rfoGjtDsxEqGWU/2YZp7b/eAMJgh33h4p9ePJo/4EurwfEJgico0vSIXTu
	 20bEAIyQwvggTSGWx6QWyxQqS6jq6Ztdmuaf4RfjdTIjhq5F2cT3L2Q7RC33W77Nw+
	 dCrjK9Mezkqs8m6vWk2UhuBE5Jt2sDmTIjpTty2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	HyeongJun An <sammiee5311@gmail.com>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/456] scsi: libiscsi: Fix stale-data leak into the SCSI sense buffer
Date: Mon, 17 Aug 2026 15:30:52 +0200
Message-ID: <20260817132550.256947793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 225aa82799609..fbb5eecbb7caa 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -866,7 +866,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 
 		senselen = get_unaligned_be16(data);
-		if (datalen < senselen)
+		if (datalen < senselen + 2)
 			goto invalid_datalen;
 
 		memcpy(sc->sense_buffer, data + 2,
-- 
2.53.0



