Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112941A5BBB;
	Tue, 29 Apr 2025 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950153; cv=none; b=GYXVJDA4LtYZKTgR5d8ED0IfX/jMUfUpYvHs8erM104bh4Az7lmcz4IrZqlV8tJRxUj7hfRvHLnG4PomAqx5SDGM34cHCIcQj5hK3XtDxEFMrj+ApEhRwUEnVU2QbVe+ykKmEVruCpWkLet/QmXjLTIG+ZqrK4APOsY3LXlsJRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950153; c=relaxed/simple;
	bh=VhlaRE8SC1gR150HzZITGJCi4nYjadXSeaPx90Tb39A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZkr7nSeyLx9r2WNt5ocnW+IRXg9GF5JxpBlNEAAoLI9mxM/JYJlKk5ivbexIP/Mz2oQJMpAPB9xhE7NraSByepw/nzjs9qALHVHc8tVzQIDU4sDOJ+E1lUwcZU85EyJWTjCF5j4RadqeS1inRqXHJOXuNwSgt0i3gGnhnEPWF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHMsV6KE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHMsV6KE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D19FC4CEE3;
	Tue, 29 Apr 2025 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950152;
	bh=VhlaRE8SC1gR150HzZITGJCi4nYjadXSeaPx90Tb39A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHMsV6KEZTmlKZEBFCYafv2HzaUhZgHdzkEaQCvID7b0g00oJ4vffb5dRvXP6O6EM
	 Bj0BVaUdFXI905PmAUHcMmjAi4bMT8T5XMD/OuU0vYdXaCHLS7goPRkx+KZpmZMXE9
	 cqkIM7Y3kRJ7f/py9IbO0/o6lx5QTfyAAIzy7xaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Srikanth Aithal <sraithal@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 6.1 161/167] nvme: fixup scan failure for non-ANA multipath controllers
Date: Tue, 29 Apr 2025 18:44:29 +0200
Message-ID: <20250429161058.239780414@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

commit 26d7fb4fd4ca1180e2fa96587dea544563b4962a upstream.

Commit 62baf70c3274 caused the ANA log page to be re-read, even on
controllers that do not support ANA.  While this should generally
harmless, some controllers hang on the unsupported log page and
never finish probing.

Fixes: 62baf70c3274 ("nvme: re-read ANA log page after ns scan completes")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Srikanth Aithal <sraithal@amd.com>
[hch: more detailed commit message]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4709,7 +4709,7 @@ static void nvme_scan_work(struct work_s
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
 #ifdef CONFIG_NVME_MULTIPATH
-	else
+	else if (ctrl->ana_log_buf)
 		/* Re-read the ANA log page to not miss updates */
 		queue_work(nvme_wq, &ctrl->ana_work);
 #endif


