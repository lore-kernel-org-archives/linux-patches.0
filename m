Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EC8423A8E;
	Tue, 31 Mar 2026 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974804; cv=none; b=dntH4KMumqlorz/suLE3WsYHNHjMcLcCTp+y6A9nt20AGsorSXqAtHMsdUlSDb77k6I8ktogEgBfxiukTlMy27p7LZxKj6cIOBjicxPCv4dGy11y83Xzxq1f4sfTgdFr5L01+mmuMg9ye0rS+UVkFQjaufgit+AtsrWePv9+sTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974804; c=relaxed/simple;
	bh=zr6nWZG91qyadPqFyom60MRxiIyAcLYxlIKXBEzQY+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnSosKCT3xHyqB6jXb5Aw5BPrmnNuKE4VlY+oxd+Pa2yCe8FiWwob+qjQrMsWZJFFSxo1lthTqZVyr6XVnvof4JwzCBp/mguGExZd2Zz4FCszFSiYDsCYcBhgUCfQ6qZVyje0H6oQgBfHTLzhY/Gg2rkFsLDx1xLTvg1P8LMXcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stmMD+cn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stmMD+cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D929C19423;
	Tue, 31 Mar 2026 16:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974804;
	bh=zr6nWZG91qyadPqFyom60MRxiIyAcLYxlIKXBEzQY+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stmMD+cnm4j4g/JtoyfSTLWHjaxPdwcN5QFTV7dWd6dNfMsCI7YjHaDWufFimjpyJ
	 H+UP7KF/p9X5SO9oGv9hzp7bY5edcXZEnWqYT7Lsjb93hXCe6C6czeiNQopKcz8Unx
	 uRwlOFBvn8GdTfxFx60E4Q+n4wKxMQW+Y0SBuzhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 049/342] scsi: devinfo: Add BLIST_SKIP_IO_HINTS for Iomega ZIP
Date: Tue, 31 Mar 2026 18:18:02 +0200
Message-ID: <20260331161800.703642002@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

[ Upstream commit 80bf3b28d32b431f84f244a8469488eb6d96afbb ]

The Iomega ZIP 100 (Z100P2) can't process IO Advice Hints Grouping mode
page query. It immediately switches to the status phase 0xb8 after
receiving the subpage code 0x05 of MODE_SENSE_10 command, which fails
imm_out() and turns into DID_ERROR of this command, which leads to unusable
device. This was tested with an Iomega ZIP 100 (Z100P2) connected with a
StarTech PEX1P2 AX99100 PCIe parallel port card.

Prior to this fix, Test Unit Ready fails and the drive can't be used:
        IMM: returned SCSI status b8
        sd 7:0:6:0: [sdh] Test Unit Ready failed: Result: hostbyte=0x01 driverbyte=DRIVER_OK

Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Link: https://patch.msgid.link/20260227181823.892932-1-fuchsfl@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 78346b2b69c91..c51146882a1fa 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -190,7 +190,7 @@ static struct {
 	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
-	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN},
+	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN | BLIST_SKIP_IO_HINTS},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
-- 
2.51.0



