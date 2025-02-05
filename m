Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5319A155333;
	Wed,  5 Feb 2025 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767299; cv=none; b=QEcI8w+J2EcrZ0SxEzzH5RiKmOf4NrMltC1QVbDvq0Rkg88AJZeGlDbx4+HNWBirX+vKyW1VRp5UrJe82Avwp6rc8QSFRbkp8z5VPu+Sw9dFJZE3j3orSvnP55xRg7JAiuKjJ+lf0KoBseT7isHK9sMtqN83pEYZhNmuKAI0Ln8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767299; c=relaxed/simple;
	bh=OLONQPg8e3IS7SFr3E/49DChGO8RArs/6LUe8IuFaFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctOZX4wEreY15RhRmiD7AB7rzrnppPuWzceK+Vvc4QUKON62g+IBuTB3Ms5/snpCkhuh2fod6bsUWeqPjay7OBTqat18xABkCGfkMJK9lYViXpuZN5ek9rV2lLltZZbm0LssGs5lyHTBM26PD8ZiUgkDCTiiiurb2itGYmT4CD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dT5yI4a8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dT5yI4a8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3351C4CEDD;
	Wed,  5 Feb 2025 14:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767299;
	bh=OLONQPg8e3IS7SFr3E/49DChGO8RArs/6LUe8IuFaFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dT5yI4a84k/4WmdBMZgC/C6QteJyIArY/BXq249zYlWNIbHmn9Fr278OiTD5gK9eZ
	 h3DUTW+bI8AWqx9ssVFx2Mfg9u9zXwQ1o9AFTYfizRyFS5iZ+L0T3D9jj0cnBbLYE8
	 1xbfSwuhHADQJPpRAjaWmVH2qpKFW7TM7AEttugE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 436/590] scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
Date: Wed,  5 Feb 2025 14:43:11 +0100
Message-ID: <20250205134511.948199951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6c09d97ae0065..58023f735c195 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -257,6 +257,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 			NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
+		device_del(bsg_dev);
 		goto out;
 	}
 
-- 
2.39.5



