Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050A313E34;
	Sat, 30 May 2026 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166055; cv=none; b=cZ70vyMpySlhVnmR3TDJu1hCnDE73S38vDtmNXtRZ9y1j1CUHkD555VudD8IHizeMFK2BqzjMKUt0LJWY0TlP3FGTvbVgCwJKUMxiLc5L/l3CaGtiCclb/KUKElxOe4m+NAeAVc9PCL5uu8W6FrNgEA5Jj07knek+NIoNjWAers=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166055; c=relaxed/simple;
	bh=xOJ2yEZs8o3Kv9TNWyxj1o7nXb9Flf6SVkSrxHSqoBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0r5K46SShqtYOoMlpFahwyXm2SBuV38maG7+fIOxGDdUB6BcqUjQz4fnTG/yDp+H2KKsPzeRJJrnCEYq3AyCsCVXO51EV+xC8U6ZDyNy0oHnsicMD3bHU3KyvRMYP23YufVSnE8SQPh4T299MhLJpBIIJK0/nDAgeZ/gPXwvBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxqR0QkL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxqR0QkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E9F1F00893;
	Sat, 30 May 2026 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166054;
	bh=PX2u+HBozrqvXuffqNhYZmfrdF1t/Z1zhrhsJOsIxb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxqR0QkL3uVvppWVExkMGrHUNpOZjx7/09GuoQ/mZ6shhQeFpBe4XZtwABh/eFvhv
	 OELxIr0RDxlDPBlv6+k0NJM58r/InL9ou7wq//kbj/jnHNTEWPtQ9+LUy+OhtkFB38
	 eJfVC5l4LoPcmO8Z8WPU6Y7zeIULH8UWOyp9KiHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 260/589] RDMA/ocrdma: Dont NULL deref uctx on errors in ocrdma_copy_pd_uresp()
Date: Sat, 30 May 2026 18:02:21 +0200
Message-ID: <20260530160231.802125728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 34fbf48cf3b410d2a6e8c586fa952a36331ca5ba upstream.

Sashiko points out that pd->uctx isn't initialized until late in the
function so all these error flow references are NULL and will crash. Use
the uctx that isn't NULL.

Cc: stable@vger.kernel.org
Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
Link: https://sashiko.dev/#/patchset/0-v1-e911b76a94d1%2B65d95-rdma_udata_rep_jgg%40nvidia.com?part=4
Link: https://patch.msgid.link/r/9-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -618,9 +618,9 @@ static int ocrdma_copy_pd_uresp(struct o
 
 ucopy_err:
 	if (pd->dpp_enabled)
-		ocrdma_del_mmap(pd->uctx, dpp_page_addr, PAGE_SIZE);
+		ocrdma_del_mmap(uctx, dpp_page_addr, PAGE_SIZE);
 dpp_map_err:
-	ocrdma_del_mmap(pd->uctx, db_page_addr, db_page_size);
+	ocrdma_del_mmap(uctx, db_page_addr, db_page_size);
 	return status;
 }
 


