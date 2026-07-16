Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98C542589A;
	Thu, 16 Jul 2026 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211399; cv=none; b=PcxEnfpBfDL5MGDfx/RzQkxdFlGEHTbnHsY2BZ1E7LiBz0Vv6kD+hfn2kA6qrSvi/HqtPvR5JeZozFibg8X0P/bGdl+2vA6yxzC3boyrKS3IM91a0k+7gPGLV6gyaxqPAYTVigniwEQbSv1pyGyZf+r7njsk99hHCUojA16qZV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211399; c=relaxed/simple;
	bh=fcSoVlXPA3Lrq7uX0k1IudZBVa+ZO4MvRS9xMhGXA1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIqGWKIupcGdi0nq+4+fd05UyWTIm1klsd25qkDVSiIwWqSEIDjClKnENSKzPZygRRkpci/O6EiWBo8Ejj6eyf5RwscizJSctkoLX/eTM/XctR2tJwdCU2R2VHGec7EYV9f771uQAvN5vXvcnyB+0EKSO/j2OQP4xanRv5uWu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAW5IC74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAW5IC74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F011F00A3A;
	Thu, 16 Jul 2026 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211398;
	bh=yYmPxHL3pQm/lQLvfEaNC/zMSb8RSOHHu8I71CbhL8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAW5IC74dRRoZEJ80tRWAqjjrnyIch+QZex3JFHlCC2MzXF7n3iFKLXCSzzQq0yAQ
	 JOh90ONBgXF2d2qa+1J4PLro8bgB0kaGWglMTOWSTBRDLelsMA4lvjuJWDamhR98Ms
	 C0IekdPfygYUfy/hMCLLf8BvZScNH0jrJjkEofXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 411/480] iommufd: Rewind header length in done if iommufd_veventq_fops_read() fails
Date: Thu, 16 Jul 2026 15:32:38 +0200
Message-ID: <20260716133053.702951634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit 01e41ad76c12ae5c49ab4ef4fc7dd54e9b8784d6 upstream.

When the first event copy fails, rc = -EFAULT will not be reported as done
is set to the length of the copied header.

Rewind it to report rc correctly.

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/78f8caeb6a5d667a26b870e3068cec47dd4b5be1.1780343944.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -336,6 +336,7 @@ static ssize_t iommufd_veventq_fops_read
 		if (cur->data_len &&
 		    copy_to_user(buf + done, cur->event_data, cur->data_len)) {
 			iommufd_veventq_deliver_restore(veventq, cur);
+			done -= sizeof(*hdr);
 			rc = -EFAULT;
 			break;
 		}


