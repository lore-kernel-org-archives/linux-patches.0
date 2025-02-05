Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA12F7DA6A;
	Wed,  5 Feb 2025 14:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765830; cv=none; b=W60WAHrnmLj+nklTyydtlqdJeRsVOnCFgECWh972UnegZbAhYNVQ2Xe9eWJRQHENWTmVB6v2AUrUiwONG1BbLqOO0zh9wQO5pVkWfgs0MjjmxLDG3tCDCaeB9134WbCLGdcQEpSH83im+IoExT9v7jRvabQFjdI0V2x7JrUZcg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765830; c=relaxed/simple;
	bh=j8lb/tAiNoZeduoXVjnI8yY1IrpadV0F3lmuEgw1Pag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGUkhdIsU60Waq8Y9dY2m7NT0dd9gpKlO0VwJAKVr53vUU9f/Ic47vVkyD6SnA9vB1pK5A1Pbn3VTQ8FZSkZJQsjr704kj2o5kTp9GpukUKzxP3NrVbsPwT+xcUXNtVGmkuwxLeqOXpGQZL1fmYp32xluKhXDz0og25aJoS/ooc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiB3bdG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiB3bdG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410A1C4CEE2;
	Wed,  5 Feb 2025 14:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765830;
	bh=j8lb/tAiNoZeduoXVjnI8yY1IrpadV0F3lmuEgw1Pag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiB3bdG2J9TNplrW9PriR+VIO9VtWIZwUuL1pcJJzyZnNWPuniWO/Gqm4ePhNse7X
	 /Vhp/qBc0ZCvVoRMYyIQjCkL39gaoYHsWIg7k3T40mQJYD0xebZlMCjreaCRUY9mWX
	 0H5p7dt6LSkT1naaDL/pl7Oa6opG4vXmH543m3e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/393] scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
Date: Wed,  5 Feb 2025 14:43:43 +0100
Message-ID: <20250205134431.942133611@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit fcf247deb3c3e1c6be5774e3fa03bbd018eff1a9 ]

We should remove the bsg device when bsg_setup_queue() fails to release the
resources.

Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-2-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index fec5993c66c39..f21423a7a6d7d 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -256,6 +256,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
+		device_del(bsg_dev);
 		goto out;
 	}
 
-- 
2.39.5



