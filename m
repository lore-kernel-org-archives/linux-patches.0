Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B20192B75;
	Tue, 11 Nov 2025 00:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822252; cv=none; b=SsGCjxcY/ui3rSyDYlxwqxc20FQNvptmHoMI33GfWOs2X11pak7EApbMmIxeEO13QnsrnaikRjswgR09U2eONK7C7qsqeFfg7Q4tkvKn9DxuDRZjkh8RhRoiyu6REJK1LIsyZFliR/MY0wbR4ACirYTcSpgUVP1dSQr5XFZeKJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822252; c=relaxed/simple;
	bh=6YPsHpK+iHWaP9wXyy2Sc5O0eYATolZBahYKLlFE6mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAScd82E0Zu23EkI8i42HF0fbsJ+B76u3L42oP+k4sUHOdZwp/wqn4NhCJKvJN+LBGDP+xZ/TyP6k6stCGFs84L81Q08lXeS/drb40GOVptLxi+0JSumun0xeT0N8GAKG98wAprOmo2FoUvi8j1PV49B1Apy8hBMnBQ7SnE/k2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rX9vpvBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rX9vpvBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BB7C4CEF5;
	Tue, 11 Nov 2025 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822252;
	bh=6YPsHpK+iHWaP9wXyy2Sc5O0eYATolZBahYKLlFE6mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rX9vpvBFoOj9oDPwt0IzQo3pdBvhTlrQkDvOLmE5KkWT0bxIxsEBGkUqIb86FVzYP
	 qstbbf4diqDYnZCIWviI6dyq39noARRe7S9A+HUY+1hfjXc3cbuO6TGMNYZ9MoqxMQ
	 PVggFZEu4tghHbgqfoc+co3ylCyvpqtggOgQBQwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 012/565] fbdev: valkyriefb: Fix reference count leak in valkyriefb_init
Date: Tue, 11 Nov 2025 09:37:48 +0900
Message-ID: <20251111004527.135711341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


