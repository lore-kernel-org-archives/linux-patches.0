Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB3C5384;
	Tue, 23 Jan 2024 00:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970795; cv=none; b=h2wklDiSq0fgpByNLjV1ZVCozgQO/HiGkZoX2osf4lsQxLQ30srPAEUTru/Ngacs1LN4nOOxKYk7KGl4/ITrwRTFZ1ic3FGywlBTBq9V4NvEzQCTjzobq1HesTLgf51cyzLK6fnuFqh4KMlIqwq13z7kyN4+nrjZYbOvYAJOYLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970795; c=relaxed/simple;
	bh=N2c+abrP7ilTsTZLZJw2UusklnrZuyYMqhSkcoRzBj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nH6cYk2b94iEwB8/4G8f4ke37Epdy6RbBfpJdMio0orkfjK6jJrP10DLtj4KO+XFla2Z1hurfJbsrPPPAS94G7BM4N3stgHiQmzuNJsyqG0/ze6/JKJ1iOo7VMrEJVuovHuU8HgGdx7+H14Ka/kZFQe4S/fiIAU1/Ke68nOzFy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MASaJQdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MASaJQdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0695EC43390;
	Tue, 23 Jan 2024 00:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970795;
	bh=N2c+abrP7ilTsTZLZJw2UusklnrZuyYMqhSkcoRzBj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MASaJQdPe0nC/W4/WopOBLTacd2RwO4A1WWTmKvUW/Z67bo9tnYGoJVzYLlK8W3BI
	 qVeXAhSwldfhjm/ZFJwyp1HKivANJkZpw+5qU9v9rpOeEwlw81ge+sFDWNPgRvAFrm
	 uYAVHGJ19bMbPToLbhacr1Ucpa2qA/HOeZADl3Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/286] nvme: introduce helper function to get ctrl state
Date: Mon, 22 Jan 2024 15:55:24 -0800
Message-ID: <20240122235732.727419692@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c3e4d9b6f9c0..1e56fe8e8157 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -354,6 +354,11 @@ struct nvme_ctrl {
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



