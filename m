Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9354313B797;
	Tue, 27 Feb 2024 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043760; cv=none; b=sfVZF6UIF0r/z+f4aMgzTVOP4uRuyRzwSPpZShdMo/vVmL+zpF7MLbEqR2strKcY9hrkH1h61ZPQ2SOqZ8t5PBclfkGzS92k7qo3csfq3NdYlP19DpYhasg2cL4PW7hFYVPwimkAywk+V2zEYbYEnLg3AgCfwiqUST7PhnmbSa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043760; c=relaxed/simple;
	bh=/WIJ8FhqHNsECblKZZqA8MQ4RNOQjxYQj+/odPX9gx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePwtIcCKDnkJitSZVzqc7eGYSvCu6FG7vD1v6JlKJjmOcn6qqO+sJ8FCG3jhdXiOI91Q98/TyU706v4oFh9ym3dXGDmQZ0rQ03FLGbOhha5NTbc4jQt3/NWY3ceZBkNIjjOC0yClOjQk9Ycocoaky5YZ+5j5R/x2d64APMEn/Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eI5ZVyhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eI5ZVyhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113A1C433F1;
	Tue, 27 Feb 2024 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043760;
	bh=/WIJ8FhqHNsECblKZZqA8MQ4RNOQjxYQj+/odPX9gx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eI5ZVyhzYgTVKQ0VbXIWM04Xa0TRq6XHIEDGsM0jA5xOZKe1uaGI5RbcB/jk6W3Ao
	 sjD9mbajtQqUftiZ7pBB+oWeW+MpvfvWWh49stG7+/j9yE2PhyCagnJ7M8L5ZZk7C7
	 PP0Crup/RPZVbt2CMUi4oNRQtVpU85+3qZcQxosA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/84] nvmet-fc: abort command when there is no binding
Date: Tue, 27 Feb 2024 14:26:54 +0100
Message-ID: <20240227131553.748115378@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f74fc6481731d..2dd39299fba07 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -796,6 +796,9 @@ nvmet_fc_alloc_target_assoc(struct nvmet_fc_tgtport *tgtport)
 	int idx;
 	bool needrandom = true;
 
+	if (!tgtport->pe)
+		return NULL;
+
 	assoc = kzalloc(sizeof(*assoc), GFP_KERNEL);
 	if (!assoc)
 		return NULL;
@@ -2180,8 +2183,9 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport *tgtport,
 
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



