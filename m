Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619D3321A3;
	Wed,  3 Dec 2025 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777165; cv=none; b=V4xrZ1W3bb3CzZesO9P0219QWd8dw+pP2PglhPqjxyx1CanpVFfbE3IDtbtQsNrf33IskZLT295lJQYdDWfoZrKFF2WTnLKhX40LqSuzrNnip+CYcEbxvQenhONwmDQwpkQU10/6nHqTi2kezDc1O2i/ErCBr47VJagLPSp6ndA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777165; c=relaxed/simple;
	bh=OXvk9n0L3KAFyWc9WPkyIzpn/LE4Ia4wLctogkoQvRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YI7fi3QBRcdZ+vLcKU3d07gayr8jpxhU2OVqGPA1kP5Bg6EAE1IlsSAbkOribX1CaZqleZav0J8pjcZI8BuYBfeJQZ6Qb9Zt6G8FjYyXkn4QcYEBhuFwn61/05GD3K0oUl605H1E58Gg82vPz4lAgzclasI/WLactj/X0t/BX6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+7j8CVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+7j8CVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A3AC4CEF5;
	Wed,  3 Dec 2025 15:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777165;
	bh=OXvk9n0L3KAFyWc9WPkyIzpn/LE4Ia4wLctogkoQvRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+7j8CVHViFgPDRQglMKMHnt2mDmgaMAHbIS+xwijL+yUw39uwGh8aKUcN0naEEfg
	 yXT996XehMBa4erLRebzqcmPny5rrpiVWg4Z+n3jxDYnoe/UqzVu3oF3qtjKI4VLrP
	 uK9aJxIYNsorM/6I+BVRcyJnUXiTM9yT7Cxu7C60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.17 101/146] iommufd/driver: Fix counter initialization for counted_by annotation
Date: Wed,  3 Dec 2025 16:27:59 +0100
Message-ID: <20251203152350.156911806@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit ac84ff453305d12bc799074a9f9af30ff97fff70 upstream.

One of the requirements for counted_by annotations is that the counter
member must be initialized before the first reference to the
flexible-array member.

Move the vevent->data_len = data_len; initialization to before the
first access to flexible array vevent->event_data.

Link: https://patch.msgid.link/r/aRL7ZFFqM5bRTd2D@kspp
Cc: stable@vger.kernel.org
Fixes: e8e1ef9b77a7 ("iommufd/viommu: Add iommufd_viommu_report_event helper")
Signed-off-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/driver.c b/drivers/iommu/iommufd/driver.c
index 6f1010da221c..21d4a35538f6 100644
--- a/drivers/iommu/iommufd/driver.c
+++ b/drivers/iommu/iommufd/driver.c
@@ -161,8 +161,8 @@ int iommufd_viommu_report_event(struct iommufd_viommu *viommu,
 		vevent = &veventq->lost_events_header;
 		goto out_set_header;
 	}
-	memcpy(vevent->event_data, event_data, data_len);
 	vevent->data_len = data_len;
+	memcpy(vevent->event_data, event_data, data_len);
 	veventq->num_events++;
 
 out_set_header:
-- 
2.52.0



