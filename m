Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6739078F52;
	Mon, 12 May 2025 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071128; cv=none; b=Mer6CBfI778v5AtWzmWo2rvosd0P5RDysJpVbVM/PYZ9IiUcZ5ffSN+m0bFEo185m4DoXPg0kExFiSA0C8D29Um5s/+7nTzq9ueWTaQnzC0QuvWoRgIcmx6XPIBZtXXVyzK6XP3zPnBojZqKz51dAjtEGc34fa5nWaiijn4kooc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071128; c=relaxed/simple;
	bh=vLTHy1ewRMz/nKDaHd48c/0B9pbr99zuDxkpKqbZD+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btKvtoFWDHEYWwVMeVv6xVS89NIw4VyNALISw1aoZrzdowhkEE4j8FeHA9R8sRokDm6zY4nM3UcNckseZj6avwDB7lxHhJw5Tz+iCtPdPpdUJT4+JJlYIsCKS3lHhUGbA4lA3bWaLp3rVrpKfQsxe6+GuQxq3IcrDKhaEDCTwcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDocVX3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDocVX3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8FDC4CEE7;
	Mon, 12 May 2025 17:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071128;
	bh=vLTHy1ewRMz/nKDaHd48c/0B9pbr99zuDxkpKqbZD+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDocVX3avv1yuPzYmTKru29m1+EpVa5yeB42NWrSbfWe0pw6qVV/OrQpN6CQ1ASHz
	 oIv/mSnlGfTZ0ED6KFaFQJRFy7R7HscunFY/k0Rdbj5mfTqnp/hAmi+Z/lFvWsKkLV
	 dJCzX7rFP0PkvYLOt6pMRsjjhy6g01izgYwYlhMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/54] nvme: unblock ctrl state transition for firmware update
Date: Mon, 12 May 2025 19:30:01 +0200
Message-ID: <20250512172017.616633138@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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
index b9ba20f4048d1..7065f66ef8cf4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4389,7 +4389,8 @@ static void nvme_fw_act_work(struct work_struct *work)
 		msleep(100);
 	}
 
-	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
+	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING) ||
+	    !nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
 		return;
 
 	nvme_start_queues(ctrl);
-- 
2.39.5



