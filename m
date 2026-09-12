Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2CB28030E;
	Sat, 12 Sep 2026 10:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207265; cv=none; b=Cpv/SPlep0YrP82xQP5DfrLLqFwZonmRKfoLD55oOhDQHJpxmXwBakb7q6p026cMp1Aic1ySgZRiT4wEQSZmSYXWy9lcUzkq4mXXjnI7LeHEqYoCFr0+nV0oYJx9QeBxPBbgpfOWtWGXgdHp7IGQwTA8lFvYM9fTZdkurpfnvNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207265; c=relaxed/simple;
	bh=s9T2Pxsf34nVUwvb2x9uwLGbXLog0isSGY9oLjYBBBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6PGvCjFGL1iA4OZbN21LQaU3P8pngQxbB3CvDIwOjeO4JOXGelp8uhyOzsuTTEBNWbLVfrr7R4SibKjy2gZIi7kR77CWXKfzXqRWxD+gxZ/pHaghc2Mc/5E215hqyf+uhrSYOxpqLYbJrsd1O16nWjHIBI770KuXhOkKU0lbmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZIwTNx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZIwTNx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FAC1F000FF;
	Sat, 12 Sep 2026 10:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207264;
	bh=ydTpM0R3yJKTMj5XkMT27sg/Bg5JvEWe8NNGb3fFA30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZIwTNx8s3DPB12htfgkxFeWbao9L3pIIuSj718S3EX6xIi2VN9xs2QyUT8wbU9pe
	 s/jOr81oYAJHu+JuI1Ej1VNsRSVMQCPL7lgqyYYQ2W9xSQxVQOKg3rpU6BrZQBJsdh
	 6jkU7gJqACiZgYs2gmPn3mG1jG7xMZLOZcnpRHG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0378/1518] firmware: arm_scmi: Unregister device notifier before IDR teardown
Date: Sat, 12 Sep 2026 08:42:27 +0200
Message-ID: <20260912065632.015162228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f60dbaf7f3401..69f88b41e2b2d 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -3309,6 +3309,9 @@ static void scmi_remove(struct platform_device *pdev)
 	list_del(&info->node);
 	mutex_unlock(&scmi_list_mutex);
 
+	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
+					   &info->dev_req_nb);
+
 	scmi_notification_exit(&info->handle);
 
 	mutex_lock(&info->protocols_mtx);
@@ -3319,8 +3322,6 @@ static void scmi_remove(struct platform_device *pdev)
 		of_node_put(child);
 	idr_destroy(&info->active_protocols);
 
-	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
-					   &info->dev_req_nb);
 	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 
 	/* Safe to free channels since no more users */
-- 
2.53.0



