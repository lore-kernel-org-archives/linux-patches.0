Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A82BDC0E;
	Sat, 12 Sep 2026 08:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200185; cv=none; b=OqQn79oOXzkHsQbAEarkxa31BvvcXsoSVWDGM4TyjNeHxtgBwGoT247JWEeOPGjgPPWkhXslHNs9UjC0TjgOOjXOOl4wm1FBqc6OpgKf203Xd09Y+SnJouS8ekqQKU1PwEzHrDAC7P1VvXOY+CaWYV5FfPL9Glp2QYQ7ElCQ2Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200185; c=relaxed/simple;
	bh=MjLEr4PPvXRNA5EreudFOHGBXt88qN3FtITkOmz8HSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pegJyFYG8NACMXc7aPVd+zvirCm9w2VkiipALdQrW39UVXF1dZHFnQCxx3bpbFMR7CKQvGKQ9IypQUXr9R1FejejcnkOYjR6gwstfoujUSjEYXvC7lhzDYpKwk1xVFnYyTrl3LvPEjibgc+3FXlZ8lCEhhI4tC3tA7v+hE9b2r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qv7y/7YV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qv7y/7YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5CB1F000FF;
	Sat, 12 Sep 2026 08:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200184;
	bh=UzKisB6ODlEkVKMMezeu2wH4RDSHTz7xFL1pcOAdzE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qv7y/7YVgg6BDCcshMkDj6G5qyINq6XSb5VBJsdALqzOX9nb6oCZWIw9T6WhCdlGi
	 joKGqd6AAIpC0K0NbPIA8TntiOg2S9uSB3O9WSDZzCT3gLKpKCiCV56mOFXGN9wIlY
	 HFJSFK9Mt9urKVLtn8fKQ6WAKTTBAolx374q8br0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0739/1815] nvmet: fix return status of RMI log page on allocation failure
Date: Sat, 12 Sep 2026 08:41:29 +0200
Message-ID: <20260912065706.252842737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 581d8bb556dd3e5567bcf322aa5e3e4b6a200c08 ]

nvmet_execute_get_log_page_rmi() leaves 'status' holding NVME_SC_SUCCESS
(set by the successful nvmet_req_find_ns() call) when the kzalloc() for
the log buffer fails. It then jumps to the out label and completes the
request with a success status, so the host is told the command succeeded
while no data was transferred.

Initialize 'status' to NVME_SC_INTERNAL, matching the smart log handler,
so an allocation failure is reported as an internal error.

Fixes: 5fd075cdaf36 ("nvmet: implement rotational media information log")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index ab6a0a98dd5da..3fde09b4d78aa 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -309,8 +309,10 @@ static void nvmet_execute_get_log_page_rmi(struct nvmet_req *req)
 	}
 
 	log = kzalloc_obj(*log);
-	if (!log)
+	if (!log) {
+		status = NVME_SC_INTERNAL;
 		goto out;
+	}
 
 	log->endgid = req->cmd->get_log_page.lsi;
 	disk = req->ns->bdev->bd_disk;
-- 
2.53.0



