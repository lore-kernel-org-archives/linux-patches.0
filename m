Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0049237F8C2;
	Wed,  8 Apr 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671802; cv=none; b=QypjDKa7rGjjFgzOhe8r1GZPMxt4SZ+YRKhBewcn58q55maFlj3viUNZqItL5ILH4+V3OeO+FeSQB6jBpLdvqSTY/IsmIlL79HCZAriqiohWuBl8KPkfodCyOFneGWaeKL+RwRF5tnLbMixf8/l+wSM8HFJjLyBJKzjI6/khq2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671802; c=relaxed/simple;
	bh=C5dVF9LnipiQ5pYWPzZvVCuRXBIWuQ3YsE0WHaVgAfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N21G8FYfKcbqgWKV5OwvBNLer9IZdHZTZwAfTF05C5TorFoGqxYvhgJoaVfTFxTnT4z9iX+YmScSptdXNujvGR0zYqx9e9cAxc558eFwFScNnOUwxv5+lpHI7VrZjjEGDlDQNtmF6ph+QPL6s7Iri5GmP22tH3kIKAqNb+guJEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBoxM3tG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBoxM3tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AD2C19421;
	Wed,  8 Apr 2026 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671801;
	bh=C5dVF9LnipiQ5pYWPzZvVCuRXBIWuQ3YsE0WHaVgAfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBoxM3tGqli48Y6v3raABuzDnyd2g6gYi795q3NEagCUaMc+a+XOQ9FUOPtD3Whvj
	 zQYt9MSWkC/Gtlxj4gppqR0yJpGNz05VanzANOe+ShEz/M71k0mcJCHafWzz/Dy4oc
	 vKEBd4fe9YUyS5PUenJZPG4xJjM2gSKvQsvCr8D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/312] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
Date: Wed,  8 Apr 2026 19:59:50 +0200
Message-ID: <20260408175936.468880629@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a19de2c70067..f11e74abb48c6 100644
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



