Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825E038A727;
	Tue, 10 Mar 2026 11:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142220; cv=none; b=cBCDGIo/semzFO3BIHQ/JD8rkIiNPHZwrjftLuZRbkmSTCNpFpK9C+tvi+ZOEmyAkTNxFuG+vT17VxEVd2nZVy1we5fw/h5uQFnNWRjLRpboPR1TCw9B8QpKuHAmDAw/1olYD+FE7zfDDUSPBU8urV3lpCC8yso4nK3Z2MTAJHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142220; c=relaxed/simple;
	bh=UtFq5Dq7gqKLTyyhQZEur7gU9BoTWkvMkigRDHPDSgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLKv2dMzGm7dW8atchS9s+aWwPRVuzYZmXDA0WgO6CNX4UASSd9MelI5qEIoeJaCEiFKw8rufeby2ok2ERmBRHS3xgp5znAsRBFXk4p6IRlKZGhsRjuDdR/8cNZpzRMBxyfaLoRGAOfzmhlHErPP8jVo9DJAFf9RDh0Z5H+eeDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pKbHc7L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pKbHc7L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5465C2BCAF;
	Tue, 10 Mar 2026 11:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142220;
	bh=UtFq5Dq7gqKLTyyhQZEur7gU9BoTWkvMkigRDHPDSgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKbHc7L/0nnLlyl3eXDxLBOXc6eT/uGmoEe3aUfTb500GekB6dyUphnhm3qTob0Sn
	 efc5iYcgrjerqbRg6W+yn/s360jB31ejshWR5P6Jv7D7eLNUSt9fy+YAiyK3JDdon+
	 itLhHM0Lpj0HFGdgGNeevYBb7vdnMNqiFv7hB3wCNPhtiMA1yI80VCOPTRJhZf5kiC
	 qHseKCV2WL57+WM40RwdI9eZ5qwYvVK8WBKveoDQV0bDX3KrB2tFtA7wQsfwkxfrhz
	 2+wjGOLFw6HiKnfQbluWcpHSTjw1yu8DfAavCIb5sMiRN9zpzEDOFTwBdsTDR7Su8K
	 IcBcfnv4wpqOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 310/314] ata: libata-eh: Fix detection of deferred qc timeouts
Date: Tue, 10 Mar 2026 07:19:29 -0400
Message-ID: <25f7f3ae5631e832086ccf11e05431797ff67794.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit ee0e6e69a772d601e152e5368a1da25d656122a8 ]

If the ata_qc_for_each_raw() loop finishes without finding a matching SCSI
command for any QC, the variable qc will hold a pointer to the last element
examined, which has the tag i == ATA_MAX_QUEUE - 1. This qc can match the
port deferred QC (ap->deferred_qc).

If that happens, the condition qc == ap->deferred_qc evaluates to true
despite the loop not breaking with a match on the SCSI command for this QC.
In that case, the error handler mistakenly intercepts a command that has
not been issued yet and that has not timed out, and thus erroneously
returning a timeout error.

Fix the problem by checking for i < ATA_MAX_QUEUE in addition to
qc == ap->deferred_qc.

The problem was found by an experimental code review agent based on
gemini-3.1-pro while reviewing backports into v6.18.y.

Assisted-by: Gemini:gemini-3.1-pro
Fixes: eddb98ad9364 ("ata: libata-eh: correctly handle deferred qc timeouts")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[cassel: modified commit log as suggested by Damien]
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index b373cceb95d23..44fddfbb76296 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -647,7 +647,7 @@ void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
 				break;
 		}
 
-		if (qc == ap->deferred_qc) {
+		if (i < ATA_MAX_QUEUE && qc == ap->deferred_qc) {
 			/*
 			 * This is a deferred command that timed out while
 			 * waiting for the command queue to drain. Since the qc
-- 
2.51.0

