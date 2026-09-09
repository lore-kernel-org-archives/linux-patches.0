Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C356D57267E;
	Wed,  9 Sep 2026 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963532; cv=none; b=KNCLmlZowzHpUuLH4uSUK/P01zHFj3BO1+qHVmjnRTgs7Zcbj5HCOnkbal9ptjUiKNkD7nVh1Zrmmla4SMlEsCSBMTnG2TVNVmq+UsWuP4vFLDL4YXjwk5P1NsxrqunPGgiA1/Udcr2H7SaXC3WCeEnVWOyyUIK8zd2Pz0FnzVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963532; c=relaxed/simple;
	bh=YFc/dVGMeSauoSaXyJ/Kg2XSIJDR0r1nEIVYcZLgNfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nziVD9Vsyh1NIp6lckac5LInA1SHyHZHY0JtFBa9hGWT3GEgz7fciehU9QI2HFOE6vrhBJTN6uKyZ1NmFrtb60N0H/9bd1HjGZuU9C+x18EcwbiZVB4S6sh4+YLkxUKkYMB6eXWTLXQVI0TekVB3qSQemZ3VMSyS5BkiDxVji20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WE0mdhl0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WE0mdhl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239441F00A3A;
	Wed,  9 Sep 2026 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963531;
	bh=Q9ds0mli6igpRyc+hGpa5op4tsopESbvzuomV0VgfWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WE0mdhl0aLdw69YMKpGJPxPCB6HosYWEVqX+W0+WzVDYyoeHFbQAiEhqwfnzP+ccI
	 dN5a/atDnqMiQUJ20LutIIfQdaf4jnNWP0s8h/muUYtDNpnTn95GQUkGB8o15pQyaB
	 8VAa23C5bxsgwLk05Kf+uVOLV1y4x8wqSPkjwS1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 110/583] nvmet-auth: Synchronize timeout work during SQ teardown
Date: Wed,  9 Sep 2026 15:36:35 +0200
Message-ID: <20260909134241.944002034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuki Hanai <hnkz.64@gmail.com>

commit eaa948c0e19b1bb2d93262207bca0c3d19cc3406 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/auth.c  |    6 ++++++
 drivers/nvme/target/core.c  |    2 +-
 drivers/nvme/target/nvmet.h |    2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -250,6 +250,12 @@ void nvmet_auth_sq_free(struct nvmet_sq
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
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -968,7 +968,7 @@ void nvmet_sq_destroy(struct nvmet_sq *s
 	wait_for_completion(&sq->confirm_done);
 	wait_for_completion(&sq->free_done);
 	percpu_ref_exit(&sq->ref);
-	nvmet_auth_sq_free(sq);
+	nvmet_auth_sq_destroy(sq);
 	nvmet_cq_put(sq->cq);
 
 	/*
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -901,6 +901,7 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *c
 void nvmet_auth_sq_init(struct nvmet_sq *sq);
 void nvmet_destroy_auth(struct nvmet_ctrl *ctrl);
 void nvmet_auth_sq_free(struct nvmet_sq *sq);
+void nvmet_auth_sq_destroy(struct nvmet_sq *sq);
 int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, u8 dhgroup_id);
 bool nvmet_check_auth_status(struct nvmet_req *req);
 int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
@@ -927,6 +928,7 @@ static inline void nvmet_auth_sq_init(st
 }
 static inline void nvmet_destroy_auth(struct nvmet_ctrl *ctrl) {};
 static inline void nvmet_auth_sq_free(struct nvmet_sq *sq) {};
+static inline void nvmet_auth_sq_destroy(struct nvmet_sq *sq) {};
 static inline bool nvmet_check_auth_status(struct nvmet_req *req)
 {
 	return true;


