Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944CF2ECD1D;
	Sat, 12 Sep 2026 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223238; cv=none; b=hgCp5z1cod1cYGyyUfdLNu7OhscEmjgDiSb6DQo1iuHCmRjxU4kEmxXpSaQBDB6gcXCdxxVbSHkBvaeee/4NFsJO1Llz6uEkPR3OW46Sf4UiYSeC2LN2Z3j3MQ7ngBf8ulvVDUO1iiMghnv2eREn4IR4uoRtjff45YCu61Was0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223238; c=relaxed/simple;
	bh=Kt3fomIySC/q3IZx3qviorDY6hwj0IJmjknu1VZOcXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EW+Pzt96CgZMhbCv8/7J8Limp4rJepk0XMfSuC54GnG1qGZOpM09UYK5aPgTH5sIhOOO58xUmNIxMPiCX31uor3fqi899GA48tJSNFnsa1iNQyoWKlc4SGBLiA1amYIUqCfTL7XY+WA8vB1yKLk2B44XUCjnOoRcwjLsJWDQIjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ8nPfDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ8nPfDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FD41F00893;
	Sat, 12 Sep 2026 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223237;
	bh=ehpON/gU+cMOfREFKI46SteXa1+bTpdbqoHbjHhPsho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQ8nPfDIrcc6MdI4FHFoKrXzkaD26ArbYqbCaieRg2VrgggVjLfeO0rxrJkOkunrX
	 vqxoguYqdI6tG8taO96dlEnFb6GmG5L7iVBTBiADr7Otz3KpyJwQo6RRv1z6qK0gxC
	 c/wCNavs1th1xkY3T5lkUBLt65Kbb1SdJl8vJUeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0749/1424] firmware: arm_scmi: Unregister device notifier before IDR teardown
Date: Sat, 12 Sep 2026 08:53:01 +0200
Message-ID: <20260912065624.071323801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fbe893734411c..4bc73ead390e4 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2936,6 +2936,9 @@ static int scmi_remove(struct platform_device *pdev)
 	list_del(&info->node);
 	mutex_unlock(&scmi_list_mutex);
 
+	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
+					   &info->dev_req_nb);
+
 	scmi_notification_exit(&info->handle);
 
 	mutex_lock(&info->protocols_mtx);
@@ -2946,8 +2949,6 @@ static int scmi_remove(struct platform_device *pdev)
 		of_node_put(child);
 	idr_destroy(&info->active_protocols);
 
-	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
-					   &info->dev_req_nb);
 	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 
 	/* Safe to free channels since no more users */
-- 
2.53.0



