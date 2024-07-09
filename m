Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA55355E4C;
	Tue,  9 Jul 2024 11:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523862; cv=none; b=uLg0eOm1q5CS0JUvb6gE/G6YiM7uRkoG/MSpvsz7N5lfcdGHCXctB6G5JwlGUwBbsD1wu+vtKQ/eCLj8n1h0dF7YHtNaUyFlrBQsVjyVYGUx4gIBdHIHrCWXoYHOygrwwhzWKr+EGRzxVcc94n0kO1ShacHZCfc9itYw2UcV1rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523862; c=relaxed/simple;
	bh=QbeFhw/ODNT6G6Zq/Bsq37m2o8/yRq9AfWHHWReUPQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhN41KhBNvQukzSQJNrvK3S5Na5uKuFCp4Aqxbo7Gan3JqHmi8PLalyagY7AEpyRycaN0byT6ywZlwWHIKhn3gBpRoqertdPofbDilg4uFWiKbosJAzQJavUrflaM/+LjyHuuO7rOvtpYu2yIHSwaHrOho1CjUdSonlfIALxnZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmZrZKEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmZrZKEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE85C3277B;
	Tue,  9 Jul 2024 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523862;
	bh=QbeFhw/ODNT6G6Zq/Bsq37m2o8/yRq9AfWHHWReUPQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmZrZKEPTboLkGMxSXWnj3Q/Xsz1AtzS8Npgs/FakhBAerftyDPOVIfp5D4ayRz5I
	 31R2I0YYLE5ik/x05SMp3Iet/Xz8OW0I5lkqBFAGX3VtUsul3M/pb6Qp29QhXalJq1
	 VKFyKB0d90AwZcQjPLDFXUibp9Sz2Ec7hGxyHB6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Turin <alex@vastdata.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/139] nvmet: fix a possible leak when destroy a ctrl during qp establishment
Date: Tue,  9 Jul 2024 13:10:32 +0200
Message-ID: <20240709110703.267986423@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit c758b77d4a0a0ed3a1292b3fd7a2aeccd1a169a4 ]

In nvmet_sq_destroy we capture sq->ctrl early and if it is non-NULL we
know that a ctrl was allocated (in the admin connect request handler)
and we need to release pending AERs, clear ctrl->sqs and sq->ctrl
(for nvme-loop primarily), and drop the final reference on the ctrl.

However, a small window is possible where nvmet_sq_destroy starts (as
a result of the client giving up and disconnecting) concurrently with
the nvme admin connect cmd (which may be in an early stage). But *before*
kill_and_confirm of sq->ref (i.e. the admin connect managed to get an sq
live reference). In this case, sq->ctrl was allocated however after it was
captured in a local variable in nvmet_sq_destroy.
This prevented the final reference drop on the ctrl.

Solve this by re-capturing the sq->ctrl after all inflight request has
completed, where for sure sq->ctrl reference is final, and move forward
based on that.

This issue was observed in an environment with many hosts connecting
multiple ctrls simoutanuosly, creating a delay in allocating a ctrl
leading up to this race window.

Reported-by: Alex Turin <alex@vastdata.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index ce7e945cb4f7e..cfba3ec7add84 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -806,6 +806,15 @@ void nvmet_sq_destroy(struct nvmet_sq *sq)
 	percpu_ref_exit(&sq->ref);
 	nvmet_auth_sq_free(sq);
 
+	/*
+	 * we must reference the ctrl again after waiting for inflight IO
+	 * to complete. Because admin connect may have sneaked in after we
+	 * store sq->ctrl locally, but before we killed the percpu_ref. the
+	 * admin connect allocates and assigns sq->ctrl, which now needs a
+	 * final ref put, as this ctrl is going away.
+	 */
+	ctrl = sq->ctrl;
+
 	if (ctrl) {
 		/*
 		 * The teardown flow may take some time, and the host may not
-- 
2.43.0



