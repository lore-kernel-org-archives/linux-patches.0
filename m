Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF5D357CFC;
	Sat, 12 Sep 2026 12:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215467; cv=none; b=d6TElmtw1xG6OXAzkYvN+WetphAa2So614yeikR3v1cP1dJdED7zI7cjaV2h3wSzjV2n/DnCtw4bU2JCak8fCgWLXidqj33KyZNi5Q9pO4l4BMJJD9FnsAQ4vH08NuvLj4yW9BsdFlSgCkt7jsvO9nANgPbSdjwaPfxljPKBlkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215467; c=relaxed/simple;
	bh=ltQnPkA6gz2/rgzCNQ5HHClkqYtmlA1EEkYSV8O476c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9VsqVQ08NPKGtI7cU8PIYn6OhpNjzQ5RLyWRBc32smua3y2VjXZPWkSizFKQU87Gt8sAeGMXc54B2ZZKfKDmoMH9bUfDcoA378PUVwXBAtPNZoKC+4oWmaT5QSdpGsOqk4krL265j6b77UCj0ITi8Jsp0Hbb4KOGqxzECnDmhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGek2Cgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGek2Cgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D694E1F00893;
	Sat, 12 Sep 2026 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215464;
	bh=YOAyrWqgbjO/W/2DDcwSMC5PqW58Utcs2B3TCnuRBV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGek2CgrqkpaFAPt5Xg2STwpepKCS/4JuNxE6YsEP6QMnojihJCKxTBHrJQYilSnm
	 o38dFQPKFDf/WjV0dSZCVY1890iF6id9LgrIYa2JV2XsBNthQ7X4RWsbhrk/aDR+bw
	 wwNjqN7Jx0TVskiLxD9O0/ZVYcu7/ufU5xxOMBMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0537/1376] firmware: arm_scmi: Free transport channel on IDR failure
Date: Sat, 12 Sep 2026 08:49:23 +0200
Message-ID: <20260912065619.510858318@linuxfoundation.org>
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
index 5a44e10ed6041..c0be4584397d3 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2683,6 +2683,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 			"unable to allocate SCMI idr slot err %d\n", ret);
 		/* Destroy channel and device only if created by this call. */
 		if (tdev) {
+			info->desc->ops->chan_free(prot_id, cinfo, idr);
 			of_node_put(of_node);
 			scmi_device_destroy(info->dev, prot_id, name);
 			devm_kfree(info->dev, cinfo);
-- 
2.53.0



