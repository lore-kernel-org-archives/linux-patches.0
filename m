Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F3F4ED196;
	Wed, 30 Sep 2026 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787002; cv=none; b=JI6CwdNDd9BJu2RHW47CmMk4Lty5el3gAj4HdWohxK3GahFfF+QBT5R6QAG3qCj6beCMjrWjJoIiZcy8aMT+t1lJM0t5DIoDxsXV96vru6L7IB3gERnOEaH7TbPcixPzSvEu4LdzdGoPlTe5MIFSXk0QmjHOgTeIYdiv4pI4kNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787002; c=relaxed/simple;
	bh=06khQTLxPhgwd5w1p9dZ7S10RIesHt4V7DkHadfnZng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNIiOCt96DbEfJaNb0GbzkhDpUFFNnaWqVJRdoNdeV7w/8kDrJp+cg+MD9XRArty2LZBLzkgY9fnPS5CiP0FWc6q9HG9HJl6Fpnz9xhvWuSVeucaEz0/gBU9vgnx4y/+3/w9BanHKZpEKL8DO75AXurJ3h82NPqAzbBcXxjcJjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRVZBKxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRVZBKxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDB11F000FF;
	Wed, 30 Sep 2026 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787001;
	bh=HrUlEQUVTn5PtjyHmDwR9k3TQJOOejGckNKGz8dA0TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRVZBKxlKcZM9jb3cF8aFoYSt8szGWogOw/i3zpv1qXYFYW5KaeU92cDy3lSPwKBC
	 9FGBzz9Lk5E+zqrQZeCxhXcM4/Lv7gEWmuFzsmzTHyBHLGO2ASmMnX4V6LVKRwTk6V
	 kZCaAyzBJ/lQgeoIVr1U3GOsi4PWSX4o8yg+Fw+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 060/457] s390/cio: Fix cio_update_schib() to not cache invalid schib
Date: Wed, 30 Sep 2026 17:22:45 +0200
Message-ID: <20260930152347.334110233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index 70dc8cc765948..e1c62eb60cca7 100644
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



