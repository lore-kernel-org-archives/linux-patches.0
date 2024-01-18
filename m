Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C876022323;
	Thu, 18 Jan 2024 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575218; cv=none; b=ATyAVD3DzlD2DB3jxht+8gbBDB271zK6r/QCLarqoF0amneTiUKf+sQb1uGjs476Y+MkYbs+ZOFVQdyp3bUOtzXhACMLj9NsuISRDN4AcnCKT8unbOhyTHB36j/sKJ14ptHtW7gmZlqzDS6DMrXhOKElaTthKDdJOh6chawxj7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575218; c=relaxed/simple;
	bh=dNHZ3LuQScaLVp0DO+wDe4MtPlNgyD6w9n35z3x9wJ4=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=q8OYurdd1fwbM50ywCJUhv/Jwscxpc6gHaopplPq5z/0QARahfJqQsGNma266iRxemMof4qiueAJu1FEk2CHrJAwxuZWAL4FrVo4LssORn2sK55gCJgBfkNzz81oiVqqnFpfsBIviqK8OSwSivQ5K96lRGHyZaiSHwiUpw8Ylms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uu1elSlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uu1elSlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A48CC433C7;
	Thu, 18 Jan 2024 10:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575218;
	bh=dNHZ3LuQScaLVp0DO+wDe4MtPlNgyD6w9n35z3x9wJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uu1elSlwEAQTjgAEmQrUdQewK11JKo7VlrECQ9EVg1dvrb6YmtKBhBEfO4saj5K4l
	 vbZJ1H+1M114uFJSbTRws5Tzb0U2vKpkofrnYQjG0LicE49Rc9oqOznEkXn9yLoRfI
	 ci1cM74YX1tJhlpWU/brp9Ms5lYwuJA2ZLoXXZ8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/150] nvme: introduce helper function to get ctrl state
Date: Thu, 18 Jan 2024 11:47:55 +0100
Message-ID: <20240118104322.444895674@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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
index 74f74b459f5f..13f71461f5f1 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -391,6 +391,11 @@ struct nvme_ctrl {
 	enum nvme_dctype dctype;
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



