Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E623534D92D;
	Fri, 21 Nov 2025 13:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732121; cv=none; b=mLs3p+kEAS9g8h26jku7klXbdTl8w7ukSdAb0SPS6klvM68wpyAomRMtk34DZG6OPtXJDuqyWsGU8LByJOJJt5Nx32G+SGe9STcLHmVrzIioDjZm/Gsr6/e5G6tQ0yDIKvDQryDKDEzfMwcnoSWk8pLU8HrYO3962lbmvHVjapc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732121; c=relaxed/simple;
	bh=x/xHnD+5AtUkoGyAh5nVirLAeNLjek6udoNwXFnIYcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esuKTwfK6nyoIiEtZRHshQOuQh2jm1shhw3QhgghEJHFsZK4+X6TQ2QfYdd1zo7z+T9tOqZWv9jhZHAoqI30jUxGPFJOqp901j5Oa+6+wiWXU6+SkSR3g4dSbixbblPZroZAFgvL+/1GusRtYPFQuEQqrt/ysXRvQCLLBvmF0D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvrE9n2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvrE9n2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0DFC4CEFB;
	Fri, 21 Nov 2025 13:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732120;
	bh=x/xHnD+5AtUkoGyAh5nVirLAeNLjek6udoNwXFnIYcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvrE9n2W9KR6ih0Wo1EttSzAH9yknkRsuiTtl3aN9hyMbf4QQyA3uj1kMtaTKvOpR
	 I/HjN8qzinLixUR3Z8sTe5DIEKDNE3J9rXjo6xm+LS7IzoSMnm9eMs+DkBoDjCZ6G5
	 uC+nETX3rV3SKjXv4Qv3sz8HdPGRdjSgb+mUBtgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 011/529] fbdev: valkyriefb: Fix reference count leak in valkyriefb_init
Date: Fri, 21 Nov 2025 14:05:10 +0100
Message-ID: <20251121130231.401823629@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit eb53368f8d6e2dfba84c8a94d245719bcf9ae270 upstream.

The of_find_node_by_name() function returns a device tree node with its
reference count incremented. The caller is responsible for calling
of_node_put() to release this reference when done.

Found via static analysis.

Fixes: cc5d0189b9ba ("[PATCH] powerpc: Remove device_node addrs/n_addr")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/valkyriefb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/fbdev/valkyriefb.c
+++ b/drivers/video/fbdev/valkyriefb.c
@@ -329,11 +329,13 @@ static int __init valkyriefb_init(void)
 
 		if (of_address_to_resource(dp, 0, &r)) {
 			printk(KERN_ERR "can't find address for valkyrie\n");
+			of_node_put(dp);
 			return 0;
 		}
 
 		frame_buffer_phys = r.start;
 		cmap_regs_phys = r.start + 0x304000;
+		of_node_put(dp);
 	}
 #endif /* ppc (!CONFIG_MAC) */
 


