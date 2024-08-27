Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E2B1C8FCF;
	Tue, 27 Aug 2024 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772354; cv=none; b=LIbWqUls98Bip7FoQOIZJIdHqrPX1AOXjPiQ+f4dXas3tSgM2ERU1hD7hiDQ5zT94n5dnJOhhP2AeyFj2q8hlu49sp6oJpgAQ0xusqSr0QFQUcK/Bxb43v4vqrtp2ZpugME9urxhL/XVtKN+IGUVyiFRDfd4IlknSG1+CH2HjB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772354; c=relaxed/simple;
	bh=+8OAtwLBzPKmzxBskXsSJB9kMTswL47AfFCOyzp+4x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgPtqMD2nBU+qO8h9View4y0vuQVsvCsn2hZJVyzUxcpiGDNGNwxGtgZU0y4dsACLIuAgY4vFjRuM7Yuh7n5/xv3hH76jbUsd+FOYkKJJLxOYN5I8l0y7v2iuoaExeQrgRUQx0RtQZs3zndhw0HuQvufK0p8KPeRx8YBTBnZ2w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uc7MpV4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uc7MpV4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777CEC61071;
	Tue, 27 Aug 2024 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772354;
	bh=+8OAtwLBzPKmzxBskXsSJB9kMTswL47AfFCOyzp+4x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uc7MpV4OfyV6By1W8u2nicfVR1usH1IoWDQryq5QeR/RVRVubPLbntyVMYAfzdYVe
	 aGKpO9tAH9J3GfZHkNGQ2yJzuR46VmIMUL1mk8gQKacjlkAdrwW03L9ZlnJkO0haoh
	 S4atoaCgKIuC9Y9L2XJruzCsplBuwlQcZ88b2EHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/321] nvme: clear caller pointer on identify failure
Date: Tue, 27 Aug 2024 16:38:17 +0200
Message-ID: <20240827143845.426402818@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 1aff793a1d77e..0729ab5430725 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1366,8 +1366,10 @@ static int nvme_identify_ctrl(struct nvme_ctrl *dev, struct nvme_id_ctrl **id)
 
 	error = nvme_submit_sync_cmd(dev->admin_q, &c, *id,
 			sizeof(struct nvme_id_ctrl));
-	if (error)
+	if (error) {
 		kfree(*id);
+		*id = NULL;
+	}
 	return error;
 }
 
@@ -1496,6 +1498,7 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (error) {
 		dev_warn(ctrl->device, "Identify namespace failed (%d)\n", error);
 		kfree(*id);
+		*id = NULL;
 	}
 	return error;
 }
-- 
2.43.0



