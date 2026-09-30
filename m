Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652F75187D2;
	Wed, 30 Sep 2026 17:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789046; cv=none; b=RhDI44aQ16AI7vwm0nVCzDima0DTv61njPalvHyrNqeevNsJPYCL6/Po3yg0iksgepHsgl14H4pTYBZV01Gp6tM1PO6As+Z9sGC+3nNlzSA2h/oNyrW7X2HGBGCsgxgGZpCq6psKpyRTNQpZXe3eknScAS6cnRw7z6GZ+EwHcwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789046; c=relaxed/simple;
	bh=COL4jUfTYRuPwZOB7uA1flJJKQv+r+jci1GO0Fb7r9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxk3+euwzgyG0vH/ZMpeyacugkiUbkw6s/s22s0qRfJQyXzzTtJ6QCxZvcTnH6kWb/aTbtzcJfjMAjM5tc4YZb6jHtopOMjZM1G0P5Ghxlt1x//9Ctv1DusoIx8vzErSxBxCE76DH0uKF3yywgT0KPXoOBg9re39TJBwUcjX0ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/W/54O9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/W/54O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B921F000FF;
	Wed, 30 Sep 2026 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789045;
	bh=Hf06jl+hj7U2zu/lfeo7hLTb9xojhYQEPCVKOI67ukM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/W/54O9lGEMo2/Hq2uvMHSAGSv7C7rWbu0JCKFtvwe0MKwIL3hy+oRMKbSm9Co7O
	 +0NlYVPHwcQigWgM6GTSHVxLSHfoUpsB08kGHkuhJdHZqPEwS0+KnHD7vyA333Ii+1
	 /zmX+RZfuBHsOgM9WSKulsc+RZA2iPsgHBh5NqJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/877] s390/cio: Fix cio_update_schib() to not cache invalid schib
Date: Wed, 30 Sep 2026 17:20:49 +0200
Message-ID: <20260930152421.964747050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index ad17ab0a93149..700d8d4ba9da8 100644
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



