Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53407148FE8;
	Tue, 23 Jan 2024 01:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972087; cv=none; b=VWyZyK5MwqfdG/Q0tSMbKGSmGwCS6QuTs2kawGozT91q37bJShX6IbRZPJ0gaWqyHb8+qs+3M9d4rqmoCm3Y+jOUO77vlkLniL4uMNXGkQFXd4jB7RI7fmss9QZb6fUZ3wZNcpaBPAsgUqMxYRRuipVJj8Xvk1oSg2XFjYSYZps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972087; c=relaxed/simple;
	bh=TGXd0TdVD+oOw1nQGLyPqhdhkHtfsBjdBgKadocCOC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAJDpCJIGthKVe6+RVzuupETlzdXOIbR7ht7tQxJmVwvMCPSSj3QsP4S4ARbZduiu1Y7e2uIWnKNNj9Ox1WVL9x62l0wVEE+lirdzxLu0+eemMSPQZip28xO+TSp3yeqXUKT/ZNnD74wKPfBB2AQ0kdojSqCk6K8i3bHLfXrdiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G980kFlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G980kFlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CE7C433A6;
	Tue, 23 Jan 2024 01:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972087;
	bh=TGXd0TdVD+oOw1nQGLyPqhdhkHtfsBjdBgKadocCOC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G980kFlLgDh4o2yqiiN4NW9XJj270ssLvB/o71kKHEiKRN4CUs4CV6aWghnqel9GU
	 HrhAJXc7f2jJuX0rSpMGEJGy4VI0HwgtRq/+Jke0erazUXzQB/qifoJ5xuEGdD9+nu
	 1GSkJ6MBDAzvnOvLg/0T+DxLfwP253mBbX5RO6AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/374] nvme: introduce helper function to get ctrl state
Date: Mon, 22 Jan 2024 15:54:36 -0800
Message-ID: <20240122235745.326723553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 5c687c287c46fadb14644091823298875a5216aa ]

The controller state is typically written by another CPU, so reading it
should ensure no optimizations are taken. This is a repeated pattern in
the driver, so start with adding a convenience function that returns the
controller state with READ_ONCE().

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/nvme.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 415b01707599..f9bfd6a549f3 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -365,6 +365,11 @@ struct nvme_ctrl {
 	struct nvme_fault_inject fault_inject;
 };
 
+static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
+{
+	return READ_ONCE(ctrl->state);
+}
+
 enum nvme_iopolicy {
 	NVME_IOPOLICY_NUMA,
 	NVME_IOPOLICY_RR,
-- 
2.43.0



