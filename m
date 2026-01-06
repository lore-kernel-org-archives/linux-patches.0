Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CD3347BD2;
	Tue,  6 Jan 2026 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719868; cv=none; b=ENPUlm4kJrT+disbS/x9xO0Xm20rjS1PEH7mJ8UB68dVk1KnPWpP98kML3IrKzWm9N8CgaB2KNXnFNPSGp4o/ajmRTaFewel+QdJ/05jPpqIQOICeNCSMhes33hgroRVns69MfWENB8wQDzoByLXdiWWaHDhthcifOHh7SmUmoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719868; c=relaxed/simple;
	bh=pHIw12HanejFLQsg19ToERwDjXRZonZTPqmOFp/Jp6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEfSjFvCaOUUl2eU60sF1KM4Rq8CvAviCC+T2r8oA2IjxwRZVKcgZrkltHbn7X14o9mHxWA/+of8hrt0ONY9+T+ts0D0VNhSgNBuqNrQUBK+sIoROlE4pVmc/ohGI91u23DPs++jNR4azcgX0nOFafSqxirgTIfwWDkCSYJPb5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJlMmO7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJlMmO7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103FDC16AAE;
	Tue,  6 Jan 2026 17:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719868;
	bh=pHIw12HanejFLQsg19ToERwDjXRZonZTPqmOFp/Jp6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJlMmO7GtFAPEgrg8zR5t6c7jImkW6jrb25XEEmKA5ZboNcb4hLyyuH2SzZX08MUP
	 PYz2Xrs/MCHfUEpcO0i+qFIcKvGSrNY3a+FogwzdFYspWkJJ3v2FdzVzrc0svS3+2k
	 9Vb1SettM6HiakofUZhGsBd66RjRIkU0gX2Do2MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/567] iommufd/selftest: Add coverage for reporting max_pasid_log2 via IOMMU_HW_INFO
Date: Tue,  6 Jan 2026 17:57:25 +0100
Message-ID: <20260106170453.669478434@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 6d9500bb1ff8c7f9c3ce199521c41aa41e8fd994 ]

IOMMU_HW_INFO is extended to report max_pasid_log2, hence add coverage
for it.

Link: https://patch.msgid.link/r/20250321180143.8468-6-yi.l.liu@intel.com
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 5b244b077c0b ("iommufd/selftest: Make it clearer to gcc that the access is not out of bounds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/iommufd.c        | 18 ++++++++++++++++++
 .../testing/selftests/iommu/iommufd_fail_nth.c |  3 ++-
 tools/testing/selftests/iommu/iommufd_utils.h  | 17 +++++++++++++----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 7a535c590245f..92c6020c15fa1 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -194,12 +194,14 @@ FIXTURE(iommufd_ioas)
 	uint32_t hwpt_id;
 	uint32_t device_id;
 	uint64_t base_iova;
+	uint32_t device_pasid_id;
 };
 
 FIXTURE_VARIANT(iommufd_ioas)
 {
 	unsigned int mock_domains;
 	unsigned int memory_limit;
+	bool pasid_capable;
 };
 
 FIXTURE_SETUP(iommufd_ioas)
@@ -222,6 +224,12 @@ FIXTURE_SETUP(iommufd_ioas)
 				     &self->hwpt_id, &self->device_id);
 		self->base_iova = MOCK_APERTURE_START;
 	}
+
+	if (variant->pasid_capable)
+		test_cmd_mock_domain_flags(self->ioas_id,
+					   MOCK_FLAGS_DEVICE_PASID,
+					   NULL, NULL,
+					   &self->device_pasid_id);
 }
 
 FIXTURE_TEARDOWN(iommufd_ioas)
@@ -237,6 +245,7 @@ FIXTURE_VARIANT_ADD(iommufd_ioas, no_domain)
 FIXTURE_VARIANT_ADD(iommufd_ioas, mock_domain)
 {
 	.mock_domains = 1,
+	.pasid_capable = true,
 };
 
 FIXTURE_VARIANT_ADD(iommufd_ioas, two_mock_domain)
@@ -602,6 +611,8 @@ TEST_F(iommufd_ioas, get_hw_info)
 	} buffer_smaller;
 
 	if (self->device_id) {
+		uint8_t max_pasid = 0;
+
 		/* Provide a zero-size user_buffer */
 		test_cmd_get_hw_info(self->device_id, NULL, 0);
 		/* Provide a user_buffer with exact size */
@@ -616,6 +627,13 @@ TEST_F(iommufd_ioas, get_hw_info)
 		 * the fields within the size range still gets updated.
 		 */
 		test_cmd_get_hw_info(self->device_id, &buffer_smaller, sizeof(buffer_smaller));
+		test_cmd_get_hw_info_pasid(self->device_id, &max_pasid);
+		ASSERT_EQ(0, max_pasid);
+		if (variant->pasid_capable) {
+			test_cmd_get_hw_info_pasid(self->device_pasid_id,
+						   &max_pasid);
+			ASSERT_EQ(MOCK_PASID_WIDTH, max_pasid);
+		}
 	} else {
 		test_err_get_hw_info(ENOENT, self->device_id,
 				     &buffer_exact, sizeof(buffer_exact));
diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
index c5d5e69452b01..62d02556b34cc 100644
--- a/tools/testing/selftests/iommu/iommufd_fail_nth.c
+++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
@@ -612,7 +612,8 @@ TEST_FAIL_NTH(basic_fail_nth, device)
 				  &idev_id))
 		return -1;
 
-	if (_test_cmd_get_hw_info(self->fd, idev_id, &info, sizeof(info), NULL))
+	if (_test_cmd_get_hw_info(self->fd, idev_id, &info,
+				  sizeof(info), NULL, NULL))
 		return -1;
 
 	if (_test_cmd_hwpt_alloc(self->fd, idev_id, ioas_id, 0, 0, &hwpt_id,
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 40f6f14ce136f..8994b43e86f89 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -638,7 +638,8 @@ static void teardown_iommufd(int fd, struct __test_metadata *_metadata)
 
 /* @data can be NULL */
 static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
-				 size_t data_len, uint32_t *capabilities)
+				 size_t data_len, uint32_t *capabilities,
+				 uint8_t *max_pasid)
 {
 	struct iommu_test_hw_info *info = (struct iommu_test_hw_info *)data;
 	struct iommu_hw_info cmd = {
@@ -683,6 +684,9 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
 			assert(!info->flags);
 	}
 
+	if (max_pasid)
+		*max_pasid = cmd.out_max_pasid_log2;
+
 	if (capabilities)
 		*capabilities = cmd.out_capabilities;
 
@@ -691,14 +695,19 @@ static int _test_cmd_get_hw_info(int fd, __u32 device_id, void *data,
 
 #define test_cmd_get_hw_info(device_id, data, data_len)               \
 	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, data, \
-					   data_len, NULL))
+					   data_len, NULL, NULL))
 
 #define test_err_get_hw_info(_errno, device_id, data, data_len)               \
 	EXPECT_ERRNO(_errno, _test_cmd_get_hw_info(self->fd, device_id, data, \
-						   data_len, NULL))
+						   data_len, NULL, NULL))
 
 #define test_cmd_get_hw_capabilities(device_id, caps, mask) \
-	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, NULL, 0, &caps))
+	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, NULL, \
+					   0, &caps, NULL))
+
+#define test_cmd_get_hw_info_pasid(device_id, max_pasid)              \
+	ASSERT_EQ(0, _test_cmd_get_hw_info(self->fd, device_id, NULL, \
+					   0, NULL, max_pasid))
 
 static int _test_ioctl_fault_alloc(int fd, __u32 *fault_id, __u32 *fault_fd)
 {
-- 
2.51.0



