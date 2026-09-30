Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEA151FCCE;
	Wed, 30 Sep 2026 18:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792864; cv=none; b=GPPwk+CGcyY3EpJBLNXmRzEP78A1ugQx9lm7GiHowproysaRZwSxCMqRZTXu5SdaHUxLWUd/LPcMC1JMxjZTr564fGYLrNjjjHlURa4MedzarhEj0SzySzLcq2KowQX791RL0478O6dd1lzVOh6HJsTCEgdIWHvxf9oImz54JKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792864; c=relaxed/simple;
	bh=bA2sGCtxrJvAPqfh2mNSjQcT/xbQMCFtxaO9vAmPDkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWJ3+6wmpl8Gc/Dh6UQlpPfGWZx/NmawjAJb419Dsvw/YiLYQZf78ohyBtmH4RvkBDkBGGUCzEDtYBeOWXkIEKPayQ8b+vBCmkCfGvRkfmUj/AKpbvcpirj4ujEaQILXUW9rMsAPy1B5DvtOA7QfEE16AsCzmZ2TMZGhyZ21zHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scSPcAp5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scSPcAp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5D91F000FF;
	Wed, 30 Sep 2026 18:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792863;
	bh=72oU6ZW98SaO0apCXxmzmkl/Z+bP4ZLsRwNdFenndYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=scSPcAp549RSB8GWdgKqu7mCTjY6QXF5sNIzT7YanLWVtI68rvqV+YbMSYmHDfPzi
	 08uXrukbx1wU/e5JApeyNmdQZMsEe26lUOk+bEbq+GpxEdnl0Td4JNYhumyrYozYmm
	 GQLzynVAaQXpPBJcf0mSCuZ9j+jaUMrVRfAp/IOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/395] s390/cio: Fix cio_update_schib() to not cache invalid schib
Date: Wed, 30 Sep 2026 17:25:14 +0200
Message-ID: <20260930152341.765128205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 29d9e5835d89223aa913dcf7b942cc1c148bdd25 ]

When pmcw.dnv is 0, the contents of all SCHIB fields are unpredictable.
Zero sch->schib in that case to prevent subsequent code from making
decisions based on unpredictable data.

Reported-by: William Bezenah <wbezenah@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Fixes: 8c58a229688c ("s390/cio: Do not unregister the subchannel based on DNV")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/cio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 21508e4606d59..20ebe0d883c64 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -454,7 +454,8 @@ EXPORT_SYMBOL_GPL(cio_commit_config);
 /**
  * cio_update_schib - Perform stsch and update schib if subchannel is valid.
  * @sch: subchannel on which to perform stsch
- * Return zero on success, -ENODEV otherwise.
+ * Return zero on success, -ENODEV if the subchannel is not operational,
+ * -EACCES if the subchannel has no valid device.
  */
 int cio_update_schib(struct subchannel *sch)
 {
@@ -463,10 +464,12 @@ int cio_update_schib(struct subchannel *sch)
 	if (stsch(sch->schid, &schib))
 		return -ENODEV;
 
-	memcpy(&sch->schib, &schib, sizeof(schib));
-
-	if (!css_sch_is_valid(&schib))
+	if (!css_sch_is_valid(&schib)) {
+		memset(&sch->schib, 0, sizeof(sch->schib));
 		return -EACCES;
+	}
+
+	memcpy(&sch->schib, &schib, sizeof(schib));
 
 	return 0;
 }
-- 
2.53.0



