Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E966421898;
	Tue, 31 Mar 2026 16:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974434; cv=none; b=FK4/aBVhH1nhc0H7GcmXGmjQPoAooJmGIeEqGuqcZsRKKbYE0n4fvHI+xHrM9/BM8wQEP+juEwRFhBoUto14xVfQnNG58rnFQC1gESWldVI4ZHNjvuYf6Bxm1fomlK9p6ypk+9QJaXA/XYi7igCkun81C1qXpdQ8CjHQB2q9hHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974434; c=relaxed/simple;
	bh=9n5cjjdJdCuYw256NkUKHn4DHcj03yQV5tyBtX9BPiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqVSE5NfqxV4pXJ0eZH+9FrfyVJt3n+nNc5D0ufCn1Ugv5naoIwEQ/Ds4iAscupfHf6t1oJliJi/S6us8Yuo/278FvcBzO1uzIdJwZc7nybZUPQ1ao3SPVDzTN4YTDY89+IgZmb4GpOLU3C2TsCxmmGIzYwh3emAOT750ZBxWdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrutZpz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrutZpz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D7BC19423;
	Tue, 31 Mar 2026 16:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974433;
	bh=9n5cjjdJdCuYw256NkUKHn4DHcj03yQV5tyBtX9BPiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrutZpz/OFvJlVfLXrX6oct8JkpBSqLj3X6JI+n25XqYABs3OmOfnM/ZWgCFYJFDZ
	 Na/9DiIzAEoywxXes+DiaZeU4VzFAHdKIt21TK2AR85AKiYgGxncRQTGo2qDe6edwH
	 ZkMHJphC87/Ifk1XPAwZJlMVXN9yyT4TOVcH+DYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/175] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
Date: Tue, 31 Mar 2026 18:21:08 +0200
Message-ID: <20260331161732.859143959@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit d71afa9deb4d413232ba16d693f7d43b321931b4 ]

After commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard
and multi-channel scans"), if the device supports multiple channels (0 to
shost->max_channel), user_scan() invokes updated sas_user_scan() to perform
the scan behavior for a specific transfer.  However, when the user
specifies shost->max_channel, it will return -EINVAL, which is not
expected.

Fix and support specifying the scan shost->max_channel for scanning.

Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260317063147.2182562-1-liyihang9@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 7b4c4752e2160..a9eb548c0de9f 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1732,7 +1732,7 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		break;
 
 	default:
-		if (channel < shost->max_channel) {
+		if (channel <= shost->max_channel) {
 			res = scsi_scan_host_selected(shost, channel, id, lun,
 						      SCSI_SCAN_MANUAL);
 		} else {
-- 
2.53.0



