Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EE746DFF2;
	Tue, 21 Jul 2026 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656738; cv=none; b=lf5Wr1R3jzd5d5ot0LQJgDwjKiKiICurOmJKvWLay6W+gGQ9N1aovpSOcqsa7VHPJeHPM1gJX6lWzBMpFYbvPr4nX+iGx1JBHKstilz6regm7NyYfcx+A9BO42+P6l5rAzhWSP1qrrRmMNlZQPkePIjuHcSpcbp1esHWDrsk/fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656738; c=relaxed/simple;
	bh=Uc3K0bhYUP9/6WLGBwCHbgfRCrAPp9z3Et02bGXe8ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4UJOnv3A+yI+ml8RD5+XIcco3xnQJS0vBOCJoSt4fB8XALIBNqsDt+kyEcF/v9rLaANszi2NOVM9MItN19n9iAxIvkXe13aQwmxA5KPsrt5xjRP9vKDHfh+u/ie4++NDdNNTko+Ftj1kr7s4Y3bRDX8piDvX04485OUG4yiRkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3IrEBWz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3IrEBWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CDB1F000E9;
	Tue, 21 Jul 2026 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656737;
	bh=GQTUyjPY6WAX7VG8Pn0HYTMyK3tlpLKErc9/Lmd+CHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3IrEBWzfektS/hBFbqVADQ93vOnutQyLwPzW0Zw9VjCQe61FVPJS4BDTm0aguV4c
	 ickhc5jb7Kg0mAETDjbXXZntYZEl8H6oZ4nyMpPNtGmMl73BSauJMyo37cFUfvJd3D
	 cOSLnIpKPbgCDGW96noq+6ash3Ot6fp8DxN7Uafc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0499/1611] iommu: Avoid copying the user array twice in the full-array copy helper
Date: Tue, 21 Jul 2026 17:10:15 +0200
Message-ID: <20260721152526.568012050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit e28bee5b445178390d63f7a93a5a219063c6434e ]

iommu_copy_struct_from_full_user_array() copies a whole user array into a
kernel buffer. In the common case, where user entry_len equals destination
entry size, it takes a fast path and copies the whole array with a single
copy_from_user().

That fast path does not return, so it falls through into the item-by-item
copy_struct_from_user() loop and copies every entry a second time. For an
equal entry_len that loop is just a copy_from_user() of the same bytes, so
the whole array is copied twice for no benefit.

Return right after the bulk copy. The per-item loop then runs only on the
slow path, where entry_len differs and each entry needs size adaption.

Fixes: 4f2e59ccb698 ("iommu: Add iommu_copy_struct_from_full_user_array helper")
Link: https://patch.msgid.link/r/6c9eca4ff584cb977661e97799ac6fe934e7f51c.1780521606.git.nicolinc@nvidia.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iommu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 66e4abb2df0dcd..84cf41f51f05dd 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -544,6 +544,7 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
 				   user_array->entry_num *
 					   user_array->entry_len))
 			return -EFAULT;
+		return 0;
 	}
 
 	/* Copy item by item */
-- 
2.53.0



