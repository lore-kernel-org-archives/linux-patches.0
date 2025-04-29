Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1520540C03;
	Tue, 29 Apr 2025 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950037; cv=none; b=nPMz0Qxmxh2eqwULNN/v1AeF7dhs9OkMm5WyoClVFPj99bmYLgsvwePeoZ4pn2zo2C5YKn99FRPT7UqO30OkayA/fYVZC/Ry/1Kl1OXvY8/MeJmcKJdZeOqgXoEaQuIqbmohJyqh+2zuizfHvKvaiaJTwH2tro3sleL00NUVi9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950037; c=relaxed/simple;
	bh=2f2BFX0ix6FYTAjaHFLSpPt2UGs3zlou4/dHcTY0zxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDeeMLg1sTPpMEM6pVdgn1+fJoJaZi4wPpveo+gTOWJ2T0/DyVmFwmxbPf4/Si+orUn0EW8QvGDtB5cbridWjqjmDoRNqS0oS9SxBo8fc6eT1nNsA7pe8KPCMxJUoSao/LEDGVodBRYP5JmtOxPIIUq43j4pcLM6RnQGmYkJiCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UELRJItz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UELRJItz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78838C4CEE3;
	Tue, 29 Apr 2025 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950037;
	bh=2f2BFX0ix6FYTAjaHFLSpPt2UGs3zlou4/dHcTY0zxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UELRJItzKEExkGIUb5vj5m4p5C5sDXKx3ZG2fGAzLLfJs0vnU3hoDG0i9JGoj6yeJ
	 pyfEhYqyMHJQz4r85jIKdIy+BL1BtTS8LeQcSuR/W8dZgYnUGW75Adx50y01QKyZIS
	 1ZDM4A8XLznaNVgtr6s58G9MLnL3A1SbEk+rFhQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/167] nvmet-fc: take tgtport reference only once
Date: Tue, 29 Apr 2025 18:44:05 +0200
Message-ID: <20250429161057.272460283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit b0b26ad0e1943de25ce82a7e5af3574f31b1cf99 ]

The reference counting code can be simplified. Instead taking a tgtport
refrerence at the beginning of nvmet_fc_alloc_hostport and put it back
if not a new hostport object is allocated, only take it when a new
hostport object is allocated.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index d40d5a4ea932e..68ff9540e2d13 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1030,33 +1030,24 @@ nvmet_fc_alloc_hostport(struct nvmet_fc_tgtport *tgtport, void *hosthandle)
 	struct nvmet_fc_hostport *newhost, *match = NULL;
 	unsigned long flags;
 
+	/*
+	 * Caller holds a reference on tgtport.
+	 */
+
 	/* if LLDD not implemented, leave as NULL */
 	if (!hosthandle)
 		return NULL;
 
-	/*
-	 * take reference for what will be the newly allocated hostport if
-	 * we end up using a new allocation
-	 */
-	if (!nvmet_fc_tgtport_get(tgtport))
-		return ERR_PTR(-EINVAL);
-
 	spin_lock_irqsave(&tgtport->lock, flags);
 	match = nvmet_fc_match_hostport(tgtport, hosthandle);
 	spin_unlock_irqrestore(&tgtport->lock, flags);
 
-	if (match) {
-		/* no new allocation - release reference */
-		nvmet_fc_tgtport_put(tgtport);
+	if (match)
 		return match;
-	}
 
 	newhost = kzalloc(sizeof(*newhost), GFP_KERNEL);
-	if (!newhost) {
-		/* no new allocation - release reference */
-		nvmet_fc_tgtport_put(tgtport);
+	if (!newhost)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	spin_lock_irqsave(&tgtport->lock, flags);
 	match = nvmet_fc_match_hostport(tgtport, hosthandle);
@@ -1065,6 +1056,7 @@ nvmet_fc_alloc_hostport(struct nvmet_fc_tgtport *tgtport, void *hosthandle)
 		kfree(newhost);
 		newhost = match;
 	} else {
+		nvmet_fc_tgtport_get(tgtport);
 		newhost->tgtport = tgtport;
 		newhost->hosthandle = hosthandle;
 		INIT_LIST_HEAD(&newhost->host_list);
-- 
2.39.5



