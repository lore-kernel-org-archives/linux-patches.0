Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CAD3BE642;
	Wed, 30 Sep 2026 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792411; cv=none; b=oAP5+sG7OxRW6MI+M/RolqqiFwEOLUMqjA4u3xFxlw89Dkl+al3JOz9aR3d9zMXfDhTx0U7mEp4Q07orpl1hb09y7aIytk9RQhXkAr8e69tYXKoaS6V6C9lhvwACPi35cztpFcRuRgeIyteTOn5oq1a3HyPxPlet+aI2WriByoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792411; c=relaxed/simple;
	bh=QRLKYZdmaUh2IU2cNHOoavrQ4BrpjfklRRwRhKhX7UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPvXbg8czPllII/pZzmVipFgQdu/Fi1Ap6kALsEXtmVhqlaqxPlydXN/7HxQxQdHqhRWncJ9/zwgTibAAmJa1H7MVzMgZ5qhfOGnWpXtOK52xihZxnQHsdJSj8PEuh0UgUxVOnVB5GWzKHMvnDj3r17ZWf6z0X7eRkUBvBzYLBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJ3lX+YS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJ3lX+YS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092791F000FF;
	Wed, 30 Sep 2026 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792409;
	bh=dEzif+u9P+B6Ucj2mm05h6N/1MHJrZyanOJWMYs/H1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJ3lX+YS1lVS1xt2byR2o2VjInD/KWgNsg4FvTX6Ianrnq0epzdiu9L/+q1QK2QKN
	 5YekJB89dFh5CgwdbGQiNSDeRVr5NN6TDYPfvNHGj1qc3lgCb2WqI3rYjDJ0Ld5jbN
	 CjGqjBlc60efot0x5+hKH/c79EvtduGhhsttYX9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 608/752] s390/cio: Fix cio_update_schib() to not cache invalid schib
Date: Wed, 30 Sep 2026 17:27:58 +0200
Message-ID: <20260930152411.439272673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 54bfa9fe3031b..dc798baf4d49d 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -453,7 +453,8 @@ EXPORT_SYMBOL_GPL(cio_commit_config);
 /**
  * cio_update_schib - Perform stsch and update schib if subchannel is valid.
  * @sch: subchannel on which to perform stsch
- * Return zero on success, -ENODEV otherwise.
+ * Return zero on success, -ENODEV if the subchannel is not operational,
+ * -EACCES if the subchannel has no valid device.
  */
 int cio_update_schib(struct subchannel *sch)
 {
@@ -462,10 +463,12 @@ int cio_update_schib(struct subchannel *sch)
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



