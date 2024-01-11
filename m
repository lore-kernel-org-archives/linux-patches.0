Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849E11C85;
	Thu, 11 Jan 2024 09:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcp3ihgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5C8C433C7;
	Thu, 11 Jan 2024 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704966794;
	bh=hwOANLt9Z+Q6kE53fsNbScRnc5R21w0RdMj3JWLafSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcp3ihgzgA6/mXfyEFNa+daB6wP13tkIe1tYIjqWfSSQZKFZ5TPeZ1ZgL16gPa74O
	 cWU8+u9x1GRSRvw35g9e+IJeWMwu0Y8Wvut2GgFaX6qABC9oGN4fwabhsaRp2mrf16
	 tt1ucIFCX+ydyyuCnKH1SWPwxXB4C9S2AXrvEkxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@ucw.cz>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Benjamin Block <bblock@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 4/7] Revert "scsi: core: Make scsi_get_lba() return the LBA"
Date: Thu, 11 Jan 2024 10:52:53 +0100
Message-ID: <20240111094700.436389071@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240111094700.222742213@linuxfoundation.org>
References: <20240111094700.222742213@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit d054858a9c9e4406099e61fe00c93516f9b4c169 which is
commit d2c945f01d233085fedc9e3cf7ec180eaa2b7a85 upstream.

As reported, a lot of scsi changes were made just to resolve a 2 line
patch, so let's revert them all and then manually fix up the 2 line
fixup so that things are simpler and potential abi changes are not an
issue.

Link: https://lore.kernel.org/r/ZZ042FejzwMM5vDW@duo.ucw.cz
Reported-by: Pavel Machek <pavel@ucw.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Benjamin Block <bblock@linux.ibm.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/scsi/scsi_cmnd.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -229,13 +229,6 @@ static inline sector_t scsi_get_sector(s
 	return blk_rq_pos(scmd->request);
 }
 
-static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
-{
-	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
-
-	return blk_rq_pos(scmd->request) >> shift;
-}
-
 /*
  * The operations below are hints that tell the controller driver how
  * to handle I/Os with DIF or similar types of protection information.
@@ -298,6 +291,11 @@ static inline unsigned char scsi_get_pro
 	return scmd->prot_type;
 }
 
+static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
+{
+	return blk_rq_pos(scmd->request);
+}
+
 static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
 {
 	struct request *rq = blk_mq_rq_from_pdu(scmd);


