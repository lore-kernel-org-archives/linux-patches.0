Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C4A30BF6F;
	Wed,  3 Dec 2025 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775868; cv=none; b=lnkr223XpPGTuvhG2uz39rAyeV9sH2FDochyQvomhiUDC1TJKuyww8HodQoOzUswoaidOxcUS8CJ34KTw6vSlwxs57jJwi1rgwFSQGDv2OLrO/c+sgk84XDB3YP5h1ZzGmuh72aSmChapl7RxXpB/3Xogp56xd4WiquRoIXfGcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775868; c=relaxed/simple;
	bh=NmQHDuLchgQlO00wh/iECx/eLc5OI0q38FMO6x6tIg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoJDx0gY+G2lOJgGB4AgZSkRnwozx/zZTGeccRMDnSxG8OEJ9kp0bwpamu63rKqDklfec7fevdmvMAILQoH7ovJkTH9oWfCoP8bTWpF5AYC+2bKI6uoliS3nqrHGCh+GbKC46atMfSG0js1vKafA5ygbrf7RlHKMHzsYQPg6i80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8obn1ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8obn1ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1732C4CEF5;
	Wed,  3 Dec 2025 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775868;
	bh=NmQHDuLchgQlO00wh/iECx/eLc5OI0q38FMO6x6tIg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8obn1ceqiQgVJcIOfiyiZuNn/bgnX0z/2PKWAqIRF+CznoEukTa0J9Zlq/5skMuV
	 eIa0HybWfC1EzAKN4R3Y1DZzVm+00K/y3Nmwa1Kbxg1kLTz7GGC+AZV8Kji707OKwB
	 vg/xZOE91mIERwGg4rN4HYAE6C2QpjrX62VseZtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 012/300] fbdev: valkyriefb: Fix reference count leak in valkyriefb_init
Date: Wed,  3 Dec 2025 16:23:36 +0100
Message-ID: <20251203152400.913498729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
 


