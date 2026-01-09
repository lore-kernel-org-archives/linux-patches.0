Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3AE35C182;
	Fri,  9 Jan 2026 12:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963181; cv=none; b=LCfTT+Leqkl7NJgJkGu77fGvIRlX8SyJza8IO8TASEp+M/vTEltBlL/++uMRcW1YNtY+tCxmROMb6ty0yac2IhE4ELsYjlbYPTOZJ5uJw2i8WobD7kgJpa6iD9nmmNWIBbs8tUKSpipqRo0w/EuV2rQgvUoQUtPfPc6u1JF1LT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963181; c=relaxed/simple;
	bh=u+Kh28+HLJ7sY5bYc8RlNsKXbYOjsn3MJx3J4b7Oc2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENuaWL2BKSDJidTlDTZcZ8b0nsn543C9wLL9j2oDzl5pU5o7fSdOtid5SrqcGlduzAUshFKc8aQ0r48l6NN0TOewdLYrBXBp17rQgonLPkETckAWlH4y8z0i7Rc/ZTDe28J+rIUIxLOZEdvgBF0/tfPL5fFQCY3wAImHUtF6XPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awx+KoIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awx+KoIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4BEC19421;
	Fri,  9 Jan 2026 12:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963181;
	bh=u+Kh28+HLJ7sY5bYc8RlNsKXbYOjsn3MJx3J4b7Oc2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awx+KoIsNGBSELkzXd9SxVw/gdo27S4pqWXKLsJ40eGVgekAPzkQww7TxtuQs4zs/
	 lnCiSBt9whdhaKCLWUhtE3vpZilFFiq1zNpm0Er2Z9HpaqFdCXa02yPpRrWFvrvsRA
	 vl2ZtNDM6UXqjL6M23A3bkCIaWd7+nk1rIjjBE4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Amitai Gottlieb <amitaig@hailo.ai>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.1 624/634] firmware: arm_scmi: Fix unused notifier-block in unregister
Date: Fri,  9 Jan 2026 12:45:02 +0100
Message-ID: <20260109112141.117627326@linuxfoundation.org>
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

From: Amitai Gottlieb <amitaig@hailo.ai>

In scmi_devm_notifier_unregister(), the notifier-block argument was ignored
and never passed to devres_release(). As a result, the function always
returned -ENOENT and failed to unregister the notifier.

Drivers that depend on this helper for teardown could therefore hit
unexpected failures, including kernel panics.

Commit 264a2c520628 ("firmware: arm_scmi: Simplify scmi_devm_notifier_unregister")
removed the faulty code path during refactoring and hence this fix is not
required upstream.

Cc: <stable@vger.kernel.org> # 5.15.x, 6.1.x, and 6.6.x
Fixes: 5ad3d1cf7d34 ("firmware: arm_scmi: Introduce new devres notification ops")
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Amitai Gottlieb <amitaig@hailo.ai>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/notify.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -1539,6 +1539,7 @@ static int scmi_devm_notifier_unregister
 	dres.handle = sdev->handle;
 	dres.proto_id = proto_id;
 	dres.evt_id = evt_id;
+	dres.nb = nb;
 	if (src_id) {
 		dres.__src_id = *src_id;
 		dres.src_id = &dres.__src_id;


