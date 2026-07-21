Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B5846EC78;
	Tue, 21 Jul 2026 18:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659784; cv=none; b=f/2HkCZeV3IqJl9f61nRhtM5nzwp8rQ+C8uqOZih8BJCDkQmOJ3WNUiNbRvX8LqsyQIhvttc+p3wKzv6sO2O4pj5cUx1A+jIIYSe157BPm74oUwXckGs1DGHwQ3vb+Sg/IJPXb91dHbdxG/5v051PgT2hDDHoezsAUUFh2PnoYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659784; c=relaxed/simple;
	bh=RKz0f8iXTuwCtz4hExSHccaBAtTkCVVOgNXgt/84FuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldr9X3Uupcp9FPdcMkLqnpMxE1/QjUbglUiyZ+RPK6DoNbXqOqgdbjXNHeypN6rIOPLx6/duPnKXeUlmfcS/LboGIRPeN5WMLJ9pOYpaNsLukuiePtOX47Yq5Fn41CR2bB+xzWROdDcbPTBw8EowHt8mN3F1EIpWpfv7nSreIuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9aA8OE1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9aA8OE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCFC1F000E9;
	Tue, 21 Jul 2026 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659783;
	bh=4cuWdsNSyUUG+z1EtdJP0aOBxGRJKHIfyhwUUoiLvkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9aA8OE1WiYlRz59HszUO6aTKOfiTpyyJhFS9w25LikSaVBvofvxTPZkk3y464Gry
	 6l1rMwKMNoJqaJ8GBW8IULTztmbKK9SGN+muJSPhedXRjwE/8JOcFHyKoNF/dgKhzg
	 MvCF9IVAQPMNNitMljB/5VMYRcBfa9GOS5lEm2E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0730/2077] iommu: Avoid copying the user array twice in the full-array copy helper
Date: Tue, 21 Jul 2026 17:06:43 +0200
Message-ID: <20260721152610.016365231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e587d4ac4d3310..6957144263793b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -547,6 +547,7 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
 				   user_array->entry_num *
 					   user_array->entry_len))
 			return -EFAULT;
+		return 0;
 	}
 
 	/* Copy item by item */
-- 
2.53.0



