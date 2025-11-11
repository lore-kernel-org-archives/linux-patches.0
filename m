Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC59473451;
	Tue, 11 Nov 2025 00:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822105; cv=none; b=uoGTInHINial4DsOB7ZqNyqwGNmNrWn/vUJQfySi2MAAO7fPNZiF/KHzUWjtGzWqhkd95qWEsNrUzqs9evURu0MIXDBTMqp2fIOIb7EghQpCDgvmLp9k04Y0yfOIPQ6LZKDiS92iczsUAbcNXNFsfJXdiBMg5mB9iHBTlADHPVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822105; c=relaxed/simple;
	bh=zKsOaSvfE5wsOghjwa0bt3wmrWytWY7PsyLlQMPWgSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOcCvCW7Xs2hDleQZVcxDcf/6A8+9F+iC/X1Tyzu93bnkinHApxf5JRei/gmFYqqdJ6Q1RsvsN9XXqKpcFhuOaFVuyBtx7VF7fmgC8xKdPQRbrp7q3dpBBuyLj+2KFQZ+W9pLc/AiWkAWG43Q14VC7Go7Hk9vgchoMMk56MhcNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKSTOj5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKSTOj5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077FAC19422;
	Tue, 11 Nov 2025 00:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822105;
	bh=zKsOaSvfE5wsOghjwa0bt3wmrWytWY7PsyLlQMPWgSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKSTOj5IvfAKqjxxkcYdHEnAF27DNpm40FB8GpNicKvcwjxpnnnPY5rNojnDH6fH9
	 KoCwuP6NfAv+eDld0GzkzeLjWnHcAFB8vIP8QvGosPOBJh0i1q+N+WHTHKk96cLyPA
	 sTmKLg5T6vlYBhh9ifzpFcOjlFSYaCP+dGX1i0so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.17 019/849] fbdev: valkyriefb: Fix reference count leak in valkyriefb_init
Date: Tue, 11 Nov 2025 09:33:09 +0900
Message-ID: <20251111004536.921235846@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
 


