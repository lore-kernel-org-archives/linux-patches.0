Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401A1386C1C;
	Tue, 21 Jul 2026 20:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665897; cv=none; b=cO8jmZLc6aXsdIfd4dhzLUm4C4gjiUqw1lrbdafjpnNHoU2ulq7IBbsR7uDUkmo81a+EM8uHRtof5AyNaa4CmCu1icJNvdxEL4Hq6kML2BWra46KdujQ0aGeAIrZ0M4soHYTtLOBZwlgqGdKXsfDo4SdNUWS+f1B1aZDV7nU/Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665897; c=relaxed/simple;
	bh=4nz/ScEVslze7QoPNKeBRgZIqZAhf1K0eLGnkrsi05g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lulRSrVqZF0pUWmqhiDr2yl4aAhKUZagFZa3OHG1Yuto61ldV8SbkS9mJSGS15661l3eF0D4JD8TH3NZupRhAspgGDXwAPpfGWSeYIZyRikp5jx0PFFMWn3Txt44N4XigSfW6/KSyux6U1hBN3PrugIOaI/VEuq0bIfCocCSnQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBSrCVb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBSrCVb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7C81F00A3D;
	Tue, 21 Jul 2026 20:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665895;
	bh=jJ4T7Fi+6Y33bNeNeTMtkW9iHcHtOD2Ywt6jCI5c3f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBSrCVb0mYNVNo0trhNdUjmawh+JackRslsIntCsZ8SgXa4e0pRRbrRT8bJhq0mOq
	 bYEljvkSzK4qC1gGvSkkm/Mx+ylrhWq5e5ArHVxQjpwBqJI7lUTs0PVyLgrSWWW6Gs
	 nAELmhV4GZcqC5J4OeM29OH8d0bvPWnmk1VQ3w7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0477/1266] scsi: pm8001: Fix error code in non_fatal_log_show()
Date: Tue, 21 Jul 2026 17:15:14 +0200
Message-ID: <20260721152452.510514252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d3ff212d28b2e1..49e60976a61afe 100644
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



