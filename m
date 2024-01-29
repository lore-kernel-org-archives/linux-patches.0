Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A4A157052;
	Mon, 29 Jan 2024 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548027; cv=none; b=BzK1VPnfyhvCfjVz4XnbsaM1cPh6EMmYxwZXLmA2glsUaVD/+PXTp83o2Q1T7v8ybmRGuzwpfCkuFZgLqTwHvdPJR74KNGbkHdrWMTpEkuLxREOEnCv7Qez5v46wpL+dgJV4yoK0iOLeSBTpPj+m/LcM8cAGCOTvj7Gz/Cd8tCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548027; c=relaxed/simple;
	bh=crUoKidwCIzUjXDeqwz/jtpV2y4jV0iO0JlLeDX3Ugs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5etfr0ou7xOgkIrp77P2x+PyxhLoAJoRHcVUmEZsXXm0d1/ObYWiLf/pxkIlRQVpIILJkopSLhqa3UrJ+wPsoE21gEwLTNgI0Wf8IYGzLdQ+6OE3StuBhGVDfaPBwz5hP0dO7jxI6euHt6YmlZh7kxD9UOhZQqcPvxpVkNbvyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgH5H/Mn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgH5H/Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C186C43394;
	Mon, 29 Jan 2024 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548026;
	bh=crUoKidwCIzUjXDeqwz/jtpV2y4jV0iO0JlLeDX3Ugs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgH5H/MnPLLkskfB2+FhX34aWDQ9fBwCj1vfkSWX9+OU0FPOQiTyFOXAda5dSTrhm
	 gNU1ddAYjsFCUEQbMbO0tHr+7AOk3T06E0UYJWf438e4hqd+ehLTjfzQUHpwu1aa2o
	 I51wLEk3aKf3PbNeSX88DDhSIzM7eLBaE0pahPAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janosch Frank <frankja@linux.ibm.com>,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.7 020/346] s390/vfio-ap: unpin pages on gisc registration failure
Date: Mon, 29 Jan 2024 09:00:51 -0800
Message-ID: <20240129170016.965392342@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit 7b2d039da622daa9ba259ac6f38701d542b237c3 upstream.

In the vfio_ap_irq_enable function, after the page containing the
notification indicator byte (NIB) is pinned, the function attempts
to register the guest ISC. If registration fails, the function sets the
status response code and returns without unpinning the page containing
the NIB. In order to avoid a memory leak, the NIB should be unpinned before
returning from the vfio_ap_irq_enable function.

Co-developed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231109164427.460493-2-akrowiak@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -457,6 +457,7 @@ static struct ap_queue_status vfio_ap_ir
 		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
 				 __func__, nisc, isc, q->apqn);
 
+		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
 		status.response_code = AP_RESPONSE_INVALID_GISA;
 		return status;
 	}


