Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9741DED49;
	Wed, 19 Feb 2025 09:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956939; cv=none; b=ajlJc0Ityd9IISygZ2rmVRhbV9+rSKSZTL5JceEpbJ5ztSUmOxu7OAACTsK5iOHxosrKKfqCc4o5Ru93yFQqOaR9ZokgHRmXoLfCHxsfWEgaFhycADh5YRytf73aIeNwZIIprZh38AWjohrv42H3CNhhp+nlqvW33WNPYhuzNwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956939; c=relaxed/simple;
	bh=CzV3v3m9/Yg2dM1zxgXu6B6fjCSOtRw96vY5A8ynuJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbACuwSwWn0nuLrN7/TTkG7SEFTUzmM6j/VRf+KnP3oFfUbg7deVBSNVJkRk33pe7racwaeqL5Ha+lGihFeHv44nPp04CGj7mepvlDwR920wKdC2EEJvBGw5/fHoqncFJTxzab4phPHaqbCbh7Mh1p74CcIGva2LayKO6kge3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW07SO6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW07SO6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA222C4CED1;
	Wed, 19 Feb 2025 09:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956939;
	bh=CzV3v3m9/Yg2dM1zxgXu6B6fjCSOtRw96vY5A8ynuJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xW07SO6j8YphEnskXQg3OLpmVRCpn8T0K0bDKaKlIv18hkDLL/8u/pzhtRUtLjKOa
	 RXUAvOw6/L3fxWc2UcCPjzYfq1QB+S5HCA/G1LTWSgExg78kLw36pfEpkWFR9JxxmH
	 91sXYx/miS+WB4cHbBwhlMo5mWDeFgVkRjLvnYqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 321/578] nvme: handle connectivity loss in nvme_set_queue_count
Date: Wed, 19 Feb 2025 09:25:25 +0100
Message-ID: <20250219082705.637555687@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

[ Upstream commit 294b2b7516fd06a8dd82e4a6118f318ec521e706 ]

When the set feature attempts fails with any NVME status code set in
nvme_set_queue_count, the function still report success. Though the
numbers of queues set to 0. This is done to support controllers in
degraded state (the admin queue is still up and running but no IO
queues).

Though there is an exception. When nvme_set_features reports an host
path error, nvme_set_queue_count should propagate this error as the
connectivity is lost, which means also the admin queue is not working
anymore.

Fixes: 9a0be7abb62f ("nvme: refactor set_queue_count")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index abca395385b2e..ba76cd3b5f852 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1609,7 +1609,13 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count)
 
 	status = nvme_set_features(ctrl, NVME_FEAT_NUM_QUEUES, q_count, NULL, 0,
 			&result);
-	if (status < 0)
+
+	/*
+	 * It's either a kernel error or the host observed a connection
+	 * lost. In either case it's not possible communicate with the
+	 * controller and thus enter the error code path.
+	 */
+	if (status < 0 || status == NVME_SC_HOST_PATH_ERROR)
 		return status;
 
 	/*
-- 
2.39.5



