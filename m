Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A628827;
	Mon, 23 Dec 2024 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970631; cv=none; b=PbwHe2gxpGZaCignljslruMGFOV7nNriXeuuCkOQhFJ51n+a7u2sh3dqMNI2OY9Guo54rvd5uxzIbPhhjwFoKEW4qvL0XPzxz8y5wz7vQzI1JE0uIuL0hpt15r7ICqQxrHknweQakwd1TxcjgXvg03AkQEZgTUcHyI5FTQdbK7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970631; c=relaxed/simple;
	bh=TRWQ24fm+K9+EYpRzP0S3RbhFaDSvNtdqVx/f/TWAgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTEiRT1+MvNpZ9OxaIG1pFk9STw/GuJPAV1nFBo4i9fgRXGaBCJUhJVQ6vk5Jek38FpNpEYXYZcB8hb8/jzibjDtJHWSSn76hOcNRcyuKPMzeug/wT/SECIguy3lFepz2s8c197Bivow82SWOfdtVDOk2p+kiNnbKAnYSY6WDS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bci2If7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bci2If7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB51C4CED4;
	Mon, 23 Dec 2024 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970631;
	bh=TRWQ24fm+K9+EYpRzP0S3RbhFaDSvNtdqVx/f/TWAgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bci2If7ti+Ze3zg73uJiaTwrPvMUm5tGoiUlP15QlMRgfLQYAOuNgFgTFGqq5QgdF
	 C0CQ0FjL1j7Pu7wjgfqcKIpwO4BEALy86S47Gq9YEy9S/nCyeuLvNrq66rMm9aUU7t
	 bFNBSHJnSEGNUQ4s3uGvL6H+YkEbEPD7yLCzCEKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/83] net/smc: check smcd_v2_ext_offset when receiving proposal msg
Date: Mon, 23 Dec 2024 16:59:01 +0100
Message-ID: <20241223155354.489903387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit 9ab332deb671d8f7e66d82a2ff2b3f715bc3a4ad ]

When receiving proposal msg in server, the field smcd_v2_ext_offset in
proposal msg is from the remote client and can not be fully trusted.
Once the value of smcd_v2_ext_offset exceed the max value, there has
the chance to access wrong address, and crash may happen.

This patch checks the value of smcd_v2_ext_offset before using it.

Fixes: 5c21c4ccafe8 ("net/smc: determine accepted ISM devices")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c  | 2 ++
 net/smc/smc_clc.h | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 889709c35b1f..e2bdd6aa3d89 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2096,6 +2096,8 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	pclc_smcd = smc_get_clc_msg_smcd(pclc);
 	smc_v2_ext = smc_get_clc_v2_ext(pclc);
 	smcd_v2_ext = smc_get_clc_smcd_v2_ext(smc_v2_ext);
+	if (!pclc_smcd || !smc_v2_ext || !smcd_v2_ext)
+		goto not_found;
 
 	mutex_lock(&smcd_dev_list.mutex);
 	if (pclc_smcd->ism.chid)
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 08279081d438..0f6102cd5de1 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -361,9 +361,15 @@ smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
 static inline struct smc_clc_smcd_v2_extension *
 smc_get_clc_smcd_v2_ext(struct smc_clc_v2_extension *prop_v2ext)
 {
+	u16 max_offset = offsetof(struct smc_clc_msg_proposal_area, pclc_smcd_v2_ext) -
+		offsetof(struct smc_clc_msg_proposal_area, pclc_v2_ext) -
+		offsetof(struct smc_clc_v2_extension, hdr) -
+		offsetofend(struct smc_clnt_opts_area_hdr, smcd_v2_ext_offset);
+
 	if (!prop_v2ext)
 		return NULL;
-	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset))
+	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) ||
+	    ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) > max_offset)
 		return NULL;
 
 	return (struct smc_clc_smcd_v2_extension *)
-- 
2.39.5



