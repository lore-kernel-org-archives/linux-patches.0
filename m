Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A00612BF15;
	Tue, 23 Jan 2024 00:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968901; cv=none; b=RGiyCVJm4vM7ik83+lJUFUX0aZBYPTS3iFAIGKu+YfGdTqoDIN8IuWfW2rf/nempeaHwDTG+c68KAqPtF/i60JYUOJed+1KbxQg9546f3PioC1jVl5H2WZOpGG7kekqDvshhsIM6D5jUS7T4ayGwhwaLpsABYZT3SKUu4vud2JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968901; c=relaxed/simple;
	bh=K8caADRfhvwWdlaOEidDdOhYT5KlMEvErnFk3hmFRCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f98XvfCTQoaf+kkGv1TShK9GS42ULtN0R6ElUvYUX3VEtSfRchT5nZ7khPwR7FfHKXJ/dFAwQW+wSKy6T5D7a2s486h/1CMqmeaPM2BY3eznA5uokE9RXHyrPWNnM46wpEaJSjxC4HFdwyK0JMQJOBDUUpsPypvXMQPQdFaUStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kd3JB3Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kd3JB3Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E2DC43390;
	Tue, 23 Jan 2024 00:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968901;
	bh=K8caADRfhvwWdlaOEidDdOhYT5KlMEvErnFk3hmFRCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kd3JB3DcMUVAlM+WlHzc5uYwodsHClubikmdrXMDdMiH414tBEAHa8h80PNzeweqT
	 /qjsatuXj+lmxHnjD2KvxSzxy0OH/q9T2iJeON7VafREj8wu6xkXmTOQoyQ0o8Y+d8
	 2lMiz+Q83zcQF7kGEugkH4yxlwtdHyZmIMYF24Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/194] scsi: fnic: Return error if vmalloc() failed
Date: Mon, 22 Jan 2024 15:56:59 -0800
Message-ID: <20240122235723.067989948@linuxfoundation.org>
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

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit f5f27a332a14f43463aa0075efa3a0c662c0f4a8 ]

In fnic_init_module() exists redundant check for return value from
fnic_debugfs_init(), because at moment it only can return zero. It make
sense to process theoretical vmalloc() failure.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9730ddfb123d ("scsi: fnic: remove redundant assignment of variable rc")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Link: https://lore.kernel.org/r/20231128111008.2280507-1-artem.chernyshev@red-soft.ru
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 13f7d88d6e57..3f2e164b5068 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -67,9 +67,10 @@ int fnic_debugfs_init(void)
 		fc_trc_flag->fnic_trace = 2;
 		fc_trc_flag->fc_trace = 3;
 		fc_trc_flag->fc_clear = 4;
+		return 0;
 	}
 
-	return 0;
+	return -ENOMEM;
 }
 
 /*
-- 
2.43.0



