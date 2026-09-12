Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101AD47B425;
	Sat, 12 Sep 2026 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218002; cv=none; b=A61D8Hay213pHTwZLJSW6DzOgEF771qjn45QGrfPnLq+3ipNZN/8gQz35KcgOL5SEE6L9x1FWZ6gxW5bQ+LJdTnBJhA2CgpNo3k43NVq49v+OxeMW89nopn19QMPWzyr/RrmAhG3KMNP0H67Yw9VNPKk6wZX+MJBaIa72yMyBc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218002; c=relaxed/simple;
	bh=ZgJoOhOYqw8GlJJg/ewhQgnT3JI54T94HnYPo812fLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLoB4mBB7mo+U9KpKNF94VDoQ2c6xCBEX5CNQ885v2wLZQauhBpjFw1cAcMyP/HRQWrOPgWJb9tJg9EvBwmql1aGdFOfI1QLk92QcuqH8i/XbCuHLZ948lNNM6Z8LYhQXIBfrRuMwbequzd/K2+Zvub545RVMi2g3PoL7f09+JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSE09oEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSE09oEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86A21F000FF;
	Sat, 12 Sep 2026 12:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218000;
	bh=4VhYxa5StZRRUmXai6PpNyTEG4uhVXLDAMozmtnzU1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSE09oEI0yxn/lOOrtmDW7vlCdVXRjM0wLLEAzCaObXfraZ6V59KUlEaswbQj5Yh3
	 nkc57vpIKa1XsqFUQN7RGp6Ma/khjGZtSYGgJNQZ3Oe/14qRPqiVEy2MR5l7lD3mrr
	 cDkQOHhLB0rJT9DY5WrwXYTGjb8/0yCEVwdZitBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1054/1376] nvme: introduce change ptpl and iekey definition
Date: Sat, 12 Sep 2026 08:58:00 +0200
Message-ID: <20260912065631.050890034@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 7d2f9f870f26798699585f96fa7a2a2cab38dc02 ]

This is for the next tuning pr code more readble patch, make
linux/nvme.h's changes separately.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5bb96cc21883 ("nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 0095ce3748a10..7912620137697 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -2106,4 +2106,13 @@ enum nvme_pr_release_action {
 	NVME_PR_RELEASE_ACT_CLEAR		= 1,
 };
 
+enum nvme_pr_change_ptpl {
+	NVME_PR_CPTPL_NO_CHANGE			= 0,
+	NVME_PR_CPTPL_RESV			= 1 << 30,
+	NVME_PR_CPTPL_CLEARED			= 2 << 30,
+	NVME_PR_CPTPL_PERSIST			= 3 << 30,
+};
+
+#define NVME_PR_IGNORE_KEY (1 << 3)
+
 #endif /* _LINUX_NVME_H */
-- 
2.53.0



