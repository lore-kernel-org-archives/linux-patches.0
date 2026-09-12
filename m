Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7711FCFFC;
	Sat, 12 Sep 2026 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223257; cv=none; b=PgWsSomen4xd5DqvC8UJZ3kTjKPx4R9mh21MOEnFzTDBmrVwBMxVPp9Xlu+ySQoEYWP0nAUQArqlidl2tgxOguTS4J/bL6Fx1nZEn1tBhCb5iQWf1Uk5cMc+9A673lmxNbRtYQyXVe8Bwo+rBz/eBJKsIO54SUg1yUE3s/t1iOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223257; c=relaxed/simple;
	bh=zZdfr0NwBeC3sLZD81EBdozY8GCzHMNIq3XYQvz/d8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQRW38VV0585wzp9l1+pjB3fDNtIunCBRCQVsPpNo/EvVIuZkfw+2Zc8eNV7InIt4SKH7g1x5A+OV7BztHfZyltsKUnPVyiAGnq99+6R2RigoIuuwmlRumjToBf2xBxhpDeurUq3JnMsstbtyriTJpDThpjlwS4a3i0bzpAbjpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uT1yKhiF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uT1yKhiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB091F000FF;
	Sat, 12 Sep 2026 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223247;
	bh=uJXBzkBZGYhxgTYXmUFQh4Y/14Xh5fY4qqFqKcB+soM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uT1yKhiFcqj/FUO7x0xRgana3BoUZKPYwODnFBaeBBZb62zf11xs9BexSsuQEbTfa
	 No0UILKiuqVlTNPCA0Rt36I0M3t/Pi/w+qahA/AmZAz8YkJZLsjUA3Uxswub0+pOTK
	 pg808LslRItmmRGKadic4KYbmqVqTGriXGA7ZhOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0750/1424] firmware: arm_scmi: Free transport channel on IDR failure
Date: Sat, 12 Sep 2026 08:53:02 +0200
Message-ID: <20260912065624.093182742@linuxfoundation.org>
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
index 4bc73ead390e4..639029defd3e7 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2463,6 +2463,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 			"unable to allocate SCMI idr slot err %d\n", ret);
 		/* Destroy channel and device only if created by this call. */
 		if (tdev) {
+			info->desc->ops->chan_free(prot_id, cinfo, idr);
 			of_node_put(of_node);
 			scmi_device_destroy(info->dev, prot_id, name);
 			devm_kfree(info->dev, cinfo);
-- 
2.53.0



