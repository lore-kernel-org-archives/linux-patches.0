Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4793123754;
	Thu, 18 Jan 2024 10:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575224; cv=none; b=jZI2Esy/0s1Brb31foSALLxm+GOiL7hM9rzY0MJxeO/Q8XXlXc7FCWfhk+X7U9i+4T3n4PrnKqrkVv7qmszwGhp9nMjn9XVnTlc8k4YEJddyPVchZKVBgAHHf0dBYiZJXpo5o4I6tOLVUQJvW3ARw/zXV7nHYYGoScA+S1pqXe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575224; c=relaxed/simple;
	bh=nb5JHRAHc/rVVPvKK2KAiAJenlp4O60Arc5TBrngN6o=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Gx2mgZH6p0uAt4KJJUxhD/uMRd1G1hb0RSnK4/KeGixrmUapDZPiJR+L9mrtIOkTzVO6h3bldITd7muBHsA+4zIARl05b7O0wiktLuZ4XsquCb+5E1+3DjLPd4mlyOw0rWCHK3pwIMFFqzotc6bJun6FvznwSGBH6v7+SXsDtVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cu4tD01X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cu4tD01X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C080BC43390;
	Thu, 18 Jan 2024 10:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575224;
	bh=nb5JHRAHc/rVVPvKK2KAiAJenlp4O60Arc5TBrngN6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cu4tD01XL9sdy55Ohvlajyc1mCZE2ofq/eqbBH3Bw148drT/36WeqSS+beCJr88/J
	 NlFVl3pGYDsu98ZbMdmHOjDtn/FGU5IBl3ogfZFe/LC9Y8rA8jnYixxQMH9r4J8fXV
	 EBNx6BIYKOBU8QMTP4IVG+her60ocqAVKxBRQy3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/150] nvme-ioctl: move capable() admin check to the end
Date: Thu, 18 Jan 2024 11:47:57 +0100
Message-ID: <20240118104322.524887807@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 7be866b1cf0bf1dfa74480fe8097daeceda68622 ]

This can be an expensive call on some kernel configs. Move it to the end
after checking the cheaper ways to determine if the command is allowed.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 529b9954d2b8..4939ed35638f 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -18,15 +18,12 @@ static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
 {
 	u32 effects;
 
-	if (capable(CAP_SYS_ADMIN))
-		return true;
-
 	/*
 	 * Do not allow unprivileged passthrough on partitions, as that allows an
 	 * escape from the containment of the partition.
 	 */
 	if (flags & NVME_IOCTL_PARTITION)
-		return false;
+		goto admin;
 
 	/*
 	 * Do not allow unprivileged processes to send vendor specific or fabrics
@@ -34,7 +31,7 @@ static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
 	 */
 	if (c->common.opcode >= nvme_cmd_vendor_start ||
 	    c->common.opcode == nvme_fabrics_command)
-		return false;
+		goto admin;
 
 	/*
 	 * Do not allow unprivileged passthrough of admin commands except
@@ -53,7 +50,7 @@ static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
 				return true;
 			}
 		}
-		return false;
+		goto admin;
 	}
 
 	/*
@@ -63,7 +60,7 @@ static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
 	 */
 	effects = nvme_command_effects(ns->ctrl, ns, c->common.opcode);
 	if (!(effects & NVME_CMD_EFFECTS_CSUPP))
-		return false;
+		goto admin;
 
 	/*
 	 * Don't allow passthrough for command that have intrusive (or unknown)
@@ -72,16 +69,20 @@ static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
 	if (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC |
 			NVME_CMD_EFFECTS_UUID_SEL |
 			NVME_CMD_EFFECTS_SCOPE_MASK))
-		return false;
+		goto admin;
 
 	/*
 	 * Only allow I/O commands that transfer data to the controller or that
 	 * change the logical block contents if the file descriptor is open for
 	 * writing.
 	 */
-	if (nvme_is_write(c) || (effects & NVME_CMD_EFFECTS_LBCC))
-		return open_for_write;
+	if ((nvme_is_write(c) || (effects & NVME_CMD_EFFECTS_LBCC)) &&
+	    !open_for_write)
+		goto admin;
+
 	return true;
+admin:
+	return capable(CAP_SYS_ADMIN);
 }
 
 /*
-- 
2.43.0



