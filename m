Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9097E39A25A;
	Wed,  3 Dec 2025 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780787; cv=none; b=ZKoi4DvcKO/iSm60T/jH5P+I7iuykDSDRssM6DD9cpywA5NIWHdD0m+AbV9r+BSBro9esGFpan9N/MKuSE4ublfgnxvbNBA1DYz+AJEjPpa3k44bJz2qSwIc6Wz/U/1wTna5DLGnB5oyXCu2oaJH0XO0CvHyo5AFTMp21QSPevA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780787; c=relaxed/simple;
	bh=iyKdZZt6CzZjWdhnI+lODwmbioOKLY44J51PmYMu1z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+ZhBZGPhC0UOhyHDMrmDwy+V/3vLrBWhtCXXzt+0Cc9oyJZvAPJsEZcL/rb1tgVXCSvZzsscBM+i3qqN4NcwLaSkrqLnmiVp4RJv+qbOhW2Cr0zJAVtEXBLHebjRNaz/t9YITJ1wb1787ZXbVYe3YgmKUHHAGvj44uw8H4GEII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHLyMZRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHLyMZRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925B6C4CEF5;
	Wed,  3 Dec 2025 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780786;
	bh=iyKdZZt6CzZjWdhnI+lODwmbioOKLY44J51PmYMu1z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHLyMZRqYeYgjRRsXR1iVo9NuCUyCjOYWwbdqNZgeaSHDw+UP/k9AX2CYh+/Vf6MM
	 dki+QCXsNie2M/b5PDX6T+UAvR9F8rTXNIqcRE3v3Jwwd8koH0UyWWyn1v2Up3/k22
	 PBdeIMNpya28HGbMEn6aogLHzOG5gh03+R+KjWas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.12 089/132] usb: gadget: f_eem: Fix memory leak in eem_unwrap
Date: Wed,  3 Dec 2025 16:29:28 +0100
Message-ID: <20251203152346.588375552@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

commit e4f5ce990818d37930cd9fb0be29eee0553c59d9 upstream.

The existing code did not handle the failure case of usb_ep_queue in the
command path, potentially leading to memory leaks.

Improve error handling to free all allocated resources on usb_ep_queue
failure. This patch continues to use goto logic for error handling, as the
existing error handling is complex and not easily adaptable to auto-cleanup
helpers.

kmemleak results:
  unreferenced object 0xffffff895a512300 (size 240):
    backtrace:
      slab_post_alloc_hook+0xbc/0x3a4
      kmem_cache_alloc+0x1b4/0x358
      skb_clone+0x90/0xd8
      eem_unwrap+0x1cc/0x36c
  unreferenced object 0xffffff8a157f4000 (size 256):
    backtrace:
      slab_post_alloc_hook+0xbc/0x3a4
      __kmem_cache_alloc_node+0x1b4/0x2dc
      kmalloc_trace+0x48/0x140
      dwc3_gadget_ep_alloc_request+0x58/0x11c
      usb_ep_alloc_request+0x40/0xe4
      eem_unwrap+0x204/0x36c
  unreferenced object 0xffffff8aadbaac00 (size 128):
    backtrace:
      slab_post_alloc_hook+0xbc/0x3a4
      __kmem_cache_alloc_node+0x1b4/0x2dc
      __kmalloc+0x64/0x1a8
      eem_unwrap+0x218/0x36c
  unreferenced object 0xffffff89ccef3500 (size 64):
    backtrace:
      slab_post_alloc_hook+0xbc/0x3a4
      __kmem_cache_alloc_node+0x1b4/0x2dc
      kmalloc_trace+0x48/0x140
      eem_unwrap+0x238/0x36c

Fixes: 4249d6fbc10f ("usb: gadget: eem: fix echo command packet response issue")
Cc: stable@kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20251103121814.1559719-1-khtsai@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_eem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -477,8 +477,13 @@ static int eem_unwrap(struct gether *por
 				req->complete = eem_cmd_complete;
 				req->zero = 1;
 				req->context = ctx;
-				if (usb_ep_queue(port->in_ep, req, GFP_ATOMIC))
+				if (usb_ep_queue(port->in_ep, req, GFP_ATOMIC)) {
 					DBG(cdev, "echo response queue fail\n");
+					kfree(ctx);
+					kfree(req->buf);
+					usb_ep_free_request(ep, req);
+					dev_kfree_skb_any(skb2);
+				}
 				break;
 
 			case 1:  /* echo response */


