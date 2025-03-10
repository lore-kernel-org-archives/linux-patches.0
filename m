Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC23B22D4C3;
	Mon, 10 Mar 2025 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628590; cv=none; b=TuvovHTdfczxbQk+MMmiABDc2SXHSBtkFScPrrn+y9kZVE6rjdTTfsaDPkNUAHI/mQBR4sliMq5w6usgsGtLk58o6QDy+Jf8jQ/0F/Dir3qesJCL0Y/rmfrF7YdRYXRAWlXgcAvyhxGNJRzYK8jQ75oZ/rJX6TV/Um9F1AKWYeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628590; c=relaxed/simple;
	bh=Am4TlsNUEE8XvCjl78ti2bZnfX55CXUGpPSS+VcW6nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/62NNs4A/9kAlmNsVp/vnSEUktts0Mqs4WY3daLBbdIjB9cjx1JopJ4EZZgMy9X1zYE4rfy6E3Z/uVCM/zY6iOspWf7N75z4FStgzcT5+CdEdJGjcHFWNemXIZsyiADOZAm5zsNzE4oWBmKMM9pjzqNBN3dXLzejGjn4RDfH98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8V5zS9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8V5zS9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721CFC4CEE5;
	Mon, 10 Mar 2025 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628589;
	bh=Am4TlsNUEE8XvCjl78ti2bZnfX55CXUGpPSS+VcW6nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8V5zS9dAoKhyYQUEg6rYY4HdYH3YnSORq1/W1/vTRfEXdBVvq3d3saVlWikaWy6M
	 j508kD7xlfw6iBUp2LV51h4V2u3/X37ofs2pqgKfYNOVHGDFh9UC1e3NLbLHjiFbJH
	 qabDwnNe29NuM9wZlIZeIxmdWB2VpLgSOjatPefE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	stable <stable@kernel.org>,
	Fei Li <fei1.li@intel.com>
Subject: [PATCH 6.1 088/109] drivers: virt: acrn: hsm: Use kzalloc to avoid info leak in pmcmd_ioctl
Date: Mon, 10 Mar 2025 18:07:12 +0100
Message-ID: <20250310170431.065201395@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


