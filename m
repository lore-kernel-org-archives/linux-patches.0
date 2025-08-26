Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B58111187;
	Tue, 26 Aug 2025 13:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215462; cv=none; b=bTk5jES5g7nhu3PQsNKmXBUqSOaULdJn+4lstjQLkhcZj6uA5KzurPsaDK/8HuSof71Y2K4XbZBSXhXLLDxSLHd83kf0oVQe4yA6VKy69F/b9lNepsYRQnPhOK6WrG85/1wfW1+N+6sqoa5CVsvRwXExaM0oyeZ3eyKlvItKgYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215462; c=relaxed/simple;
	bh=Oejt2lkL2JILe1gCuVmjNiCFh24ZSDXr/HmVfcuongg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op68qgQzkNriIbYTQq11od9C+K0TScEkLmKaMFCEGJAU2PMWtG7eWTVqRCe8CXLnb2pTefm5st/aQlOd6WGYA+omJj4G1DilhRQoj727f2m7zH1umglrMagupXuiDNcjJMhkH6WPmEFszNofdmTkoUHPMOF764Uzo3vafxeQPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOnZ9HEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOnZ9HEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02EDC4CEF1;
	Tue, 26 Aug 2025 13:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215462;
	bh=Oejt2lkL2JILe1gCuVmjNiCFh24ZSDXr/HmVfcuongg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOnZ9HEQr3oTet6ILWa9dxg5dbK5uvOmyL/5OU6EyooDhseXgsx+/ox4hXR1PdW/Y
	 aPHy41/Wsj+RVrdKl89LinjR5MDxEH9GstVhivAddhVJh3B+BMR6VXYrIVNpdNKOsB
	 BkUoEjHECvzuIQYAG/u+OsvdpNxO2eywr2IoYtE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/644] nvme: fix misaccounting of nvme-mpath inflight I/O
Date: Tue, 26 Aug 2025 13:02:14 +0200
Message-ID: <20250826110947.575762802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 71257925e83eae1cb6913d65ca71927d2220e6d1 ]

Procedures for nvme-mpath IO accounting:

 1) initialize nvme_request and clear flags;
 2) set NVME_MPATH_IO_STATS and increase inflight counter when IO
    started;
 3) check NVME_MPATH_IO_STATS and decrease inflight counter when IO is
    done;

However, for the case nvme_fail_nonready_command(), both step 1) and 2)
are skipped, and if old nvme_request set NVME_MPATH_IO_STATS and then
request is reused, step 3) will still be executed, causing inflight I/O
counter to be negative.

Fix the problem by clearing nvme_request in nvme_fail_nonready_command().

Fixes: ea5e5f42cd2c ("nvme-fabrics: avoid double completions in nvmf_fail_nonready_command")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/CAHj4cs_+dauobyYyP805t33WMJVzOWj=7+51p4_j9rA63D9sog@mail.gmail.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7065f66ef8cf4..f3071bd11fdd3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -675,6 +675,10 @@ blk_status_t nvme_fail_nonready_command(struct nvme_ctrl *ctrl,
 	    !test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags) &&
 	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH))
 		return BLK_STS_RESOURCE;
+
+	if (!(rq->rq_flags & RQF_DONTPREP))
+		nvme_clear_nvme_request(rq);
+
 	return nvme_host_path_error(rq);
 }
 EXPORT_SYMBOL_GPL(nvme_fail_nonready_command);
-- 
2.39.5



