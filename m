Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0757F3AC0D2;
	Mon, 23 Mar 2026 14:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274833; cv=none; b=EwnIriAQRO6oYy4B6BrWmkhMNljvJqP/2lAgK/RF274Pu3amY9GQRSjNYlSb6KYKoKiD3HUxQJh7lfcX4j5zXRbd+h3DWzqMoGZJ6BXf/OSPi0Wm0nQzv5Zzy8mvXJ5jcy1/DhHC/MeJfbA/2l3kBVmCrrOjh3+yztFRpiMpSks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274833; c=relaxed/simple;
	bh=J0LL6U8opAHylyxxksVd9A2tnyORpi0oAE0OKFoqGmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6tu3khb9tMU4zBJVWpyGCpf6MSyV/dYrctJ+pOsSRVjqRrNP1VBqIY6999OStJp/w0oePPMU/AjA2rxT7b7dizEDg147yv2TRW4lZOUK1pZ9JnPBgghW/WT6rsrxrSvnK1Zup6isvNGkq43vwFlLCm7rcxSZwTPRMuCmcpeR04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wqmucPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wqmucPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91380C4CEF7;
	Mon, 23 Mar 2026 14:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274832;
	bh=J0LL6U8opAHylyxxksVd9A2tnyORpi0oAE0OKFoqGmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wqmucPsC9SiB2VH6xd/GyXrkB/sXkzl6s4e4OQBqZPC+Ar1sC1zfLC4GldGY7su5
	 oMkmLJS/fx93z+y7Us3mNR61gmNSa9BDffhWDMj1dh71hpB9CPXtjznfspGYpygj34
	 mIPcU+8LCHPv1QbKbTk6/g/H9YW2VCQ52/GB4SRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/212] firmware: arm_scmi: Fix NULL dereference on notify error path
Date: Mon, 23 Mar 2026 14:45:42 +0100
Message-ID: <20260323134507.592808249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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



