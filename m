Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043E2366DA5;
	Tue, 21 Jul 2026 15:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649056; cv=none; b=q/qRINC+SxYS4ZcR0fIahYQ6DLs8euO/h/a0IMsx0qbmbw38yLq/poQglBdwhLtOM5fVxDRP87u+GnSPvONJaPQkHv+VAC45t+3J9pcTbw3K0DqbafVHqRdWns8eMTjK8M/bI508zEpLa2AHVDzpSNJbVfqDC8UwVbAzQe7FtI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649056; c=relaxed/simple;
	bh=qvM604U7flrZCzF/9lt58I7EFee5MUrLcOcDA85CgBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjoe1n31uwmu5iTbM0fva7526bgXx3Dx4XgzyQZpFijauS5JRXLH02PHrMKcV+pHrTGy4+i+QTBVmzdDljEY8OsZDV3ufAbxqGQTDlFGh1ju8Mj7NMJmS+xycTfSuepsrjffx/nizfkyLSiD+2v766mfSMZQjRO3UEC/4t2wy70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJsk2rIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJsk2rIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D5C1F000E9;
	Tue, 21 Jul 2026 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649054;
	bh=dpc1WqePzXr67KpdHGSgpWxO/UshGT34QtKDW9TuRUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJsk2rIFMAJCwicuuJyQR7RQBNc4K30vAMBLip2dNwQBoBPpTyIeg4vI7Zktfa8WQ
	 QIiCtzVgsLMD6VFAu24IwhHcB4Qcb2VHQNruo5APjZHxTcEvRhda8bMtw2ADSsw/FC
	 c+EE5SLmpu1Qp23N8V7Mlna7QghCV6XgZrXayuOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0433/2077] scsi: pm8001: Fix error code in non_fatal_log_show()
Date: Tue, 21 Jul 2026 17:01:46 +0200
Message-ID: <20260721152602.964242016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index cbfda8c04e956a..c10854ec44c7bd 100644
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



