Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA479147C6E;
	Wed, 19 Jun 2024 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803929; cv=none; b=Dpc/bLnBiS3Lbu0A0LNpvxMmPrp8sM8LDR0S2m5l8432RJDVUgjTuov9wStWzVDBMmksoG0QC9jqN1JN2FirirJMgpezEkcDrthghnTUPEVN4ZX9GoKf9FpCKxymqAbRDreRDCipWnJFAaAcQQ2uWCNSe8K9wGazP58MxxXqzdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803929; c=relaxed/simple;
	bh=pQs7wO3IaLPueFa7nC0XoL4bfoJbvppxWuYEQ7a3n4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtSl68HLvz61iOrrXqLkdqj77iQGKb1JJ4AeEC9ZKu77c0zuKWNCaFdt6L9Io2BoINAegdNJVp0JvcECHcfFn19s54GMBCWd8rqg8K4UUMJC4k9ikWJ6OWH9zLf4tuTGs5oRZuuMnjCIpt9O10cyXNujs64sA30YMiSvt+LFGg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aU7HrK92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aU7HrK92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F10DC2BBFC;
	Wed, 19 Jun 2024 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803929;
	bh=pQs7wO3IaLPueFa7nC0XoL4bfoJbvppxWuYEQ7a3n4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aU7HrK92q8jCxgdOAp9mPO4I+ptczu8nGrcJL7TN71npP6fgL1RP0T5PNQxe36jOb
	 drMfBp7T0/KNX5eSSch2vK8ghmDvBdWWRBX0RMaGYERUIPH+c+BrK+Huneun93BaYI
	 8+AtXEHr8bNGj+7R70XmB8t/OeC+O5rSDg+Blqus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/217] nvmet-passthru: propagate status from id override functions
Date: Wed, 19 Jun 2024 14:56:35 +0200
Message-ID: <20240619125602.555437363@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit d76584e53f4244dbc154bec447c3852600acc914 ]

The id override functions return a status which is not propagated to the
caller.

Fixes: c1fef73f793b ("nvmet: add passthru code to process commands")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/passthru.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index a0a292d49588c..dc756a1c9d0e3 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -226,13 +226,13 @@ static void nvmet_passthru_execute_cmd_work(struct work_struct *w)
 	    req->cmd->common.opcode == nvme_admin_identify) {
 		switch (req->cmd->identify.cns) {
 		case NVME_ID_CNS_CTRL:
-			nvmet_passthru_override_id_ctrl(req);
+			status = nvmet_passthru_override_id_ctrl(req);
 			break;
 		case NVME_ID_CNS_NS:
-			nvmet_passthru_override_id_ns(req);
+			status = nvmet_passthru_override_id_ns(req);
 			break;
 		case NVME_ID_CNS_NS_DESC_LIST:
-			nvmet_passthru_override_id_descs(req);
+			status = nvmet_passthru_override_id_descs(req);
 			break;
 		}
 	} else if (status < 0)
-- 
2.43.0



