Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162FC4D5A1;
	Sat, 12 Sep 2026 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198510; cv=none; b=K2dq/S9WLeXhtEHS0bG38gNEZKpLvOu5mE51W8QjIJOeDZ08ERZuWCNEt8sd28yC/cpksukCuXt1BYu/Xk8jHW+OQWNgGsP8aip3sQAiP+bNDRLBcYrk0uW8aPvPuOliBZF1d27Vim7teusBhS8SIEc1Q0G4+4jIabpK39hbvU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198510; c=relaxed/simple;
	bh=00a+FAn7Xo8t9qT4J/lAbiglZJsQkhplP7NqzGrXIN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCQLP68LuUFrBClQNbo6yjP5XUtwbLjGc4V3ZYcQRr4Cw3lvGlxDVS/EXXUlugyTcZ6d4LgHB/o0CLMwWhvtZjC5g1yC0BO3TB0TqgxkMjDRHe9zeN2xzFvc9itgfMTamoOamly/Y24uIy3kQblBSe+qY6mViaXkpsD8gnNfp3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZr8mmqJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZr8mmqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A78E1F000FF;
	Sat, 12 Sep 2026 07:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198509;
	bh=/rlp+4GggunEsbzYQsxzKnctG+lEz6sw3tXsSPQrnso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZr8mmqJ4i+EVsY/OSU2GgM2hots3zLvba5J1MoFvjPTYbhcrx8xVBMQSe/HlAYbQ
	 b7/sSxzCc1AgwPaaEpgFDJsdDDs3kruXkzsp1ql8tGswpKsWjMvTQDuQfFDn+wvOGw
	 YqAhdNScLTykXB9eZcLGF9zIMGxCBTE0f8vOo74s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0394/1815] firmware: arm_scmi: Unregister device notifier before IDR teardown
Date: Sat, 12 Sep 2026 08:35:44 +0200
Message-ID: <20260912065658.144397220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 66a0bbf30cc14140fe13f63cd594a7c1ee352b75 ]

The requested-devices notifier looks up protocol fwnodes from the
active_protocols IDR. During remove, unregister the notifier before
releasing and destroying active_protocols so no notifier callback can race
with the IDR teardown.

Keep the bus notifier registered until after the protocol state is torn
down, matching the existing remove ordering for SCMI bus users.

Fixes: 53b8c25df708 ("firmware: arm_scmi: Add common notifier helpers")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-2-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 1d1f5d25d7732..52aff3aded4c5 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -3401,6 +3401,9 @@ static void scmi_remove(struct platform_device *pdev)
 	list_del(&info->node);
 	mutex_unlock(&scmi_list_mutex);
 
+	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
+					   &info->dev_req_nb);
+
 	scmi_notification_exit(&info->handle);
 
 	mutex_lock(&info->protocols_mtx);
@@ -3411,8 +3414,6 @@ static void scmi_remove(struct platform_device *pdev)
 		of_node_put(child);
 	idr_destroy(&info->active_protocols);
 
-	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
-					   &info->dev_req_nb);
 	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 
 	/* Safe to free channels since no more users */
-- 
2.53.0



