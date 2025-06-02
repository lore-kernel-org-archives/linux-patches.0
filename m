Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088B12248A4;
	Mon,  2 Jun 2025 14:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874553; cv=none; b=bkKOmQedEeAZllpHn6krUjGRTyYLJCb+Z0GaYkYyeyhfd5R/KguspHZvv1BEF8n2gDZ9nc8HQl7OAnlVrMem4CQaP8016/RyZr7O9LZQPzfqe0YrnK7V25ZknW1nv7dJ2jMPqHthAdCDQ+IaAj8UYOTPkZD65jJ7XG6XpiuO72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874553; c=relaxed/simple;
	bh=8Z+3Nrshv0q0xm2iZ5VysvLyHRxkR47hPCTEe89VeyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xz00gpwYL0Fu4z5ErKy0ZV6trCqhBbFy9jV/D8PCSFF14HOtrUXIuDybG/dEqs6ZKnfoqJmLnC6yE5V9HKgYeRhkVuDfEkOdVlcpTsnUSze8KBuhVMIz6dMfAZG3o3AOVlKc45BG7r7vyiHy+AN7oP8gCM5PQGOtt0dxC6qfdC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNip5sE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNip5sE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685E7C4CEEE;
	Mon,  2 Jun 2025 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874552;
	bh=8Z+3Nrshv0q0xm2iZ5VysvLyHRxkR47hPCTEe89VeyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNip5sE5JnEDqRu2cPqEXxPcsP82IL/pQWsa2W0eI7THr0KpNrKUWVVRd7ufNgW/F
	 4KHqbjWCWBHF+h52uAD9A56/JeigMyR95otHwQIWMocGdnN1MFdH2IHfN44ba24rK1
	 LvoDXBnkZlhOTiX/xVrEln+JDDXSGH2EF4+8m8xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/204] nvme: unblock ctrl state transition for firmware update
Date: Mon,  2 Jun 2025 15:46:33 +0200
Message-ID: <20250602134258.039042903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9816debe5cb51..94c8ef4a54d3f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3980,7 +3980,8 @@ static void nvme_fw_act_work(struct work_struct *work)
 		msleep(100);
 	}
 
-	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
+	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING) ||
+	    !nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
 		return;
 
 	nvme_start_queues(ctrl);
-- 
2.39.5



