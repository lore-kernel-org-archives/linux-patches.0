Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2072E33372A;
	Thu, 28 May 2026 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000963; cv=none; b=PQCLzVQJY4bVjXcMB5xxaZna2HWjC2zX2UsJKcplS/KO8pUrkZqezMPs2F1OuFNGmcSQOagIS7I+U1mxuFkcxpyDMWRlc1hoW28K9Y2HYHGK9pEoYVyClWx8vfwKUpQsHi0QbJukQ55kMpUhF7n4elcNEAMlW8PX39Ue0OM5wCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000963; c=relaxed/simple;
	bh=bFn4uqRRNXcqNcTSi7xJpWBlsc1eUxRYZbhoo4QStTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da6W1YidAT5jqzhr3XXIXND48VjyO8VYKKU9BJIDpbxpwe5ofNugslzuZAVPejz5nec8If23EWBUyOIEocd7yks0t3ghBkJcg+MiPlOYETLdvxYguj04kUsuuGL+uQcmaZxI80iWt+ZfdDC+MsEDcL3DwQEbt60UtecoHu3Qdcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azaDYFPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azaDYFPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E13B1F000E9;
	Thu, 28 May 2026 20:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000962;
	bh=0uKm+B4uqp0vMpjfrjlN5R/QryMkXbwm0VlzXxWdr4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azaDYFPxzRxZCrU8C70sOpAOiopjTtc8GhJD9RFF0p0SpuxkkfmVndtqRMH/PnkHi
	 34sgVv2znFDuqAatSKbK1z9LEzOhrEI8oPpwjE3inIInfZ1MWy9Ge7OcTyKOARoSYa
	 IUEa6pGEmIRtvtwNazcPm+HSWOGYq0Q/ht1wrp7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/272] scsi: sd: Fix return code handling in sd_spinup_disk()
Date: Thu, 28 May 2026 21:50:05 +0200
Message-ID: <20260528194635.639412100@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 6ea68a8dc7d2711504d944811981a5304af7d7a9 ]

As found by smatch-ci, scsi_execute_cmd() can return negative or positve
values so we should use a int instead of unsigned int.

Fixes: b4d0c33a32c3 ("scsi: sd: Fix sshdr use in sd_spinup_disk")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/agFbI7E6JQwd3wGW@stanley.mountain/T/#u
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260511175317.114007-1-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f37f031971dfd..ab5cf8460aca5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2392,8 +2392,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 {
 	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int spintime, sense_valid = 0;
-	unsigned int the_result;
+	int the_result, spintime, sense_valid = 0;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
-- 
2.53.0



