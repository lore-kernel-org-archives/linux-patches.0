Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255D1A6818;
	Mon, 23 Mar 2026 13:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274131; cv=none; b=j698Kt7C7aansBmhIJnvWwsaprg7rAVlrJhrn+KnypqqUpEtzBX8Wr7wR3zDBnBUR5FxE+WrFysGe/to82evKFAzUJcl+L1FTyQ24lVsFYgkaDCzFJCCLoFq+62pfUph/PeBQJCVgpOkg5U6oDvbgE0c+kVvY5v+cQ2PUjwCMGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274131; c=relaxed/simple;
	bh=V96mNHxAlcmU63StXe+StnhgK2wk7JD62WFzVaXV5YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDgEJ4bn50ZEDRoCzU+F12jeVUFLiUGo9bUEEdoJugluN6rl0dOWpaBh0sU1ktx3/ah50flHaRtaGWNAxN4EFy9bPqfXJVvE/Zs4cKE/qoKwCRUhxRDGWVWnaLokzqlRUOPueqWulIactcbgKQMD0JZZVCEl46U85Z+y7AAWaYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUdO6hea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUdO6hea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC3CC4CEF7;
	Mon, 23 Mar 2026 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274131;
	bh=V96mNHxAlcmU63StXe+StnhgK2wk7JD62WFzVaXV5YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUdO6heaYyF6Lm2Qj/jmphixOvqfd7Di1JAUgBKNq46uhZAKiO81jgvGmhFAk7JIU
	 1StsnXGq0tp2Pc5n1zsf28eTgGlwQNOwejw5Ys2XJ3paXi+IG5s6vWw8xXYe6YHj6m
	 e+CJUoeOe8IkhXsuMeyTPEQ/EcSVbQpzMjDK+d7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 117/220] firmware: arm_scmi: Fix NULL dereference on notify error path
Date: Mon, 23 Mar 2026 14:44:54 +0100
Message-ID: <20260323134508.300877083@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 555317d6100164748f7d09f80142739bd29f0cda ]

Since commit b5daf93b809d1 ("firmware: arm_scmi: Avoid notifier
registration for unsupported events") the call chains leading to the helper
__scmi_event_handler_get_ops expect an ERR_PTR to be returned on failure to
get an handler for the requested event key, while the current helper can
still return a NULL when no handler could be found or created.

Fix by forcing an ERR_PTR return value when the handler reference is NULL.

Fixes: b5daf93b809d1 ("firmware: arm_scmi: Avoid notifier registration for unsupported events")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-Id: <20260305131011.541444-1-cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/notify.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/notify.c b/drivers/firmware/arm_scmi/notify.c
index dee9f238f6fdd..2047edbdc5f6b 100644
--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -1066,7 +1066,7 @@ static int scmi_register_event_handler(struct scmi_notify_instance *ni,
  * since at creation time we usually want to have all setup and ready before
  * events really start flowing.
  *
- * Return: A properly refcounted handler on Success, NULL on Failure
+ * Return: A properly refcounted handler on Success, ERR_PTR on Failure
  */
 static inline struct scmi_event_handler *
 __scmi_event_handler_get_ops(struct scmi_notify_instance *ni,
@@ -1113,7 +1113,7 @@ __scmi_event_handler_get_ops(struct scmi_notify_instance *ni,
 	}
 	mutex_unlock(&ni->pending_mtx);
 
-	return hndl;
+	return hndl ?: ERR_PTR(-ENODEV);
 }
 
 static struct scmi_event_handler *
-- 
2.51.0



