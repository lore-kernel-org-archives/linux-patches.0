Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB210211A0B;
	Tue, 29 Apr 2025 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946424; cv=none; b=cGiYM16gOt8N2ThcLAEKovTy01mF9qi8iXWcqLYju/4b/OBykQuiVOsoe1BzidtOWquEOEbEbyY7+KR+UNGQgKES4xuor63JhufbUlf/gcM+B0loc47U1ceC1bXG6ggQ/F5QUBaBSBliWO9Y7InkzSB0MnGOzvs/gPJVHHWDxVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946424; c=relaxed/simple;
	bh=1OPrn4Ug/OJdeo7wdyVPX/PW0D4XyDH1EBbouYKNiCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkMcbPt/VS7wydqTclHNwr2PiL630cpSvr+eEtEHtkjGb3RNyAG32PtehVA9ydYk8yhxFHCejD93/WogRDUfObHAetazcDijV4VbcFrfpKjObGeYOfhgp+mp6suHEHPiPz47NTuJSU3XwjP8WO14GjDdgLK+nagYxtQkn8IyqGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6HB379T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6HB379T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EA5C4CEE3;
	Tue, 29 Apr 2025 17:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946424;
	bh=1OPrn4Ug/OJdeo7wdyVPX/PW0D4XyDH1EBbouYKNiCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6HB379Tt3DuiX6ygEG9CH/vfHKcvmmyntszTvVPsHuB/oldtaT3mPaBpzY2nyIrX
	 QSU8EjDxbA3niIv8kxnncdBS7b8l7+iLStsWyeslXlJnBRe4bOramLh1DT4vOQhYC1
	 c86iNluCYWgUo+j3d6iJEkQKIochi+j21TNdAwm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 263/311] nvmet-fc: put ref when assoc->del_work is already scheduled
Date: Tue, 29 Apr 2025 18:41:40 +0200
Message-ID: <20250429161131.803930799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 70289ae5cac4d3a39575405aaf63330486cea030 ]

Do not leak the tgtport reference when the work is already scheduled.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 78c4a417f477e..ef8c5961e10c8 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1089,7 +1089,8 @@ static void
 nvmet_fc_schedule_delete_assoc(struct nvmet_fc_tgt_assoc *assoc)
 {
 	nvmet_fc_tgtport_get(assoc->tgtport);
-	queue_work(nvmet_wq, &assoc->del_work);
+	if (!queue_work(nvmet_wq, &assoc->del_work))
+		nvmet_fc_tgtport_put(assoc->tgtport);
 }
 
 static bool
-- 
2.39.5



