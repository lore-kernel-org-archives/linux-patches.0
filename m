Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5F918E02A;
	Fri,  7 Aug 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116193; cv=none; b=kiDTJ+SkF4J82hUGwlFWVK3CYMog9Z15rurouHeZOnPbjpCnmXVu7oZ7h6BhGJteL0uUZVEsDiRDEng901/Yt7WF3aiLUdMY6nUgo7/876gOA250Ly1cURJg51i5TnMn1Ro3wPaYaB3OB/MxmjncEP9NzcDzIIdbDGlPgJoVdQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116193; c=relaxed/simple;
	bh=UhIIKRSoOuE0LhLrYW5NcOBwqhkh2YsPsxthCFOhvZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+EIgHJUZg5Uj7Tzv60nYMJKunJVKlZkpyyag/IXKOmYdiIIXTKb7UM4aC8lwko/II/zkV5LRDcaTy1eq8qWRaFenE4zPLw/DxSXGOEHq1NKBjylIxfPz5ImvBaD8KkZZrjgB1oKyyD9Di/HsElvHh52/wF6Qqb7H5bBza75Dbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPZZak2o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPZZak2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F2C1F000E9;
	Fri,  7 Aug 2026 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116192;
	bh=0PEfZyTg3P9+pBRkqSqO7VyFUwjU6ZNaao+UKC/BS84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPZZak2oovgjM4/hQF2XiyRHIYDfyA+3+OtQzmVrtidoiKTdjoukH0PlQ9K9H8of7
	 sH0g8ftYgeA1e/Ns+zPbtYlcku5uxaIXu8uckXdg7aaJKxbDtWAC8HgLOF47T/ZKNA
	 ysOGH6dqn79g4w2DfIzob+flq+oAv+Cv8YRRG+D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 144/261] scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write
Date: Fri,  7 Aug 2026 16:38:21 +0200
Message-ID: <20260807143418.472374538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

commit 93dde0bf2f39a0f9f57fd610aa3201ce5b753433 upstream.

resp_report_zones() sizes the reply buffer from the CDB allocation
length. The v3 fix rounds alloc_len up with ALIGN() before deriving the
descriptor count:

	rep_max_zones = (ALIGN((u64)alloc_len, RZONES_DESC_HD) -
			 RZONES_DESC_HD) >> ilog2(RZONES_DESC_HD);
	arr_len = (u64)RZONES_DESC_HD * (rep_max_zones + 1);

For alloc_len in 0xFFFFFFC1..0xFFFFFFFF, ALIGN() rounds up to
0x100000000, so arr_len is 4 GB. On 32-bit, kzalloc()'s size_t is 32-bit
and truncates 0x100000000 to 0; kzalloc(0) returns ZERO_SIZE_PTR, which
passes the !arr check, and desc = arr + 64 is then dereferenced in the
loop -> out-of-bounds write / panic.

Clamp rep_max_zones to devip->nr_zones. The loop already stops at
sdebug_capacity (after nr_zones zones), so a report can never hold more
than nr_zones descriptors; the clamp does not change the report, it only
bounds arr_len to (nr_zones + 1) * RZONES_DESC_HD, a real device
property that can never reach 0x100000000.

Fixes: 7db0e0c8190a ("scsi: scsi_debug: Fix buffer size of REPORT ZONES command")
Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260712183739.83915-1-security@auditcode.ai
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4469,6 +4469,7 @@ static int resp_report_zones(struct scsi
 	u32 alloc_len, rep_opts, rep_len;
 	bool partial;
 	u64 lba, zs_lba;
+	u64 arr_len;
 	u8 *arr = NULL, *desc;
 	u8 *cmd = scp->cmnd;
 	struct sdeb_zone_state *zsp = NULL;
@@ -4490,9 +4491,12 @@ static int resp_report_zones(struct scsi
 		return check_condition_result;
 	}
 
-	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
+	rep_max_zones = (ALIGN((u64)alloc_len, RZONES_DESC_HD) - RZONES_DESC_HD) >>
+			ilog2(RZONES_DESC_HD);
+	rep_max_zones = min_t(unsigned int, rep_max_zones, devip->nr_zones);
+	arr_len = (u64)RZONES_DESC_HD * (rep_max_zones + 1);
 
-	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
+	arr = kzalloc(arr_len, GFP_ATOMIC | __GFP_NOWARN);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);


