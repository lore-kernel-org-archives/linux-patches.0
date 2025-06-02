Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36A71A4F12;
	Mon,  2 Jun 2025 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875269; cv=none; b=XO7DlFNygtXvmSUPgwbzTGu4qJkUmrO/inJbLBv2YuUkmOCeSgihKUWZ3wRaZwP1I/9nSQq3nhXovTNY7QnIEekKS1Et8bvWTNJYDuFo48BGaKUI+LS0TqFrFBYwpajM3zyrW3/4phrW+aXoQ6HN15YxcJt8gS0n6f8GugyF43c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875269; c=relaxed/simple;
	bh=/2jllYUZYpX0HFftHPDNUeCFGDOUojMNIyzko05U+uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISoUMl+pv0S+7fqkqbWkPW0JSqHsXvNMcFuErF8Xqq7TqLEStjh6gygwQjWTyjg3I4fuiCgCj8WIPjcJ3nrGvT734GwLl/V+ddvttipg+J7JfRjaDFIP2RRMnn5tLPPrBx+Z6n+RPRTK9t+yz7xDTpqIdakmO+TJceLXwPOJ3bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpdsovU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpdsovU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40081C4CEEB;
	Mon,  2 Jun 2025 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875269;
	bh=/2jllYUZYpX0HFftHPDNUeCFGDOUojMNIyzko05U+uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpdsovU2hzXS72E9/+d1rwLRlEWl/sHC8bWY3dig6vUNOBKqO7P3Dz3nSFBBYs8OC
	 0NmC+hq1hRpDBgh9p5aUJa7bsXGyMyT7M2B71OhS7jzjpC52G6NhWf5nCFqzSMgIZJ
	 99sBBIUo3+pw485RCQVwIWMb/WZHxtILZGTK/xqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/270] nvme: unblock ctrl state transition for firmware update
Date: Mon,  2 Jun 2025 15:46:06 +0200
Message-ID: <20250602134310.485861574@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

[ Upstream commit 650415fca0a97472fdd79725e35152614d1aad76 ]

The original nvme subsystem design didn't have a CONNECTING state; the
state machine allowed transitions from RESETTING to LIVE directly.

With the introduction of nvme fabrics the CONNECTING state was
introduce. Over time the nvme-pci started to use the CONNECTING state as
well.

Eventually, a bug fix for the nvme-fc started to depend that the only
valid transition to LIVE was from CONNECTING. Though this change didn't
update the firmware update handler which was still depending on
RESETTING to LIVE transition.

The simplest way to address it for the time being is to switch into
CONNECTING state before going to LIVE state.

Fixes: d2fe192348f9 ("nvme: only allow entering LIVE from CONNECTING state")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Closes: https://lore.kernel.org/all/0134ea15-8d5f-41f7-9e9a-d7e6d82accaa@roeck-us.net
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b19fba64beb09..cb9b38e142edd 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4429,7 +4429,8 @@ static void nvme_fw_act_work(struct work_struct *work)
 		msleep(100);
 	}
 
-	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
+	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING) ||
+	    !nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
 		return;
 
 	nvme_start_queues(ctrl);
-- 
2.39.5



