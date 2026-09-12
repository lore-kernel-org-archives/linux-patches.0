Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74366246BCD;
	Sat, 12 Sep 2026 10:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207279; cv=none; b=ghLcnY00t+zZ/V7VaznZAh/e98tPKRMBWTfoEUHanJIDJwmwQIYE81vNORIXM9MS9HZULdfLpZuWS/de5vdwXpilApxXqOIrcFKLogNt0XBJJgNv8+HbC7ZlBwetAWCcNwPrK1UAauyK9E4UG13Z1L363gSGO9onm9e/X2J2yCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207279; c=relaxed/simple;
	bh=DZSKEQNP9AQSUrdHZ1Gc6/CZqPQmDPMJf7xJD5Rh4jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEbH47/7+Z5+YtAqXZeuAAdHdgFkgHCFZURHmA9MW8cD4PN6HH0KT+3BJED2g2iUQTJKb5d+L8+dRc41FvUlAWKVgN7zZHw2p1v9F7mMvJGycdRxHYSLMhFmoxqa5gf4jciNalwdOMHs1uCYsYMe8yFfeAUU4ZqdPp4o2SvDe8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16CPj0xW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16CPj0xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602EF1F000FF;
	Sat, 12 Sep 2026 10:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207278;
	bh=AiOa1mI5QBCXhDEVV3yKCeiqzosIZ8ncfe+3HO7OjTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=16CPj0xW5oEFDlljN0vQDMFE/zYdsiq5SO0Im6mzKrNWalfM6SCu+IT6g6zspKXAT
	 4Po5NPiI37u/BJx1yWOQb8+wELxnCgX1Y/NxaV+M05N1rK2OvChq4Y/qx7G6k9a8cO
	 ALYgb8nCglsilZqelFQvPRZDjgUeMnM8EliThy3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0381/1518] firmware: arm_scmi: Free transport channel on IDR failure
Date: Sat, 12 Sep 2026 08:42:30 +0200
Message-ID: <20260912065632.080632589@linuxfoundation.org>
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

[ Upstream commit d72e7e5f24687c0490aabf317653caffe0447aeb ]

If transport channel setup succeeds but the following IDR insertion fails,
the error path destroys the transport device and frees the channel info
without invoking the transport cleanup callback.

Call chan_free() before destroying the device so transport specific
resources such as IRQs, mailbox channels and mapped shared memory are
released consistently with the normal teardown path.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-5-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 74a199ca4c76c..5d7f090e98ea8 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2719,6 +2719,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 			"unable to allocate SCMI idr slot err %d\n", ret);
 		/* Destroy channel and device only if created by this call. */
 		if (tdev) {
+			info->desc->ops->chan_free(prot_id, cinfo, idr);
 			of_node_put(of_node);
 			scmi_device_destroy(info->dev, prot_id, name);
 			devm_kfree(info->dev, cinfo);
-- 
2.53.0



