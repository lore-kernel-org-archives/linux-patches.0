Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0883BCD0A;
	Fri,  4 Sep 2026 05:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501439; cv=none; b=jujT9MhBLDpbEsVMaqAOzEFAOBXzRZbu7kHiu1v3DDMVe1ITZP7BLI29/L3MZe/r32fnz1SCVpcB/kMAxEwzBuC2lkrDH/Rs6rZ/vFVvjuxcv9qE36J/ZkkZS29m3r8XwKrw3xT770mIwm3ZPpg0sTEWJrZY6+xBsVPV8U5qvCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501439; c=relaxed/simple;
	bh=Mx+/pqZWdulycNtwCv3kvYwOG77/qeKNsNinE2MjMsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTRKPvizSpGOYmtG47oU1wZ/oEMmFwZrOR7CrOCEdiploYGaCWJbPiHpyHRlxvrTAnoVusHhUTgNanALFlEK2pGaN8Fh5yEQ5V8oWj1vKwE7Eoe0y+nrb7lClLdbF20Kf8cwiAengHwHheKL2zZ2MOaDj5e8Mrf9Si8gDeOs6og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPpZkvWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPpZkvWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB8E1F00A3D;
	Fri,  4 Sep 2026 05:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501438;
	bh=4hCxqpFgii6fQgx0D4+8HoMQa8xesrhbNcfHD85oRc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPpZkvWD3LujIi8EOt7C/pA2/NxQRXLX0/ncE5FuXzqnbVbH3q3Ok7C+HA80i53aI
	 hdYLbkcPToJdMHZXOZVuuheKtsmV/pYyTcaRZzPO/CSEdxa0cDuGR0PBfGlIKHMewp
	 yKmQ3+16orIw2+CG3/rauHl/QFp8qHZrSMabcbXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 411/552] iommufd: Release current IOAS on xa_store() failure
Date: Fri,  4 Sep 2026 06:59:28 +0200
Message-ID: <20260904045759.938272747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 4ac2ce123824d5f885c868fa1f9f4d463141a2ba upstream.

iommufd_take_all_iova_rwsem() takes an object reference and the
iova_rwsem write lock before storing the IOAS in the temporary ioas_list
xarray.

If xa_store() fails, the current IOAS has not been inserted into
ioas_list yet. iommufd_release_all_iova_rwsem() only unwinds IOAS
objects already present in that xarray, so it cannot release the current
IOAS.

Release the current IOAS rwsem and object reference before unwinding the
previously stored entries.

Fixes: 051ae5aa73d7 ("iommufd: Lock all IOAS objects")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/ioas.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -433,6 +433,8 @@ static int iommufd_take_all_iova_rwsem(s
 
 		rc = xa_err(xa_store(ioas_list, index, ioas, GFP_KERNEL));
 		if (rc) {
+			up_write(&ioas->iopt.iova_rwsem);
+			refcount_dec(&ioas->obj.users);
 			iommufd_release_all_iova_rwsem(ictx, ioas_list);
 			return rc;
 		}


