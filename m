Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ACE1AD41F;
	Mon, 23 Dec 2024 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970300; cv=none; b=pQiqHcbybXb/lUSDc8lyz/7BU6znguL8Eh7BGNzrox9suAbe/Opx490CNqluLheOhNDunJyx0LlXWZjWpFNx+h1tuY3R7opekGFA8ID/dz5PlaO0RXPl9k6a/AaOlViw8lPYzFqAgk+a7NUq7lKSZ711QEQd0KMzYQmzQ9B2xmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970300; c=relaxed/simple;
	bh=NzbjC5BaBJf7bhcqYmdTgfwf5sZcXhTK7BEUNfo9i14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5uuvLN6cNlWPWu4GgohZqm7S7mgOARQTW206NyrZ/CxIUajTcBc3maKnpRbNflwaURrSuFgSNtid3f5PUxDS+0fZzGwQSPhiFJRt842r3dAwAJsKwo/cfC8nYJ9SFhTl2ugq2Ppo+RRXLGEiYek0DITGLxU6qLqBdjAWpnvJJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMno+2D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMno+2D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0096C4CED3;
	Mon, 23 Dec 2024 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970300;
	bh=NzbjC5BaBJf7bhcqYmdTgfwf5sZcXhTK7BEUNfo9i14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMno+2D+F4TK8y9x/0I1SA7Fv2h0L00EvFzltg1IIBQbYWIizAp5BV8wKnyjQzJ99
	 99/t8HHoLK46TZd+Vs1Wk2OeGINQwr9zNg8LrWKFFGREF1g4vspHl0v/vYjrvAVR2o
	 YGdwdvSgtGJK8UeGx5QZfDWJ0Q9GPDyrYUDMpxXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/116] net/smc: check smcd_v2_ext_offset when receiving proposal msg
Date: Mon, 23 Dec 2024 16:58:33 +0100
Message-ID: <20241223155401.234973998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 079ca4f1077d..0acf07538840 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2154,6 +2154,8 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	pclc_smcd = smc_get_clc_msg_smcd(pclc);
 	smc_v2_ext = smc_get_clc_v2_ext(pclc);
 	smcd_v2_ext = smc_get_clc_smcd_v2_ext(smc_v2_ext);
+	if (!pclc_smcd || !smc_v2_ext || !smcd_v2_ext)
+		goto not_found;
 
 	mutex_lock(&smcd_dev_list.mutex);
 	if (pclc_smcd->ism.chid) {
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index a3706300e04f..6e24d44de4a7 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -384,9 +384,15 @@ smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
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



