Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB925F783;
	Tue, 11 Mar 2025 15:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705652; cv=none; b=AVC1DYM2MCziuerUkQ9GQbxQUE8OOAzPJJDluZVntOQ645toX7nDzmJrvIhA4w6CM1Gbac+VFmlZ0b8pCmHzCvk8xfoCfHT5/GYjphovAruZYmVu9C5+jjIBBgHYNC7pD2BrO2bfEXfPCXO5Wz5ox+bEkOOwwHjkanznOD6G1Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705652; c=relaxed/simple;
	bh=uddGBTqsGf5EPcuKJpP0Bx3M9U6BACxe8CjTd0qJIeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJpZqj73qKqKBAJk9WjGmW7bhtMsxYDMR/HdTs5KcsA9UP4M5933W1ifBTidg2A9Fc1QgyzuiddIPEqLEMq0ZdEzVOHmvAMf2amtOE1sImJnQVGBhKXzueH1O4+abtnCUMzuDTmz1Nq2yTqfMUJSOMPN/+R02TMy/GIdy0OShWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1s/bvwYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1s/bvwYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B098FC4CEE9;
	Tue, 11 Mar 2025 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705652;
	bh=uddGBTqsGf5EPcuKJpP0Bx3M9U6BACxe8CjTd0qJIeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1s/bvwYgVrMMKZEl+akSlOT/6BjISMsePECyA03VPCju7lnBjjGslFsrA4AI5AXSU
	 3tiNoxMryqx8PtyKRP35z1BmAqcxYfaxiJasez7epCr39kSXQZjjHMmU91jixuYZ4U
	 pB5fF5QB+v+zfgbG/SHQX9bKsNn4TgWN4OMAjPf0=
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
Subject: [PATCH 5.4 109/328] nvme: handle connectivity loss in nvme_set_queue_count
Date: Tue, 11 Mar 2025 15:57:59 +0100
Message-ID: <20250311145719.229137968@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a841fd4929adc..dd4b99ea956ac 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1251,7 +1251,13 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count)
 
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



