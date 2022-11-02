Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B965E7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC34CC433D6;
	Wed,  2 Nov 2022 03:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358835;
	bh=KqKkcehuAyvVrhgWWxSqZ77BPf+d4EtEhWd7f9hxvrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeMsYOBzVToPU2dPNlk8fl4+TQmq3KIsPYFj7qOzWF8rEw4yO5rbp2/sbOqOmQep0
	 hoy0vcT5NVV8VLiYjmAtyMt44Ti2E3LSpqdBO7IN5zpjtuxNja+gO54WXpOq4fO/d/
	 H6nwP6PgnjVLw91Cbl2sRfEtegVG+PXTAmahHL3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Demi Marie Obenour <demi@invisiblethingslab.com>
Subject: [PATCH 5.10 32/91] Xen/gntdev: dont ignore kernel unmapping error
Date: Wed,  2 Nov 2022 03:33:15 +0100
Message-Id: <20221102022055.953484410@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Beulich <jbeulich@suse.com>

commit f28347cc66395e96712f5c2db0a302ee75bafce6 upstream.

While working on XSA-361 and its follow-ups, I failed to spot another
place where the kernel mapping part of an operation was not treated the
same as the user space part. Detect and propagate errors and add a 2nd
pr_debug().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/c2513395-74dc-aea3-9192-fd265aa44e35@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Co-authored-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -395,6 +395,14 @@ static void __unmap_grant_pages_done(int
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = -1;
+		if (use_ptemod) {
+			WARN_ON(map->kunmap_ops[offset+i].status &&
+				map->kunmap_ops[offset+i].handle != -1);
+			pr_debug("kunmap handle=%u st=%d\n",
+				 map->kunmap_ops[offset+i].handle,
+				 map->kunmap_ops[offset+i].status);
+			map->kunmap_ops[offset+i].handle = -1;
+		}
 	}
 	/*
 	 * Decrease the live-grant counter.  This must happen after the loop to


