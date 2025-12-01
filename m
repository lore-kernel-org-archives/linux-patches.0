Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4DA3081A9;
	Mon,  1 Dec 2025 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588447; cv=none; b=dxRmYPwdAljIkFjUwjXoAWU43EI9vP9SySXgCcnWrjd4fgrWnEWMHuehv2ofTBKeBLgUs2Ga4pbuDGejnihY1WJHe9vALEY9U7b80I4z+nzb47O4pxw+cvIH8Ew97A/TSk5F1q9OnWs5Rdht1btwVkbW+Il2ZnoLHf4o7tmiER4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588447; c=relaxed/simple;
	bh=3uFacaDTTm07XItoWGyua4fTHWDDqcUwuCn9wkySjPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3CnzOZ3J4eu3RySbOJu8Xu9aRqk8cSLawUFs9GQaUII6gAErEPlU62arxnH3dz/jTncOHo+RIoTuiK1KFqx3vDqVXk+fmnWT9n70/hHQ6SaqnVMIuVx6y1ypmtBTB3tuA7UGRYUfhbRxrkwEBqE0qD0J/Mt1PUC5TJ65eDLWok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOzkzE+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOzkzE+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB226C4CEF1;
	Mon,  1 Dec 2025 11:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588447;
	bh=3uFacaDTTm07XItoWGyua4fTHWDDqcUwuCn9wkySjPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOzkzE+9lq31Ifq4oF/9naTscpshSAhUx8iPmsvFJYXXo0jfkzw0GabzUEENK7gMx
	 BwX1HV6NmP2CP1x1niGvPthomSCdkEoOP11aCUp/79tAfhyeA6+TkpzQNKJa8CWQzJ
	 swQ2xvJ1G9f1RRT/nKHoQYNKqkk3DS5XBIwgTCls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 009/187] fbdev: valkyriefb: Fix reference count leak in valkyriefb_init
Date: Mon,  1 Dec 2025 12:21:57 +0100
Message-ID: <20251201112241.586804201@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


