Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B1B1C4603;
	Tue, 27 Aug 2024 14:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770326; cv=none; b=JZpk2xVBjEGo8wOeZSZmjs9+FSyzwCzF4GX06FyCKVgyTf0g50s0P+pIB05612vXr+sJtd2ozRHw6fap7IjO9mxGmC1NwITxR9vIoVYFty1ijNpCoXKUW7do6jieXU1QZsDl2yuIpD6y/c0Y9OxZtR6OSL5ADPIhYvMicOBdP3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770326; c=relaxed/simple;
	bh=NA89csTXMmNoWW96VpBWTZ0G3Vr/2b/Jz46GY3rwc9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N85m8PuTDOoD4BUuKcalIiGNs/DTIz4en2s9nueJ5Rnv4rafZiEhqJlit39yyQBz2NKCTOFJLfs88EkZ6LQN8HrKooBWjUu77yJ0w80/Y4PmIg71tRyjj1STtrDIz3/qKzt7S1hqNw50z5ZNQ3hyk/c6c+2Jfwme/xwhEiVtK5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDd2Fggz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDd2Fggz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0593CC4DE03;
	Tue, 27 Aug 2024 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770325;
	bh=NA89csTXMmNoWW96VpBWTZ0G3Vr/2b/Jz46GY3rwc9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDd2FggzaD8qDbI4IhYhXsVtyaWlgLN/9F086cIXY81xVEpytyZOkKIXty9IY/ybB
	 XT31SarjyWLUeUxCp6OJtTrGRBzmgxpU6s0ZvnhM6rwHuHSUMqCPRcMC/AeKVLSNXn
	 uIubwIJlvkIJbR8vsEixmd0HrIZuEEXtUcriE0vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/341] nvme: clear caller pointer on identify failure
Date: Tue, 27 Aug 2024 16:37:07 +0200
Message-ID: <20240827143850.870024434@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

[ Upstream commit 7e80eb792bd7377a20f204943ac31c77d859be89 ]

The memory allocated for the identification is freed on failure. Set
it to NULL so the caller doesn't have a pointer to that freed address.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e969da0a681b4..4e39a58a00458 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1313,8 +1313,10 @@ static int nvme_identify_ctrl(struct nvme_ctrl *dev, struct nvme_id_ctrl **id)
 
 	error = nvme_submit_sync_cmd(dev->admin_q, &c, *id,
 			sizeof(struct nvme_id_ctrl));
-	if (error)
+	if (error) {
 		kfree(*id);
+		*id = NULL;
+	}
 	return error;
 }
 
@@ -1443,6 +1445,7 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (error) {
 		dev_warn(ctrl->device, "Identify namespace failed (%d)\n", error);
 		kfree(*id);
+		*id = NULL;
 	}
 	return error;
 }
-- 
2.43.0



