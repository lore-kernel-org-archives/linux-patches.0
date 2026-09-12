Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BA52E06E4;
	Sat, 12 Sep 2026 12:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215449; cv=none; b=J1abWvRQRrEkIRaRw8fiLe0Hs5jZleQ9nlQENd242XwDV+XSekhdkgtqYwnai1mQ3SqShF8zwavvfVlkDJucA31Rgli/9PnjcqCg86GmqWyLPrh11//QTJPDiZ4EiujXoJ3Fzzm9l0hs20jvY4a2/dMGo+lz9WlwMucyRHts7eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215449; c=relaxed/simple;
	bh=3YGtdg5xpgzXNQAJKr6ZeMqe0d2uMgQijXYP2SCjlN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNiBuBbkeCLzf0Kfv07ki+ClMJwaMyFUBjCSijyAEWxUH0e+/WxSARDT9NEHdYzIw3BmlBYJVojQpKXOSXcrl0LS5aoLNt23tzx1MbPOT6zRQZixPdW90uvLP144mJsDqvpbZufDLbYAGl4sgrx89pasmcnRjyKIdEciqfZsTFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsUKI/3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsUKI/3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC98F1F000FF;
	Sat, 12 Sep 2026 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215448;
	bh=FjixZqfbBS+zeOtYis9iszWsDFzAKONFgivIWwyR6RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsUKI/3cv0cFZml9TvsZ1ec+Dpo/maofrncwa18gPlxNR76gTUdc5lmkMak86CrkI
	 QNCy6Tx+PI6lxwvs7GfIztOP3ZrhtvmGq8lqo8EKMb11monq6HYM/zgjEzu7rB0Uph
	 C9+8CaL4z45c4QHjIsYrYCNN8MxKeiyPXvKypSzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0534/1376] firmware: arm_scmi: Unregister device notifier before IDR teardown
Date: Sat, 12 Sep 2026 08:49:20 +0200
Message-ID: <20260912065619.443652172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1901cc1ec8dd0..bb503028c1f5e 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -3250,6 +3250,9 @@ static void scmi_remove(struct platform_device *pdev)
 	list_del(&info->node);
 	mutex_unlock(&scmi_list_mutex);
 
+	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
+					   &info->dev_req_nb);
+
 	scmi_notification_exit(&info->handle);
 
 	mutex_lock(&info->protocols_mtx);
@@ -3260,8 +3263,6 @@ static void scmi_remove(struct platform_device *pdev)
 		of_node_put(child);
 	idr_destroy(&info->active_protocols);
 
-	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
-					   &info->dev_req_nb);
 	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 
 	/* Safe to free channels since no more users */
-- 
2.53.0



