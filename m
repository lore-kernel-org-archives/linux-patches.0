Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBE178297;
	Mon, 15 Apr 2024 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191079; cv=none; b=QA/GucRM8BStgJ+P2StczDTIUrs4HTFZ4qD9cep/WSASmwxFXhdEwxx8/A3NhcU2ie7L8bzOFv6mvWfXi7CBHauW+2DPgI0j3fgZpf1EuQBEpHhsPe03w2zUsWTWPCkt0wPR0gfW1vETX+GICRhqYWjK9HVFHbqvJhl8UOGrfPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191079; c=relaxed/simple;
	bh=gBv+HNMIooqUPAEqna/V/u/mjrFYYFkP4mvZZAD7S+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZVXp5QNLBY7IhzQdr7U/N0ZTxMblklKNPCwFeP4nEAAaQBY97Tr2p5FebX41rSl9BAmQUwtgoKEAtEszH0Adw15InNOHHWuh8br6Fas8Iako2nrln4TJSgFRHROUR6O3y6fTO9Q4RjQ+gjA1eTSfhGuC0mxjYtdxWzKJbpY5w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6pfzQCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6pfzQCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE51C3277B;
	Mon, 15 Apr 2024 14:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191079;
	bh=gBv+HNMIooqUPAEqna/V/u/mjrFYYFkP4mvZZAD7S+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6pfzQCoKOMaudJkd3srJQRqfaQxh/2Yr/2uuC/zMXd+Nuz5yA9wsZBNK93jqXG4e
	 iocavWoS4uy0Bd7QbrcfU6np/aBUbO2bPf9nx/1OnVIO2u8XnS5wJV0+Rk0AvdwX5p
	 pKvNVUcsPeYsFcFEyDYtix+QxEfxfjuiHKCnJuCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 026/172] firmware: arm_ffa: Fix the partition ID check in ffa_notification_info_get()
Date: Mon, 15 Apr 2024 16:18:45 +0200
Message-ID: <20240415142001.143255583@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Wiklander <jens.wiklander@linaro.org>

[ Upstream commit 1a4bd2b128fb5ca62e4d1c5ca298d3d06b9c1e8e ]

FFA_NOTIFICATION_INFO_GET retrieves information about pending
notifications. Notifications can be either global or per VCPU. Global
notifications are reported with the partition ID only in the list of
endpoints with pending notifications. ffa_notification_info_get()
incorrectly expect no ID at all for global notifications. Fix this by
checking for ID = 1 instead of ID = 0.

Fixes: 3522be48d82b ("firmware: arm_ffa: Implement the NOTIFICATION_INFO_GET interface")
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Link: https://lore.kernel.org/r/20240311110700.2367142-1-jens.wiklander@linaro.org
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f2556a8e94015..9bc2e10381afd 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -790,7 +790,7 @@ static void ffa_notification_info_get(void)
 
 			part_id = packed_id_list[ids_processed++];
 
-			if (!ids_count[list]) { /* Global Notification */
+			if (ids_count[list] == 1) { /* Global Notification */
 				__do_sched_recv_cb(part_id, 0, false);
 				continue;
 			}
-- 
2.43.0



