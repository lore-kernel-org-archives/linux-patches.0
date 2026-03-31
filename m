Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE4E262A6;
	Tue, 31 Mar 2026 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975419; cv=none; b=MxO6NE1k5fJGCJfi2At+ESXxVTPkKpElj0D6mlgs05x5WxE3aXvzXrtsU6HKQaAvkeFu5ICL9j6kVeVCPDj3JXaglqolHI4OC0f42+7gP4dtXMMLR5/Zrk0kvPdNRsdQPO8TU1QXX6eM/aSZPTlBVkCq4XWUKxWSP2xUv4RbSL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975419; c=relaxed/simple;
	bh=g21HwWCGFDaZacMbFxOU6NS1W1zsHexxACT4dbB/g50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1bj92AuVxMq5AwXppKyysXoyyij+wcvi9urqJW7ckyf9KahDDnQr/Z50LjfpHBQ29ZlnzxyHj7ZLkV1kWbI8vWpwVXYE3AxXwddOcZXwvk+kkxIQbR2U71RdmdiIaC6a/uzB3SzGP4Jxxy0ohuy0ugi/flnahpIoLszk+cmySU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tlPvs0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tlPvs0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FAEC19423;
	Tue, 31 Mar 2026 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975419;
	bh=g21HwWCGFDaZacMbFxOU6NS1W1zsHexxACT4dbB/g50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tlPvs0dXSHzC8ODFXaLmNnorsv9vEgjh6CZlp1tvUWUs8sYKECZT1WK7HAnDMvT7
	 uQ8QGocXedmqNvuxj5/nu1snrmpyGaU5iWfzddwJmnh3gDbEB8Vd++zrdHDyUR0mfn
	 YkTyFGsIcbQBcKQqt7LCZjAf7lkHrg1Y0UFz9u7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.19 287/342] xfs: fix ri_total validation in xlog_recover_attri_commit_pass2
Date: Tue, 31 Mar 2026 18:22:00 +0200
Message-ID: <20260331161809.500399514@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

commit d72f2084e30966097c8eae762e31986a33c3c0ae upstream.

The ri_total checks for SET/REPLACE operations are hardcoded to 3,
but xfs_attri_item_size() only emits a value iovec when value_len > 0,
so ri_total is 2 when value_len == 0.

For PPTR_SET/PPTR_REMOVE/PPTR_REPLACE, value_len is validated by
xfs_attri_validate() to be exactly sizeof(struct xfs_parent_rec) and
is never zero, so their hardcoded checks remain correct.

This problem may cause log recovery failures. The following script can be
used to reproduce the problem:

 #!/bin/bash
 mkfs.xfs -f /dev/sda
 mount /dev/sda /mnt/test/
 touch /mnt/test/file
 for i in {1..200}; do
         attr -s "user.attr_$i" -V "value_$i" /mnt/test/file > /dev/null
 done
 echo 1 > /sys/fs/xfs/debug/larp
 echo 1 > /sys/fs/xfs/sda/errortag/larp
 attr -s "user.zero" -V "" /mnt/test/file
 echo 0 > /sys/fs/xfs/sda/errortag/larp
 umount /mnt/test
 mount /dev/sda /mnt/test/  # mount failed

Fix this by deriving the expected count dynamically as "2 + !!value_len"
for SET/REPLACE operations.

Cc: stable@vger.kernel.org # v6.9
Fixes: ad206ae50eca ("xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -1050,8 +1050,8 @@ xlog_recover_attri_commit_pass2(
 		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		/* Log item, attr name, attr value */
-		if (item->ri_total != 3) {
+		/* Log item, attr name, optional attr value */
+		if (item->ri_total != 2 + !!attri_formatp->alfi_value_len) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;


