Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F7D2EC54D;
	Fri,  9 Jan 2026 12:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961626; cv=none; b=uw9OotWnOtHmeQxJEM74VwhZIKhLbgzMaU84A0zCteHuWja3iwRGXgCCPfQS4DIK+/d5tl+mG/IbPChqtkBfNk7fwHs7bH07X7xbihLXNoF2Hu6tW5g30VRbb0ZaphwpnavQZ/m2IPX6pK5YdwMYZJMUXrCWQTSCKemxU52Q/6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961626; c=relaxed/simple;
	bh=mnfo2/V0lkIrh4cSfpT8evX1La7FG/XXCa1UGSW6dzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPpQUiKuBkwuhtMTMq/KpcYI4GZjC8DEp3v9Qv6/a2PqG9VqWM9sTqdtIMuMRzx5WV/omPGirwT/jOGq7Np5KieM6GCvf59R/CV1cxrzJQnsNG96qwHZDNmGMDG6rOGQ2a8gFPfob43NX4x8dSS9OZyWblLHImQLVyevOtzk4eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWlh5kii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWlh5kii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F15C4CEF1;
	Fri,  9 Jan 2026 12:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961626;
	bh=mnfo2/V0lkIrh4cSfpT8evX1La7FG/XXCa1UGSW6dzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWlh5kiiCoO1jrumoWGWmB5FPZ+rpXKnY5ZiAD9Cyr3hLTmw+JRbDQWwOfhqIctQk
	 2Y2RcKjL2KYxOfploxp296yJ+NY8he2C3KU6oOodf7PaFAzv61awFridvZCvWgruCH
	 fh9+pf/8b5LySgZEylHDpH8XdwUMc0k25KFjZRHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/634] scsi: target: Do not write NUL characters into ASCII configfs output
Date: Fri,  9 Jan 2026 12:35:59 +0100
Message-ID: <20260109112120.487210632@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c03b55f235e283cae49c88b9602fd11096b92eba ]

NUL characters are not allowed in ASCII configfs output. Hence this
patch.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251027184639.3501254-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_configfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 537c1370e112a..e38f8343b75cc 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2689,7 +2689,6 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 		cur_len = snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&dev->dev_group.cg_item));
-		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
-- 
2.51.0



