Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2DF25DD08;
	Tue, 11 Mar 2025 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706562; cv=none; b=mIngBlVuVJYXV2ovgL7lLzPCN5Tw1ZYaLmzQz0FvVsjQVRy8jfPtqlz6nRoHSxPa/G2KYfABJBWAj2ILig9NnaMRWvvhf8bQooJ2XBW0jBb5LWyZfGiA9syvH0rIwxK84wQ9zZBO5dfP+u/6+l2UJ/7Fr4XCYlhLHzny5UqgNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706562; c=relaxed/simple;
	bh=BGr5/W22Wcjnx6nuwysj46qcK8d8OqYMjztTb8C19Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOexOxWpkMVtLSQX/DcMxOK9u48UP2nh5SnGmOMQG6OwKP1dFOY9IKbDnmcotGzXSyHLPhnUG1DbSriIH2unnCh7WuCuF57948Jinw+8xZ1/LKv8azTnwwOpW7W4ldYJafwbF5a69w+U42wXHqFfPi4tsDfmicnPUqGhfOFNaQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3YO+Pcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3YO+Pcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887EAC4CEED;
	Tue, 11 Mar 2025 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706561;
	bh=BGr5/W22Wcjnx6nuwysj46qcK8d8OqYMjztTb8C19Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3YO+PcgGDosEYRivqLStZzB9yAI/6PYFIVBFkEPWe+4KYL6LXG7vROah3e5VPYhd
	 lmLXKWM8sMYKaqZVTaq70IWZf21dQOeMDL7GIprU16GS2EVDiIIyznqH4bj4nhr0yz
	 jN6sp2C+4TmAhlYkao25KmkFIRAxl532dSQT2WEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/462] scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
Date: Tue, 11 Mar 2025 15:55:57 +0100
Message-ID: <20250311145801.948112666@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/ufs/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 5b2bc1a6f9226..05c7347eda188 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -213,6 +213,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
+		device_del(bsg_dev);
 		goto out;
 	}
 
-- 
2.39.5



