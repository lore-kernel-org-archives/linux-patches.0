Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF992AE96;
	Tue, 29 Apr 2025 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949544; cv=none; b=UXzD2T1Ji9IvCWcFDxxWCrJ2uH6JF+BABMPKDnT6PDqmzUp2rf6byZWTwYMFBORhaQzZMyrmpHToQgwC23QzwkDdpJCfR8OsHbFwTsRC+z+hPNe8rWdAnotk686bw4d3/Om4b92BeBC19Rl3UPpg4ruMWZOaMa3D/7xRrjqcyUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949544; c=relaxed/simple;
	bh=6wHuK2xMAiSNUu+WSfuCu25SVDQzxJRpjjb9Ywn0QpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P14nj/o9bVCWZYiQNkqzt60xT9f5g778veQLHtStvqumoG2VlmQiwMhddCcYc0cI8KYq8Q/dK3nZ7ItHPy0WuRw9hywLXE1ypotF7BfajeT1I0mZ7Q599cgP850MdUIVu45IAdZVvm/w74lml2S8OUdD89kDS/nRoPm/DqZ8j4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nU9NNgaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nU9NNgaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E6DC4CEE3;
	Tue, 29 Apr 2025 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949544;
	bh=6wHuK2xMAiSNUu+WSfuCu25SVDQzxJRpjjb9Ywn0QpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nU9NNgaVea54/tJvDewUIbA5EzaSV6mTtC+yZ020a0FKeOfx/NpSevbUdbAU53gZO
	 oQ6VuJpPO5Xcb8KJYxMKwDOsfaVLKko8+MPpWMUSUKSfOTtin7Hnsll2G5DP4H5zp4
	 HqEGqYsTHAUjhOMUHbQhTLcuWZRLHReFqlfX1etQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/373] nvmet-fc: put ref when assoc->del_work is already scheduled
Date: Tue, 29 Apr 2025 18:43:50 +0200
Message-ID: <20250429161137.653323923@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9f6d91e79aac5..812d085d49c99 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1091,7 +1091,8 @@ static void
 nvmet_fc_schedule_delete_assoc(struct nvmet_fc_tgt_assoc *assoc)
 {
 	nvmet_fc_tgtport_get(assoc->tgtport);
-	queue_work(nvmet_wq, &assoc->del_work);
+	if (!queue_work(nvmet_wq, &assoc->del_work))
+		nvmet_fc_tgtport_put(assoc->tgtport);
 }
 
 static struct nvmet_fc_tgt_assoc *
-- 
2.39.5



