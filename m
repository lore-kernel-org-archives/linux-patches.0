Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077352EFD9C;
	Wed,  3 Dec 2025 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777356; cv=none; b=UkxNCm5Uid+LsSUmmrjiSrxALpUXss5F8AiX4aAuephMMBujSa9/iWZj9Us2MqM/6qCF2GUJfhylzRNqn3pCDfVjHXh6+JZ6ifguQtBN+zPjoAO9Wk7jlXxlSUVFQtXtCrtnHOrOXmpfh7gNODJ+Gvi067QE9mP+zfEciAzz6XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777356; c=relaxed/simple;
	bh=r5lXpIMFsjvZpt1/16clq1XRXahjI01tPApDT0Gb9wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txx/xqX/Mq7KCWPslCIU9NUoto3c/2/TydbqnMti8qZVv4x4SFRaKTmT6rVWAwZAE6RwIETwMg1k+ruc/CgagJPfDhosTOkcqduOxOBo6TogT7hwXhuyntdZ0Qdc8wQEqPH2btXRkoUoNrw3TDAf1YpRVLjsFcdpZJ1jxz2tZ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rMVnQTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rMVnQTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34173C4CEF5;
	Wed,  3 Dec 2025 15:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777354;
	bh=r5lXpIMFsjvZpt1/16clq1XRXahjI01tPApDT0Gb9wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rMVnQTLNrmDpabo2mL1QY1GstdFpSlrHy6eprFT4EPiSUb48Xy5Mb/yrzsNZUBU0
	 cvCtJHkG4ksuMnrIG36RrAoLSajBfZ2DqBMHJhvg5mKnaU27/2s6LTrfkj3WMprHht
	 f8A8eDosGYQ2rGzBzJTzZoUVAvmzmhkC34TtAP8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 013/392] fbdev: valkyriefb: Fix reference count leak in valkyriefb_init
Date: Wed,  3 Dec 2025 16:22:43 +0100
Message-ID: <20251203152414.592944698@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -336,11 +336,13 @@ int __init valkyriefb_init(void)
 
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
 


