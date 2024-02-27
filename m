Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAAC1420A6;
	Tue, 27 Feb 2024 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041788; cv=none; b=aJfBbnrbHr4lMzzCShBK1bz+sZFpoL72gvolab7Wdl/4ZPsIz/oAIkRnzt+4bdNbAmNbwsLq2DkUoePfUXIDrYrXZl2ws9u4MGLL/lxCjx/fU/NFYeDpREkxplzgg5j6KEe6vS4JrTUWd64Co8hRfXBhW2EKvEXQSBBgAaMUDgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041788; c=relaxed/simple;
	bh=Q3+Pg1TU13/JopCQs6hLqikvOAqUrmfP9unEetKWTVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdEvlZN2pmoXZQPdGqvWJLnjI1An1RQ9lB+bXZfzaV8eBN/B/n3C80uxWy52mvn8Enmw8JTHvmycBI7//ZhOnPA65XVey1WDHEL3hW41glvqdTR9UpKsy8r2b27BQ+Jewdh3y83/JT/ymzmIrADwdUcs88NBOuNTGRagVCJQyZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haS/EuJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haS/EuJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC869C433F1;
	Tue, 27 Feb 2024 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041788;
	bh=Q3+Pg1TU13/JopCQs6hLqikvOAqUrmfP9unEetKWTVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haS/EuJGE0Ni+3tazNHpki9R1gqpqwC3myDGvk8BSOsSGH24x+y+oO5ZdowVWNrJl
	 Ru/3bktLg/IrvmYaQRVLiX5k/CZxbrStVS4DDj/25qpdut++yGSA7LA1PmFLZnaVdL
	 9GDzxRqaysswU/drfWfKrFcPhoWp4m1+q+R9imm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/299] nvmet-fc: hold reference on hostport match
Date: Tue, 27 Feb 2024 14:22:53 +0100
Message-ID: <20240227131627.949960822@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit ca121a0f7515591dba0eb5532bfa7ace4dc153ce ]

The hostport data structure is shared between the association, this why
we keep track of the users via a refcount. So we should not decrement
the refcount on a match and free the hostport several times.

Reported by KASAN.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index c9ef642313c8f..64c26b703860c 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1069,8 +1069,6 @@ nvmet_fc_alloc_hostport(struct nvmet_fc_tgtport *tgtport, void *hosthandle)
 		/* new allocation not needed */
 		kfree(newhost);
 		newhost = match;
-		/* no new allocation - release reference */
-		nvmet_fc_tgtport_put(tgtport);
 	} else {
 		newhost->tgtport = tgtport;
 		newhost->hosthandle = hosthandle;
-- 
2.43.0



