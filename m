Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE20F408035;
	Fri,  4 Sep 2026 05:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499931; cv=none; b=dgDVzx7zlILUF4y+DOLPxBbBBGG4udayjl441v1RtfbJhokT1eiebZ49heAHncQ8V66cGyfkMeb5jylush2A33xq739f3aaBK+kY91375EC50cqa+g3U9a46MUL3jbRA1eoZnlPV/obAG2on2RW0zrj0g0yj4Kyi/MqLBi7Neq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499931; c=relaxed/simple;
	bh=FtQSNWYZcUZxMpWKnQIvvlaCRpV7hZyypNCWFGb37DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srwfqocYDA/CjUEj5jdfN3MwEbUZa1TS5j4FkySWshgRm/3Pn8chEcdCjxd3x6BwzPrWOVhPtS/mwPyv0Py4QsZJXNGp8eBvPyrk0X13jHIcYdFVB93Ms6rbULvVaCbiFz+bbTYGanr/t9wTafGJ1CbiA/5xRPOEO0ZKQiCY32E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yD7Fp2G5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yD7Fp2G5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0563E1F00A3D;
	Fri,  4 Sep 2026 05:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499930;
	bh=PsrfMl8c+rJ4oi/HLJ/JFvTXmApCLvJVLXtnFOmDbds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yD7Fp2G5BhfX9am5uahVKq2AZJlj/+m0ePmtHz+V6o4Hyrz7zSM610CduGqAY/Y6C
	 YFaW1TlpiSOpfCci14tsjNoawd55jZRXKqiOvMTHvnJf8PFuL53pde7Lh43OANyN6X
	 XAVQP+HjR92RP5zXoEfCpYlHERVitDoOi1aXhJV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.2 547/713] iommufd: Avoid locking internal accesses during unmap
Date: Fri,  4 Sep 2026 06:58:35 +0200
Message-ID: <20260904045816.078676929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 0dbcdf4473a614adbd732d567c9b39ac0e040e0c upstream.

iommufd_access_notify_unmap() skips internal accesses because they do
not have an external unmap callback to invoke.

However, the current test calls iommufd_lock_obj() before checking
whether the access is internal. If iommufd_lock_obj() succeeds, the loop
then sees the internal access and continues, bypassing the matching
iommufd_put_object() used by the normal unmap path. This leaks the
object reference taken by iommufd_lock_obj().

Check for internal accesses first so skipped entries are never locked.

Fixes: 27b77ea5feaa ("iommufd/access: Bypass access->ops->unmap for internal use")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -1307,8 +1307,8 @@ void iommufd_access_notify_unmap(struct
 
 	xa_lock(&ioas->iopt.access_list);
 	xa_for_each(&ioas->iopt.access_list, index, access) {
-		if (!iommufd_lock_obj(&access->obj) ||
-		    iommufd_access_is_internal(access))
+		if (iommufd_access_is_internal(access) ||
+		    !iommufd_lock_obj(&access->obj))
 			continue;
 		xa_unlock(&ioas->iopt.access_list);
 


