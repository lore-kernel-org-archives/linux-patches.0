Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B62729992E;
	Mon, 12 May 2025 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073076; cv=none; b=eG0cp2D8cV6TLymHDShzYTj8XANm7fbHns4ydDxhROmEip0j5QRGcDUrYgUrsNkt1rZcw0A0iuohwIBL2kc1wglelC/1JT3ZhLa9Lhcx2L8N7Ogha5InLf6qoM0tT37H5FrZ6g5g7jj67HsHiTXwFC23/AUqV/HF+pg5rkXjjO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073076; c=relaxed/simple;
	bh=nXTckhGudQMSiRqNspmo4uwcaKKSF+2RKoZbAxCgNA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ2lWMFPXn4o9uLTFkGZn+qM0RrymdbyC/TjdM9JtCIEa17hhK7jdOeE8OI/0p5a6Vn5RnghVQt6XKAdBShZTDxK81isscjM6hzcbQ7JH6YwNM60D/WVfvVo/h1xPyUjBeoXGqpy/eNCm0l4plj/K4GPgys7LCdfYttKILseWYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDF26CCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDF26CCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDEFC4CEE9;
	Mon, 12 May 2025 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073075;
	bh=nXTckhGudQMSiRqNspmo4uwcaKKSF+2RKoZbAxCgNA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDF26CCGh757TpTOBNiD8K/zwQL8EUGnQEn/IS0SAspl75LpsVLfG3/KvtAmWaNiA
	 O1SVfXWElDvlLI870rF9TLKWahb95Gdx0nB1OBtHDbwFf2aOiAZvtT/7dyEAsFWOKp
	 eCt+9Rf6sl7Cc6gPLwpBNRiLqIa7AHD5M/fqEG0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/184] nvme: unblock ctrl state transition for firmware update
Date: Mon, 12 May 2025 19:45:47 +0200
Message-ID: <20250512172047.760465704@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f19410723b179..98dad1bdff440 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4473,7 +4473,8 @@ static void nvme_fw_act_work(struct work_struct *work)
 		msleep(100);
 	}
 
-	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
+	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING) ||
+	    !nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
 		return;
 
 	nvme_unquiesce_io_queues(ctrl);
-- 
2.39.5



