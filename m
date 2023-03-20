Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DE21C35
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87910C433EF;
	Mon, 20 Mar 2023 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326120;
	bh=4XAeS5PnLLJmS01mRlXTESvH5s233f4+GfvSxYBTRTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4BvjJIJpPICpJ3u5MJ+Hu24PfC5i3RrlgQjcrA/8tB8Ju/h96Slmvti+VVGKH16a
	 Sb4a8KEikWK1TVyHAlPKrXlmdsrNeUa7SbInDJiW/Nj2yLj7P2O1qluURM6LLUezt6
	 X3Yc5xrBE8wOtlHH5+oOZBMbXttn7KvgJ18SaMAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fagnani <matt.fagnani@bell.net>,
	Vasant Hegde <vasant.hegde@amd.com>,
	"Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 166/211] drm/amdgpu: Dont resume IOMMU after incomplete init
Date: Mon, 20 Mar 2023 15:55:01 +0100
Message-Id: <20230320145520.387313678@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Kuehling <Felix.Kuehling@amd.com>

commit f3921a9a641483784448fb982b2eb738b383d9b9 upstream.

Check kfd->init_complete in kgd2kfd_iommu_resume, consistent with other
kgd2kfd calls. This should fix IOMMU errors on resume from suspend when
KFD IOMMU initialization failed.

Reported-by: Matt Fagnani <matt.fagnani@bell.net>
Link: https://lore.kernel.org/r/4a3b225c-2ffd-e758-4de1-447375e34cad@bell.net/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217170
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2454
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Linux regression tracking (Thorsten Leemhuis) <regressions@leemhuis.info>
Cc: stable@vger.kernel.org
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Matt Fagnani <matt.fagnani@bell.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -59,6 +59,7 @@ static int kfd_gtt_sa_init(struct kfd_de
 				unsigned int chunk_size);
 static void kfd_gtt_sa_fini(struct kfd_dev *kfd);
 
+static int kfd_resume_iommu(struct kfd_dev *kfd);
 static int kfd_resume(struct kfd_dev *kfd);
 
 static void kfd_device_info_set_sdma_info(struct kfd_dev *kfd)
@@ -635,7 +636,7 @@ bool kgd2kfd_device_init(struct kfd_dev
 
 	svm_migrate_init(kfd->adev);
 
-	if (kgd2kfd_resume_iommu(kfd))
+	if (kfd_resume_iommu(kfd))
 		goto device_iommu_error;
 
 	if (kfd_resume(kfd))
@@ -784,6 +785,14 @@ int kgd2kfd_resume(struct kfd_dev *kfd,
 
 int kgd2kfd_resume_iommu(struct kfd_dev *kfd)
 {
+	if (!kfd->init_complete)
+		return 0;
+
+	return kfd_resume_iommu(kfd);
+}
+
+static int kfd_resume_iommu(struct kfd_dev *kfd)
+{
 	int err = 0;
 
 	err = kfd_iommu_resume(kfd);


