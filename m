Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F8C3793CE;
	Thu, 20 Aug 2026 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244527; cv=none; b=svfADU8EO36gOyWL9ycWet3EdS9z+pFjLoXpP2YdDlmE8L+eO+3zLxh8JjF6Nl5EL4bJT3sVkOeLOqHq5fKE7dztDKtu7d9nXsDvNgLRUpboU8Dypz9LNLCQkRcw3qY6egV62Lad+JSNjOWXAmiwOhAb9MX8v/tWhb/imPLGeHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244527; c=relaxed/simple;
	bh=Zwe+SJ/jAJ8SMy0Z4RQ/VlpZXUF0v9ZBve/1YMqdAOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VT0U/DLBrUanVSRjmvi08bcbLAXr8Wvekko7JXr0j9qex77OgN/I67MBp0jEv+bnvdi064eOOTjY4IJNBv7Ma5KfMSVEIx+wuxhswzm47YvStI+bnB/OoyndSYZ6+LJZztqFO+KfKth4ffrqlf3VdaGaLk6XzlCOKrDqiDZNuok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJJYpHx0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJJYpHx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3940F1F000E9;
	Thu, 20 Aug 2026 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244525;
	bh=ha4nIBYsLIHIk9V7j8Vr6NX70lPhGajAIo4g+tjnIfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJJYpHx0wlvBIjEkRqYhzF0GFfgkkmvmnsClPXpySmsO2++839lz6fGXKhff20nxW
	 IPJTFG3pDdAJ1fibad4XwUPuTvdlDMErfZP5rG8++/ks1Pq7+p+K+kzPp7OzHROsN3
	 P6jPO1QykMfqXiCFzTOPzlwjNtMTiMwouq/y/Cds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 199/235] scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write
Date: Thu, 20 Aug 2026 16:57:15 +0200
Message-ID: <20260820145222.587425877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ibrahim Hashimov <security@auditcode.ai>

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
[ Adjusted for 5.10: resp_report_zones() here predates commit 4a5fc1c6d752
  ("scsi: scsi_debug: Add gap zone support"), so it still computes

	max_zones = devip->nr_zones - (zs_lba >> devip->zsize_shift);

  and bounds the descriptor loop with it. Keep that existing, tighter
  clamp instead of introducing a second one against devip->nr_zones:
  max_zones is by construction <= devip->nr_zones and is the actual
  number of descriptors the loop can emit, so it satisfies the upstream
  requirement that arr_len be bounded by a real device property while
  leaving the reported zone list unchanged.

  Without the fix 5.10 has the same class of bug from the other end of
  the range: for alloc_len in 1..63 the unsigned (alloc_len - 64)
  underflows, kzalloc(alloc_len) returns a sub-64-byte buffer, and both
  the report header at arr + 0 and desc = arr + 64 are written out of
  bounds. Sizing the allocation from rep_max_zones rather than from
  alloc_len fixes that too. ]
(cherry picked from commit 93dde0bf2f39a0f9f57fd610aa3201ce5b753433)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debug.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4320,6 +4320,7 @@ static int resp_report_zones(struct scsi
 	u32 alloc_len, rep_opts, rep_len;
 	bool partial;
 	u64 lba, zs_lba;
+	u64 arr_len;
 	u8 *arr = NULL, *desc;
 	u8 *cmd = scp->cmnd;
 	struct sdeb_zone_state *zsp;
@@ -4343,10 +4344,12 @@ static int resp_report_zones(struct scsi
 	}
 
 	max_zones = devip->nr_zones - (zs_lba >> devip->zsize_shift);
-	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
-			    max_zones);
+	rep_max_zones = (ALIGN((u64)alloc_len, RZONES_DESC_HD) - RZONES_DESC_HD) >>
+			ilog2(RZONES_DESC_HD);
+	rep_max_zones = min_t(unsigned int, rep_max_zones, max_zones);
+	arr_len = (u64)RZONES_DESC_HD * (rep_max_zones + 1);
 
-	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
+	arr = kzalloc(arr_len, GFP_ATOMIC | __GFP_NOWARN);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);


