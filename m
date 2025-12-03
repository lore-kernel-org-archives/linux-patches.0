Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE6F34CFAB;
	Wed,  3 Dec 2025 16:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778756; cv=none; b=OsigCJRRjU+hGBF81E7hnJcBsl3Z0P4Yq6gthIGgSnI8YSiqXcJbp3aOBRe9shCdlPCBrpHuj6z++xv9oYEFHLOpK/jLP78h+TKH6oIDpwKmtvfiQu8lLcVI3fM6rE62JbI22KafHWXPXVZBdgQCRetZsFcNt5z97JU34045BNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778756; c=relaxed/simple;
	bh=sAb63ZfE01PW/IxPAlnwTBiaY4jDoyEH4rb9DfCHtpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsXyr6IEmXGbisZBoI2uFsJY0u4z4fyWk6Dpl/4FGv69896oV2jmrkk1hemVgBdYtvgf4wXjzNM/LSQxX6v3ly5kSfLHaVzNtAc2XfXuGpH1mFrrcsoAwWhmiTPg14NuoJIp6AA0j6w+hRI+/h/t9hu2O16BaSHEpJKvvTaaLTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5lQEFnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5lQEFnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7473AC4CEF5;
	Wed,  3 Dec 2025 16:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778755;
	bh=sAb63ZfE01PW/IxPAlnwTBiaY4jDoyEH4rb9DfCHtpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5lQEFnMsJSdn1W4ukcyCkdKMNzbo5DC/NAPh59nVqIcFqREiJLfRQKPXwCFukwGg
	 oVN7wbC56ih/ubTVnvpqkSxsRDFQWCuuwyoXoH6kSX/+fE6Z+06b2dDCM4D5Tfx1F1
	 zas/JcQMGzQ0yV1RjXwPYmMy9rTIRGZ98P8XegMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 032/568] fbdev: valkyriefb: Fix reference count leak in valkyriefb_init
Date: Wed,  3 Dec 2025 16:20:34 +0100
Message-ID: <20251203152441.847933534@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -331,11 +331,13 @@ static int __init valkyriefb_init(void)
 
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
 


