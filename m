Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D143A311967;
	Sat, 12 Sep 2026 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222166; cv=none; b=sapbinjNXbuOK9vweIozRr4VIgrKptHJ8FjF+Z0r8zsietVWokrTFDqJ5Yod0d+bMbxjzKj2iL1ohok0m/QVPrMWk2ZOPm11SqdN8iXzOY5GGt1YDCnpVDddjOcCE/MoUcQ5DwM9jAj5rzTlkxQopWiI+6aRd7KYtWqOwmQpK/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222166; c=relaxed/simple;
	bh=P2tjvCmgd0sR07bM8R0cZf0ZLWRePRSdaGKzP8x+vD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbZXKdultHUgTq1i7Hzpkp3iVHZiP60cwGM+Ujc9nHYt93nZCCJPsK1oxMrQJ2JRsaQkPI5Z84yJKucnBdV1rVBl6rmF89EmhFTFm8cDVG+qB0b9D8RYV+BTDZ23HNwSSIXDTGXB/IBer5r2+xf59ljBZ8mhA5DhRMV9IoXUNDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny9eNQ+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny9eNQ+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AA31F000FF;
	Sat, 12 Sep 2026 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222164;
	bh=eiBV1Xin6jvPTn10NgAJpZ3cAAk3o5zrb+FS4OT27yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ny9eNQ+oi6FPjMNWanCsnWoCQtc2CIl5r0iZkvz7hGde86RG3P/MicOjtIrY/iItq
	 WffY0PjD8sVoTOXFN0u3wSMyvKtrfe/eWbx6ZPJTpi4P8ijqIr6PUjFWn85otv6l8I
	 8a2qbANjLetQUY5ALxG1CaPFFpdTCqBpxzGLhErE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0531/1424] nvmet-auth: Synchronize timeout work during SQ teardown
Date: Sat, 12 Sep 2026 08:49:23 +0200
Message-ID: <20260912065619.185144360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kazuki Hanai <hnkz.64@gmail.com>

[ Upstream commit eaa948c0e19b1bb2d93262207bca0c3d19cc3406 ]

nvmet_auth_sq_free() cancels auth_expired_work with
cancel_delayed_work(). If the work has already started, cancellation does
not wait for the callback. Transport teardown can consequently free or
reuse the queue containing struct nvmet_sq while
nvmet_auth_expired_work() still accesses that SQ.

Add a teardown-specific helper that synchronously drains the delayed work
before freeing authentication state, and use it from nvmet_sq_destroy().
Keep the non-synchronous helper for in-band authentication state cleanup,
where the SQ owner remains alive.

Fixes: 1a70200f404a ("nvmet-auth: expire authentication sessions")
Cc: stable@vger.kernel.org
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c  | 6 ++++++
 drivers/nvme/target/core.c  | 2 +-
 drivers/nvme/target/nvmet.h | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 9fe6ad89bf83a..b3a0e19464539 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -227,6 +227,12 @@ void nvmet_auth_sq_free(struct nvmet_sq *sq)
 	sq->dhchap_skey = NULL;
 }
 
+void nvmet_auth_sq_destroy(struct nvmet_sq *sq)
+{
+	cancel_delayed_work_sync(&sq->auth_expired_work);
+	nvmet_auth_sq_free(sq);
+}
+
 void nvmet_destroy_auth(struct nvmet_ctrl *ctrl)
 {
 	ctrl->shash_id = 0;
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index e435996c55374..3b1b72022a979 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -804,7 +804,7 @@ void nvmet_sq_destroy(struct nvmet_sq *sq)
 	wait_for_completion(&sq->confirm_done);
 	wait_for_completion(&sq->free_done);
 	percpu_ref_exit(&sq->ref);
-	nvmet_auth_sq_free(sq);
+	nvmet_auth_sq_destroy(sq);
 
 	/*
 	 * we must reference the ctrl again after waiting for inflight IO
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index c0648216b9e4b..c037d1daf94d1 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -704,6 +704,7 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl);
 void nvmet_auth_sq_init(struct nvmet_sq *sq);
 void nvmet_destroy_auth(struct nvmet_ctrl *ctrl);
 void nvmet_auth_sq_free(struct nvmet_sq *sq);
+void nvmet_auth_sq_destroy(struct nvmet_sq *sq);
 int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, u8 dhgroup_id);
 bool nvmet_check_auth_status(struct nvmet_req *req);
 int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
@@ -728,6 +729,7 @@ static inline void nvmet_auth_sq_init(struct nvmet_sq *sq)
 }
 static inline void nvmet_destroy_auth(struct nvmet_ctrl *ctrl) {};
 static inline void nvmet_auth_sq_free(struct nvmet_sq *sq) {};
+static inline void nvmet_auth_sq_destroy(struct nvmet_sq *sq) {};
 static inline bool nvmet_check_auth_status(struct nvmet_req *req)
 {
 	return true;
-- 
2.53.0



