Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4052309B0;
	Mon, 10 Mar 2025 18:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630988; cv=none; b=s/DxoTsz14uTBoVqXr/aUfpmPnYfxGqKuU3pxcbiZe8GOL8t5KOqD9uC5hGucGLsZDEX4WlzNiitLt5Fc3RjB8gARhJ0n3rdur2ojEuxKcKJMRAKo8JqcACHAUNjHZQaE7Arum8K5cbAkzh4K0yDIOanpAq7h2iBmuUENECGfRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630988; c=relaxed/simple;
	bh=5q4CTpx8W7e403c91zRQ37wMIJUeQXVURVrx0UinOO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRi//FFSYtpUMT1e1PZ2p5mBwx2vl7/iev1vMMrsnia7w9m1u3/bWeH8ANNsdvZq7W7VJOrCBHOsfxUezy/IE+bhA06Gg8PXI18foyTL0FcCZ0UpCbqmFYRnZTqrgXL481KjvNhqpIccEOxGhxZY5Gx/CBN1XzZP/i3txBP+ZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWwEhuKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWwEhuKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F39C4CEE5;
	Mon, 10 Mar 2025 18:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630988;
	bh=5q4CTpx8W7e403c91zRQ37wMIJUeQXVURVrx0UinOO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWwEhuKdop27N3wqNLNhEMG/eTYWk6TVartdwLx/GsL5opOTo4TqjAjbgXyETYuYD
	 HnYlKcURt/l4IPm5usQv4MqD1LH0B2qaJ+7OnykFIVGIq2CvTiwK3gbKFVLfepjkmq
	 Ux1tYD90u0E0bOtbSQdw+RgkLHw45nT8jKRDKB+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	stable <stable@kernel.org>,
	Fei Li <fei1.li@intel.com>
Subject: [PATCH 5.15 604/620] drivers: virt: acrn: hsm: Use kzalloc to avoid info leak in pmcmd_ioctl
Date: Mon, 10 Mar 2025 18:07:30 +0100
Message-ID: <20250310170609.373907782@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Li <lihaoyu499@gmail.com>

commit 819cec1dc47cdeac8f5dd6ba81c1dbee2a68c3bb upstream.

In the "pmcmd_ioctl" function, three memory objects allocated by
kmalloc are initialized by "hcall_get_cpu_state", which are then
copied to user space. The initializer is indeed implemented in
"acrn_hypercall2" (arch/x86/include/asm/acrn.h). There is a risk of
information leakage due to uninitialized bytes.

Fixes: 3d679d5aec64 ("virt: acrn: Introduce interfaces to query C-states and P-states allowed by hypervisor")
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Cc: stable <stable@kernel.org>
Acked-by: Fei Li <fei1.li@intel.com>
Link: https://lore.kernel.org/r/20250130115811.92424-1-lihaoyu499@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/acrn/hsm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/virt/acrn/hsm.c
+++ b/drivers/virt/acrn/hsm.c
@@ -49,7 +49,7 @@ static int pmcmd_ioctl(u64 cmd, void __u
 	switch (cmd & PMCMD_TYPE_MASK) {
 	case ACRN_PMCMD_GET_PX_CNT:
 	case ACRN_PMCMD_GET_CX_CNT:
-		pm_info = kmalloc(sizeof(u64), GFP_KERNEL);
+		pm_info = kzalloc(sizeof(u64), GFP_KERNEL);
 		if (!pm_info)
 			return -ENOMEM;
 
@@ -64,7 +64,7 @@ static int pmcmd_ioctl(u64 cmd, void __u
 		kfree(pm_info);
 		break;
 	case ACRN_PMCMD_GET_PX_DATA:
-		px_data = kmalloc(sizeof(*px_data), GFP_KERNEL);
+		px_data = kzalloc(sizeof(*px_data), GFP_KERNEL);
 		if (!px_data)
 			return -ENOMEM;
 
@@ -79,7 +79,7 @@ static int pmcmd_ioctl(u64 cmd, void __u
 		kfree(px_data);
 		break;
 	case ACRN_PMCMD_GET_CX_DATA:
-		cx_data = kmalloc(sizeof(*cx_data), GFP_KERNEL);
+		cx_data = kzalloc(sizeof(*cx_data), GFP_KERNEL);
 		if (!cx_data)
 			return -ENOMEM;
 


