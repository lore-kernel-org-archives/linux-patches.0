Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF23129A7B;
	Tue, 23 Jan 2024 00:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968721; cv=none; b=EdnWnKjNMTZ0W9fELFT9hx0copHUrFi27WQ2gs8XFs1sGMQyeVBhYY8Ll8wxUhd2vLdh5EW3jhyb9MhufSboYXZahhZiVZ4KseDcHhfyoCBQ/ZSCuwf+kCzToXfuu5eB5XkdCHbNjRWZE43ty1GHDtjsEIju3y0Ucz+0704hi6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968721; c=relaxed/simple;
	bh=ZFLMwhZVkvMExdFvtFFJQhyzExAd4xMBjpRXpfJQlQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOyq7UYsyLh4ENMMnt6ewxju4tWY8UBEVfRjD2T2aFkAXyQ0V+k0gLamyooBMICEl7d09KBmcbgzOWAvp2GhVhhyC54sm4jDLXCn7iTImA9fzmYdHmkHs+36cpv2Lv6TY6tMHomIpZjAPxeU02uNr7lQYS3MdwH3lbU8t5r3FT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTixcus0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTixcus0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C32C433F1;
	Tue, 23 Jan 2024 00:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968720;
	bh=ZFLMwhZVkvMExdFvtFFJQhyzExAd4xMBjpRXpfJQlQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTixcus0imFBo8Yk0n+YjP1ZIVwqGh1JINVXP/p78Wj3h5biV44woyFqsUmUCYzkr
	 tXIpeApJ65nOClP5uLfSzHYR1RYjzE0feRgSKNXmdHQ1KFEdDDm6Qf25r5oNsGI1O2
	 t6soXApBJQq0m+2K6pZ2EdJl7CMmkW0lls5rVGWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/194] nvme: introduce helper function to get ctrl state
Date: Mon, 22 Jan 2024 15:55:43 -0800
Message-ID: <20240122235719.772179208@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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
index 17c0d6ae3eee..c492d7d32398 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -292,6 +292,11 @@ struct nvme_ctrl {
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



