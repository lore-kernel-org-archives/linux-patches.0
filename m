Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F5423771;
	Thu, 18 Jan 2024 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575662; cv=none; b=AvNKc9ICLPSHX7IsPMAQId7sZGe+NJNaalm6xbPykwWzYOJksJOewZoNvon4pTz6cGCJw3elk4gHzEWjML4ZDL81bPfuTp06ZYlMdH82bhzrGgVx6bRV9WhKYClm7bf9fPI0FiBud67N9uzrhfbuvjWe7hlZo+++dQ9ki4Q7jrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575662; c=relaxed/simple;
	bh=3WAhMstpWYQEUwOg+4xLzWO7nm5s1+aick5lNhmZvls=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=bsT1p3YBKL69uUxC+nvpMNevdPg1p1TQltiikBojyxIwKtOo9xvKWAQbsA7CPi89zc8+oYLWC/lIHKuwdxxtTuBs2+WZgwX0w07Mty1goNFnOiu+EyYYM41s8g4C2Jc1i9Xp2x2RzmRD6j86kLBlaCiFPNgGYeAca1F9uCz7Pzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsCsgaur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsCsgaur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539DAC433C7;
	Thu, 18 Jan 2024 11:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575662;
	bh=3WAhMstpWYQEUwOg+4xLzWO7nm5s1+aick5lNhmZvls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsCsgaur2FcZiOtsSQb8YFZylBpag63xC9KxPIASg6X6rNKRTZO8S+jJracnkGFCn
	 E3V2Tm8iB1tAq1POMEOGAWAU1Q/3SeVZdruYHbVC3aUkrhRbssDHJ6QuXgjnzQf/KX
	 WSf0Ee8psiSupKQCdD1nZ1UqnBxQcuT32BNmUgWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/100] nvme: introduce helper function to get ctrl state
Date: Thu, 18 Jan 2024 11:48:41 +0100
Message-ID: <20240118104312.363761028@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 118bf08a708b..a892d679e338 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -382,6 +382,11 @@ struct nvme_ctrl {
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



