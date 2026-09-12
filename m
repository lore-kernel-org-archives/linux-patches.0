Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1591BD9C9;
	Sat, 12 Sep 2026 07:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198525; cv=none; b=iGrkZ/dQ6XP4Fv5bJIxuktQmmfBKofpMpmZLznI+MmEs7P3OyPesq/5Vu3CDP577YOrdG0d8Hju7jUB7Ltuc8k/8pEL482qjNCGiQ2+ohTb7TIXjJr93Ado2EzOAijFctpTl77ZeyZECz6B5PYCsEoEXoeJJJqhz2H5elsPfgDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198525; c=relaxed/simple;
	bh=Tk1kkEp4GgnODjo+vfdRpty212LWfd9kWwT7pLNMGGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC/qOi7T15HARr8zuvshaR+XC4da47t5sQPNwYdN8mIKO6f84+uoXANuE/HjiP8mlzZ6bbo8RTtEQI8FVlRl432aTQDYxquYocuhiq45zo7hdryAVpS4fNM3nMGpZtj8959lW9zHgDEwvZ2LvqR015tjd29SQDDbB7H1YsbXBng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAQ32TXH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAQ32TXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2753A1F000FF;
	Sat, 12 Sep 2026 07:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198524;
	bh=kw7v0yoq5MjzAvP40QELNeuweXcMy7ACh/R5CKLTjLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAQ32TXHDdMBmxRG9LgkgUlyPX8XIK1nC7bhBOHiIzfyWX/kqDFrXTMafEVe/9IYu
	 hkPDgQ3RY0r42ofVNBKS1u5vTkqAqcH0hSpDv4et38Yks96ZMTYiui7oYWCugwRRR6
	 G2+YeOoRWpixsPKazz4dJd/X7Yu7jj6+O1ad7p/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0397/1815] firmware: arm_scmi: Free transport channel on IDR failure
Date: Sat, 12 Sep 2026 08:35:47 +0200
Message-ID: <20260912065658.214370929@linuxfoundation.org>
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
index d2af47d03b4bb..6ee2152f6b01f 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2808,6 +2808,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 			"unable to allocate SCMI idr slot err %d\n", ret);
 		/* Destroy channel and device only if created by this call. */
 		if (tdev) {
+			info->desc->ops->chan_free(prot_id, cinfo, idr);
 			of_node_put(of_node);
 			scmi_device_destroy(info->dev, prot_id, name);
 			devm_kfree(info->dev, cinfo);
-- 
2.53.0



