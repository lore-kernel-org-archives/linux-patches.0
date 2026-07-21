Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EC246D544;
	Tue, 21 Jul 2026 19:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661841; cv=none; b=lr517XjGC8kokb4TdLdZi5fm1fPjrLRWZyFE9p9n7Vzw60U8uYGbPlh0oHmhyxacpthSJJ8r74KuVLejJJ3l2pJmx2WYXzMHI++iJ6Q6I71jNXuXGtGX7i8+Wel+AskZ/HPGPMKK891kv/Q/kaHDCFcQtuEoKr/ieH7HjFrqRIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661841; c=relaxed/simple;
	bh=T3LPZb2od7xpPV8ix/bahGo/n6w9kciYlhWk4Vuxw34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRzrSAPBuVuULuVzmIql+KEOSWf5x8aVWIeAogWBRitIV/rQfG5FuTBLh2VUxnmghlktar8rcixM0Mvltjf6fGXORKMwS1kBMFxoqrHhvBdfhX7C62eY17rQ2ZhUeRB149HwNi3DdPRiVRehG9HREmalwIwR4/eZJMB3JbH53UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WceVURc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WceVURc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0A91F000E9;
	Tue, 21 Jul 2026 19:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661839;
	bh=EdGJAFqzgKJv5VXbKPLft7xbM8Gs9a9M5qehPxY4rQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WceVURc5DQcdCj8sIcqEC5CHZ+BvS2cWCXozwC9pxMt8T3M+906bru7fTgP8nDwx6
	 AN7o5+Dl9MQVTFHyAxmP94l4TIK0yEbNvvhLn0H6EenhczkoQeKstN6NEh1jLBl6uF
	 OGd59VDf3FFB2GFR+7xaK9V5L3uHkv8sMFBaAeTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0217/1276] scsi: pm8001: Fix error code in non_fatal_log_show()
Date: Tue, 21 Jul 2026 17:11:00 +0200
Message-ID: <20260721152450.942989134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 34cddfdbc22f8c..4362bd6cc29e7c 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -588,10 +588,7 @@ static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);
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



