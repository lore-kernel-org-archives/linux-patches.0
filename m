Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E8D330B11;
	Mon, 29 Dec 2025 16:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025090; cv=none; b=oYJMmFp+nrEQQDHsUgszmgCUMpw62aUQjuO+MnSkeJClx43tHXOKkZiioySeEwhLWluZNYM6agKy9bhwmqAEoHDautVsQVCkXKr1r+dmQm4dmxhB8EoThSx0ztOapUtOMNVvWBY4CMueqFVCoD/lJn5nlX2K2vkH86Nnv8oYHbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025090; c=relaxed/simple;
	bh=fkLaRjiY9cHHMu9aEbwBKIo+EaVcfbc4Me+Rh6BEnic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McpKnogSaVm+PArvdQqyGcJrzYjFDVsPMLQ/I/ANrDnQvcRnROuEybbPMlTLPEMPrx0OwwmQsJB4j++dD+8Ns4/UutyP4IL80dRDcptn/vS8OfICkRxgWh9mjAT9le2r0XSll/Dl68/E89ILb8k/jIeqHu9WltCl8/O7CKC4OG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0O3fEhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0O3fEhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E537C116C6;
	Mon, 29 Dec 2025 16:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025089;
	bh=fkLaRjiY9cHHMu9aEbwBKIo+EaVcfbc4Me+Rh6BEnic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0O3fEhXlXsB3rdGVuaGcllDMDv0mVNw0sct1P3rc/+XGtJ+Lr25FNmONmNXl47v9
	 bWbiTXyZnznjVV3O8q2b178nrpLbs7Iccv6gTa7+gFwyhc4nBxs8gZW1GtOc59lxeS
	 h1XFrtxvifBLL9GI99t+bJHInBrKG0lu8NkIqC90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/430] iommufd/selftest: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED
Date: Mon, 29 Dec 2025 17:08:11 +0100
Message-ID: <20251229160727.636961887@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit e6a973af11135439de32ece3b9cbe3bfc043bea8 ]

syzkaller found it could overflow math in the test infrastructure and
cause a WARN_ON by corrupting the reserved interval tree. This only
effects test kernels with CONFIG_IOMMUFD_TEST.

Validate the user input length in the test ioctl.

Fixes: f4b20bb34c83 ("iommufd: Add kernel support for testing iommufd")
Link: https://patch.msgid.link/r/0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Reported-by: syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69368129.a70a0220.38f243.008f.GAE@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/selftest.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index de178827a078a..dc0947aaac625 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1257,14 +1257,20 @@ static int iommufd_test_add_reserved(struct iommufd_ucmd *ucmd,
 				     unsigned int mockpt_id,
 				     unsigned long start, size_t length)
 {
+	unsigned long last;
 	struct iommufd_ioas *ioas;
 	int rc;
 
+	if (!length)
+		return -EINVAL;
+	if (check_add_overflow(start, length - 1, &last))
+		return -EOVERFLOW;
+
 	ioas = iommufd_get_ioas(ucmd->ictx, mockpt_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 	down_write(&ioas->iopt.iova_rwsem);
-	rc = iopt_reserve_iova(&ioas->iopt, start, start + length - 1, NULL);
+	rc = iopt_reserve_iova(&ioas->iopt, start, last, NULL);
 	up_write(&ioas->iopt.iova_rwsem);
 	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;
-- 
2.51.0



