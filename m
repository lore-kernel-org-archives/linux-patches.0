Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A382B9C7;
	Sun,  1 Sep 2024 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208967; cv=none; b=iy76Z9ykuVqIjA/FujCkYjqDeXuisQBnWTFo8Dmvfx4VfL3RV+zAOWatxG49oW/Da7NMnGA7XJSryRr2SvP+hqu8LblvVQBMGcwFpKbG8hsuigyU7CKMm6fMJY3IGYhHXKpjajb8Dj8lAD/bgNbEuIp9GBG/mGbdF9/ewbPOcV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208967; c=relaxed/simple;
	bh=Q199uq/rq31Pw7eFbD3yIT5mU+dDzi8xf4OX1mVdRUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVToMAEIB/Dthxg8qYBJaVhHdZrj0CIKW8AHqEvxqJ4XAilu2I/FQYiuVnbpBZCSdxQfBeh4n9oT9L7snJOLYFw7ezZrEOxQd3C9b3Ljg8rEPaQB9KvPYyMGsBEwMXIwSmr9h/1L9mpbWXnXtoCTNO9D60kLct+Vun/OFAewYVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1pmVvUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1pmVvUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6990FC4CEC3;
	Sun,  1 Sep 2024 16:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208966;
	bh=Q199uq/rq31Pw7eFbD3yIT5mU+dDzi8xf4OX1mVdRUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1pmVvUqB65IWt54ZMhmII3Wo0dbJNtXcnoEHccYgaOp7XnagApIHICjX6DMIgYB4
	 svUbG3A6CtbCVJvLNp1u5Dxq5BvHBiMuv83XWNT5PzWAPrC47TQtC+jlChXGwCiirq
	 mJ8ad4ZYmpf/20NOHYczWlWXCvRdF0CraopKI85U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/134] nvme: clear caller pointer on identify failure
Date: Sun,  1 Sep 2024 18:16:48 +0200
Message-ID: <20240901160812.437428299@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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
index 9144ed14b0741..0676637e1eab6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1080,8 +1080,10 @@ static int nvme_identify_ctrl(struct nvme_ctrl *dev, struct nvme_id_ctrl **id)
 
 	error = nvme_submit_sync_cmd(dev->admin_q, &c, *id,
 			sizeof(struct nvme_id_ctrl));
-	if (error)
+	if (error) {
 		kfree(*id);
+		*id = NULL;
+	}
 	return error;
 }
 
@@ -1193,6 +1195,7 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl,
 	if (error) {
 		dev_warn(ctrl->device, "Identify namespace failed (%d)\n", error);
 		kfree(*id);
+		*id = NULL;
 	}
 
 	return error;
-- 
2.43.0



