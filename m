Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88832D023;
	Mon, 10 Mar 2025 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629281; cv=none; b=l3jJXrCQjie3fxYquGau9VIfh/8nljdv+scBgYVYfrarQTb2Y96yNu2SI+5ZYc0BwLFToPG2AYGEZdZLgWU9kkbq/Rxx/VchZFUl4SzI+tW1lZ4ebKOFpfBMLN+X6xyGwqnWw7lZh222b7CVEQLA2QIs7DVpgd0L+qwrIqusAU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629281; c=relaxed/simple;
	bh=4RRoz94aHQkM7dhJ7GDHAEvT5emWbFtCVNIQ85OgIss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOm60h3rMGA0coTYm2IbP9jAo7cdkqZVT07BtPEJQpnmz9YS6kFJDgJqwvjC+1Sva/Mp4i/O1NGe9HKNrneU9HOWB5Tj3W1zhgTN41kgeQDU2DDjLEq5L8HAV2EUJbBo9MtguwR0k6hbdZ5ZQduBLE6PNuI+EVjBzWWGgkH6FJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAZpXDCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAZpXDCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D61BC4CEE5;
	Mon, 10 Mar 2025 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629281;
	bh=4RRoz94aHQkM7dhJ7GDHAEvT5emWbFtCVNIQ85OgIss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAZpXDCs1fxKtgCEPwQlSPol3rSqwqCUTOtlTmAUF1nrsPkiDUL11IvpgAvX6LvnU
	 DyCi/l3B43D7PtcIMi8ZArUsMAIHC4YmxE8DlqowmCmY26XjZTFqDaHhsGYhIT4lqd
	 Hj+AxjFjTQVnMYiqdk7wJm/BnTfz/QyFBhdA9dy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/620] nvme: handle connectivity loss in nvme_set_queue_count
Date: Mon, 10 Mar 2025 18:01:26 +0100
Message-ID: <20250310170555.106372334@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 294b2b7516fd06a8dd82e4a6118f318ec521e706 ]

When the set feature attempts fails with any NVME status code set in
nvme_set_queue_count, the function still report success. Though the
numbers of queues set to 0. This is done to support controllers in
degraded state (the admin queue is still up and running but no IO
queues).

Though there is an exception. When nvme_set_features reports an host
path error, nvme_set_queue_count should propagate this error as the
connectivity is lost, which means also the admin queue is not working
anymore.

Fixes: 9a0be7abb62f ("nvme: refactor set_queue_count")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 17ba2e59fce26..7f744aa4d120c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1585,7 +1585,13 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count)
 
 	status = nvme_set_features(ctrl, NVME_FEAT_NUM_QUEUES, q_count, NULL, 0,
 			&result);
-	if (status < 0)
+
+	/*
+	 * It's either a kernel error or the host observed a connection
+	 * lost. In either case it's not possible communicate with the
+	 * controller and thus enter the error code path.
+	 */
+	if (status < 0 || status == NVME_SC_HOST_PATH_ERROR)
 		return status;
 
 	/*
-- 
2.39.5



