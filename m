Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1249A266B4B;
	Tue,  8 Apr 2025 10:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109752; cv=none; b=Cw9qS3fw337QjEEZr/o5PHRkGz165O2omVcJDMoVQR/ajGz8rikE8Fnu7BRXdnlusC25FIzmWPrpQweWf+i/4lGv1jdfiWF58tS2D8+YInbkFKezRR8fyrxGHwMLucXpMB1ME1qlGr6IkPuAbs84L/xPD3KkyoSmmOP1M1SazRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109752; c=relaxed/simple;
	bh=rY/s8ZAUKCfjsK2NIusXizo9lf4h7G++RribScF6NDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T516MRdyYIuSw899RG4d8b3Pmy6O6zF5rViuxzpA1bVOaA2/6uM1eEvHcOwvzk5RoBiGKIafphvNVutQ5sv2pH4mm1bGhDiazUqEkTA6KpqABVnQDMFIY+fFoDb9UpxxW/bRARsgvIOjujFruPntXxR+dlUZEgTMAFUNzrM+B/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QStJ498c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QStJ498c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9824AC4CEE5;
	Tue,  8 Apr 2025 10:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109751;
	bh=rY/s8ZAUKCfjsK2NIusXizo9lf4h7G++RribScF6NDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QStJ498cynM7lw79b4tYerMpaRg4ygGu7Et8Top2UUP5CaqeU5goSnpWNnrRlDvoD
	 1ytIeU6odtL7LijioU9c7bT6TANKNcPo+BH2mIB9jMUU1zrrUF5jcn88AZ1rAyQYBK
	 Qgerzx8Ag0/g4rajCwovk+Et6ghFoclNmyRVH35A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/227] nvme: only allow entering LIVE from CONNECTING state
Date: Tue,  8 Apr 2025 12:46:56 +0200
Message-ID: <20250408104821.551326343@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit d2fe192348f93fe3a0cb1e33e4aba58e646397f4 ]

The fabric transports and also the PCI transport are not entering the
LIVE state from NEW or RESETTING. This makes the state machine more
restrictive and allows to catch not supported state transitions, e.g.
directly switching from RESETTING to LIVE.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 019a6dbdcbc28..5f16fc9111a9f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -384,8 +384,6 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 	switch (new_state) {
 	case NVME_CTRL_LIVE:
 		switch (old_state) {
-		case NVME_CTRL_NEW:
-		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
 			changed = true;
 			fallthrough;
-- 
2.39.5



