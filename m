Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C4F14A615;
	Wed, 19 Jun 2024 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803287; cv=none; b=XTiQkkDvdHwMfkVQ39gVmpXWQhy4I5F1C21kjTwqhHwYoxDLkHT9d8QwZn8UI+DiPZXauFRDVorIC8qlqwDcYaHO2D9M9PHn2ElrA5PeCZr3IsYIS/CONyTLL+TNWsjM7IjUf3IA6avgpvl+kAuZC0Ef5Wt9zac52P0Fe2TReGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803287; c=relaxed/simple;
	bh=RqHK9fXWnqippMKr6PKp/TfrktAHaWvVM7gY0EKWcOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqHBwVR1Gof5ONOH8z2D4kc7XgCb8+0j0sG/ODI6Tetal0NvX/qblt5HfiM9B1A7R0vWa7j2HiVtPnEcrf8IOVG4V1PBvuK/TrSLH6JI3pksYEL8/Tj0FvM3o+V5kscZyPG5QSYjSl36ni9F95lwBIaHP+BQFLXdOFUvMoAoma0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a66qr5K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a66qr5K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB7AC2BBFC;
	Wed, 19 Jun 2024 13:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803287;
	bh=RqHK9fXWnqippMKr6PKp/TfrktAHaWvVM7gY0EKWcOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a66qr5K9D3hhH7uy2rhb+H/KFZkn35nvQKA50F5/3ZH8ILImx55gtJnPKhMesOgQy
	 grjPYqTcElpYOIX2i9j77HXfz6LbY3lsc4INX96Tzj3be/mPzkSDFA7HA2YOMJpXfz
	 2+6PeBFtISGvbQIrGaRNyq2TY/zNTTypZUqBgunQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 175/281] nvmet-passthru: propagate status from id override functions
Date: Wed, 19 Jun 2024 14:55:34 +0200
Message-ID: <20240619125616.569796903@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index bb4a69d538fd1..f003782d4ecff 100644
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



