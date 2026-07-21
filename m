Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C40D3F825C;
	Tue, 21 Jul 2026 17:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654453; cv=none; b=rLz6lkR9pDnPV0avl2UxD5S793w2rG1f6OPU6oh1+94ucKVqlZwjs7ZVSED0XKB0M/SglOvTpr6WFDVS3zHcdbHe0dkGpwiXVS1fT8rwUzEsfzjIsh+upz8vyaHRzzefDTFrO7HxVcr+f9NbxjrhBZpAfOz4LsWHD/mtsF68S50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654453; c=relaxed/simple;
	bh=OSnTgpdaU8Zjf1YgMkkz6YPtHelWsBpoGUXdNf4Cx54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIsIRM/EUpkQk1J1UBmshZkqTKnnsd+cWqmb3qSuQ+AQu0a9f8nv2unRV96P/VIUUykc7nW6dU4D689tWVxAVtrfhusOS9L5M6zcIoteic0Ln9IDULalCZJW5QpPcYbRz6sCPR3iEu9vdjSNo/dMORN8dLjWVmiRcyxXd04ReTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmECg3IX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmECg3IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B781F00A3A;
	Tue, 21 Jul 2026 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654452;
	bh=0LZajdD0ZLcngHgiozHUNi76bwDvpWu8cMHYMyaz6Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmECg3IXsZdg8hBMPP9Y2nGGxToVy4mPq3GpspPK6jXw3DWqnecxSWa8XncgJjOrv
	 Wh1v+rzyOYBu/8jfQw/cd5Q2+WwT9E7PeWthaLP0+HEyWDRuAtmlRUHIjXfwIUgLLs
	 ABlSoyD8NyEBY/DxsTCRpKdepJVDWh60WBoR76Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Wasim Nazir <wasim.nazir@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.1 1667/2077] remoteproc: qcom: Fix leak when custom dump_segments addition fails
Date: Tue, 21 Jul 2026 17:22:20 +0200
Message-ID: <20260721152632.062478438@linuxfoundation.org>
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

From: Wasim Nazir <wasim.nazir@oss.qualcomm.com>

commit ecf9fc18e62c58eae1ceb65dab2bccb8a724de2d upstream.

Free allocated minidump_region 'name' in qcom_add_minidump_segments()
when failing before adding the region to 'dump_segments'. Otherwise,
the 'name' is not tracked and is never freed by qcom_minidump_cleanup().

Return error when adding to 'dump_segments' fails.

Cc: stable@vger.kernel.org # v5.11
Fixes: 8ed8485c4f05 ("remoteproc: qcom: Add capability to collect minidumps")
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Wasim Nazir <wasim.nazir@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260318-rproc-memleak-v2-1-ade70ab858f2@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_common.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -109,6 +109,7 @@ static int qcom_add_minidump_segments(st
 	struct minidump_region __iomem *ptr;
 	struct minidump_region region;
 	int seg_cnt, i;
+	int ret = 0;
 	dma_addr_t da;
 	size_t size;
 	char *name;
@@ -129,17 +130,22 @@ static int qcom_add_minidump_segments(st
 		if (le32_to_cpu(region.valid) == MINIDUMP_REGION_VALID) {
 			name = kstrndup(region.name, MAX_REGION_NAME_LENGTH - 1, GFP_KERNEL);
 			if (!name) {
-				iounmap(ptr);
-				return -ENOMEM;
+				ret = -ENOMEM;
+				break;
 			}
 			da = le64_to_cpu(region.address);
 			size = le64_to_cpu(region.size);
-			rproc_coredump_add_custom_segment(rproc, da, size, rproc_dumpfn_t, name);
+			ret = rproc_coredump_add_custom_segment(rproc, da, size, rproc_dumpfn_t,
+								name);
+			if (ret) {
+				kfree(name);
+				break;
+			}
 		}
 	}
 
 	iounmap(ptr);
-	return 0;
+	return ret;
 }
 
 void qcom_minidump(struct rproc *rproc, unsigned int minidump_id,


