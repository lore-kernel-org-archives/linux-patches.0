Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2118435C68B;
	Tue, 21 Jul 2026 22:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671552; cv=none; b=dDhWuAqB7Fgk+o/ndMu11wGw8eJn3Meg2ftqt+z2wXsOQ/SZfLyHGzI3IJ6fv1CUCH1oS//6eiMJVewoOu4YW7PoohHXs4sZYipmJnJmAAIPqLaBUH7DFBt2k5porqy9J69pf5kILqXcnshZeyRkCwLrriwScjfXqaBHFDpxkCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671552; c=relaxed/simple;
	bh=c5KMMz+97em5GPLR5aPAvIUNXpLOkwcKwBixrX7pIY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFY1HbYvuUG2mOOPy8eDldqaiDsrAfaBUYJkXr8b3dK3CoYoh42p6gA7ejNIVOaIiN4pkyU9ImfUBUeSpReKFbTGSa+gMAchWw5AOJD9npufodokIfjsiDwh/lpU0ouna31Nl1JeGQsqUlZ0H6a4fJ4GDcTmig2pSQhO6IooXVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kK9vj9E8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kK9vj9E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FAC1F000E9;
	Tue, 21 Jul 2026 22:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671550;
	bh=dslJYrLy7SfNdT16K7Zdf88dUhREbwZ+w2iZCzU6s7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kK9vj9E82pq79TntzduM0ORloRceHM9QORSUZXQDtQER1fOh+qdUK6ccxQxd4XwJ/
	 AkbQlDsE6jDkC4pV4S48hUZQ9tyyO6Cmwq2m0JlvJzn46096ceGQPlcBl1iNUuFZWe
	 TMAjH4Edarhp7TFJOUXArGwbvi6Isj8AFhJqDnAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/843] scsi: pm8001: Fix error code in non_fatal_log_show()
Date: Tue, 21 Jul 2026 17:18:44 +0200
Message-ID: <20260721152412.531102755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 1b6f03b7ae9ee27054c55bb55a69d05555a78516 ]

The non_fatal_log_show() function is supposed to return negative error
codes on failure.  But because the error codes are saved in a u32 and
then cast to signed long, they end up being high positive values instead
of negative.  Remove the intermediary u32 variable to fix this bug.

Fixes: dba2cc03b9db ("scsi: pm80xx: sysfs attribute for non fatal dump")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://patch.msgid.link/ahs-bEsBJH0KhnsX@stanley.mountain
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 082437c84f81e3..256ecb9134856b 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -590,10 +590,7 @@ static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);
 static ssize_t non_fatal_log_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
-	u32 count;
-
-	count = pm80xx_get_non_fatal_dump(cdev, attr, buf);
-	return count;
+	return pm80xx_get_non_fatal_dump(cdev, attr, buf);
 }
 static DEVICE_ATTR_RO(non_fatal_log);
 
-- 
2.53.0



