Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57854230BED;
	Mon, 10 Mar 2025 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627012; cv=none; b=X/6CliIEITxkL0ZwjiYf0siNGFxBJyofithwqZAuy+zzJYk+pnj+Ye8oGjesnGbSGSaeuj+gmJKeqZmSaX25KbJDpAl7gmXyIIEv0E02DNESlCtMPaLtlGt1OT/8ToK0c/ntUDKig4cPYGKJVY8BFRaG32zQTaSbNYYtK29OOMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627012; c=relaxed/simple;
	bh=I6kjLditApgbqYDjjquLZ928LOe/tlJYqTGnHvEOxYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOjeMC5EJ1c6ORAkaiVzHtYozxD1iZdSh2AA8nsrp/lxjx24x2jQjsvU7ihMjae2P9+u6PgdiGFkRR1HGqG2weSKWlcyQHI4o6M4rIixUnr1tn8nNZuJjBFZBtSVD6i6239R3hFTFyKPfO9XgAjtXXjOxryI6c0fHD7yeSlsts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/XG4Ypz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/XG4Ypz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D323CC4CEE5;
	Mon, 10 Mar 2025 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627012;
	bh=I6kjLditApgbqYDjjquLZ928LOe/tlJYqTGnHvEOxYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/XG4YpzIHybvja777ks+vgX5miT/86Xpnhq6thxgGexBk/fKfIX/IqdWiK/CDUrT
	 XihQOztWyegjb2eh8ZcN3nkINYroWVt8apzvjPIgA37qXT70hQvGoXvyt//wYjw8xM
	 T0wJLf7JN6cb/2se8xenHKTIBQ9Z52ltJt6Umk8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	stable <stable@kernel.org>,
	Fei Li <fei1.li@intel.com>
Subject: [PATCH 6.13 191/207] drivers: virt: acrn: hsm: Use kzalloc to avoid info leak in pmcmd_ioctl
Date: Mon, 10 Mar 2025 18:06:24 +0100
Message-ID: <20250310170455.374714209@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


