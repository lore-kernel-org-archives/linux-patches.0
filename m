Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C0C78B61;
	Tue, 27 Feb 2024 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042586; cv=none; b=mugEgbKRntkRQjzyaJm0e2DW/aFJ3NiXJMgGNDnoY86TETeF6fh/5MK0/GSvhOfNNiZbLEDcY2TZNKulEQflsC2B8Ul/yrFdbSMH6mHZplU672ix0FNoLbYbNHCF7yshmdvJL3NJK2tIkFRLUPLhY4bSgD58ajIBPrty9cLNfH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042586; c=relaxed/simple;
	bh=7r/6pQkgkPAgcOhAivCoKGQ+RRFKIFbZW8es6aCd0tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTeyD2eQ6cqDfYjI/E/aASdTa5vpQNFnY5r9FyAW/V/cnmvfdbwwbwAsTm2gzeiB2JN5/dJbaAwQ87lVmJAzROkBSaN7JVLaCJt7rbubiZrd5F5yAVJUGYQDeQj81OBb698MRJqcmHrUCB53W0L+W2ARvkWeZDqvP0Zvr3pGDBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyRKwZMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyRKwZMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1E7C433C7;
	Tue, 27 Feb 2024 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042586;
	bh=7r/6pQkgkPAgcOhAivCoKGQ+RRFKIFbZW8es6aCd0tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyRKwZMiMyVesmnPQuIvK3OX0IWUfFOrok/4pyCp9dDYm+o0EnZoz3PZTygGipch7
	 oOKpqlc0bB6TgNFKfadMmaXZ3kuM9cknSdj6UxNxl7WkHcKCMvvnUKUIGtXt7scfLw
	 PbdCXcXQkAl/MRc4W8sdtE8+Z7w3HffUR/Q3iDAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/245] nvmet-fc: abort command when there is no binding
Date: Tue, 27 Feb 2024 14:23:55 +0100
Message-ID: <20240227131616.653367520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 3146345c2e9c2f661527054e402b0cfad80105a4 ]

When the target port has not active port binding, there is no point in
trying to process the command as it has to fail anyway. Instead adding
checks to all commands abort the command early.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 06d11bb7b944b..20d3013be08ab 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1101,6 +1101,9 @@ nvmet_fc_alloc_target_assoc(struct nvmet_fc_tgtport *tgtport, void *hosthandle)
 	int idx;
 	bool needrandom = true;
 
+	if (!tgtport->pe)
+		return NULL;
+
 	assoc = kzalloc(sizeof(*assoc), GFP_KERNEL);
 	if (!assoc)
 		return NULL;
@@ -2523,8 +2526,9 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport *tgtport,
 
 	fod->req.cmd = &fod->cmdiubuf.sqe;
 	fod->req.cqe = &fod->rspiubuf.cqe;
-	if (tgtport->pe)
-		fod->req.port = tgtport->pe->port;
+	if (!tgtport->pe)
+		goto transport_error;
+	fod->req.port = tgtport->pe->port;
 
 	/* clear any response payload */
 	memset(&fod->rspiubuf, 0, sizeof(fod->rspiubuf));
-- 
2.43.0



