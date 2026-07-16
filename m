Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A610425866;
	Thu, 16 Jul 2026 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211397; cv=none; b=UK4gGBZjvIfak5LKXYD5rqtwAlAF2cZKAy7z7oBrR9wwFGeb60ltPHYdM+LZtkufGegU4uIhU7uryj81Ncamnd9+1uiPLGM3gRciz8+vTFMiDe2ww/5IMPS6oM3yaWS1b7iEZBbWWBBJgNegIhbx2lUo9EL6nrssuINpr+TL9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211397; c=relaxed/simple;
	bh=wKCnVuMMvAMlsPs6U6bnxwlD7pKsqGgkjC7QbJVRnU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrUij/GK5bwKrnWOnmVaGmvBHKYqVDalB1xP3yF26x/mAky90vYst0ok0MYhaumXd93rayrQTERGdETP7aGfo1BB0GNFyhJoMyJjsvFBgrINT90OAY5Is1b5sm5F6M/jCmtxxPebLfGCQzmrYAaNGkO7r57ZYg7uDaGvbSg8OK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnY7yy6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnY7yy6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DC71F000E9;
	Thu, 16 Jul 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211396;
	bh=rt/oya6YpUmUqCZv22zvaKiKHZRRFpeUxJelbNqsVE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnY7yy6EtcgfKNPIqzRdQxfD747ZrY9U22xhDENT3FQ5otNK+lFUNXIV5jSxVU1+W
	 RHDhKhQpoIyVv86niSjjfpCcMKhCIEQfFRDChAH6n8yuCgXpebs39SGFdcoNgCXdMT
	 3iwSmerjPgj9278ceP8dX9ewRr21oLkzgvcf3LYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 6.18 410/480] iommufd: Set veventq_depth upper bound
Date: Thu, 16 Jul 2026 15:32:37 +0200
Message-ID: <20260716133053.681274929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 6ebf2eb46fbd5b40393ff8fbb847ba96925beaff upstream.

iommufd_veventq_alloc() accepts any !0 veventq_depth from userspace, with
an upper bound at U32_MAX.

This leaves a vulnerability where userspace can allocate excessively large
queues to exhaust kernel memory reserves.

Cap the veventq_depth (maximum number of entries) to 1 << 19, matching the
maximum number of entries in the SMMUv3 EVTQ (the largest use case today).

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/8426cbaa5e8294472ec7f076ef427cc473be5985.1779408671.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -473,6 +473,9 @@ int iommufd_fault_iopf_handler(struct io
 static const struct file_operations iommufd_veventq_fops =
 	INIT_EVENTQ_FOPS(iommufd_veventq_fops_read, NULL);
 
+/* An arbitrary upper bound for veventq_depth that fits all existing HWs */
+#define VEVENTQ_MAX_DEPTH (1U << 19)
+
 int iommufd_veventq_alloc(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_veventq_alloc *cmd = ucmd->cmd;
@@ -484,7 +487,7 @@ int iommufd_veventq_alloc(struct iommufd
 	if (cmd->flags || cmd->__reserved ||
 	    cmd->type == IOMMU_VEVENTQ_TYPE_DEFAULT)
 		return -EOPNOTSUPP;
-	if (!cmd->veventq_depth)
+	if (!cmd->veventq_depth || cmd->veventq_depth > VEVENTQ_MAX_DEPTH)
 		return -EINVAL;
 
 	viommu = iommufd_get_viommu(ucmd, cmd->viommu_id);


