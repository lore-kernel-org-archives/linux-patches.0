Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED11E882C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5633EC433D2;
	Fri, 10 Mar 2023 15:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461412;
	bh=ng/AWsp3f23QHE9jW9WRe+LRsRvjsziup0qvPOmGWlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVXU+vvR6MZTr2bBX/zTadEIC3XREZH+knZ1sy1H7Qrzd0FNwf2MzrZWBFRPlYKk6
	 p/dBGCkw01aXgJa+TwySJ3L0rqGEzBS2EIbMMO5nn6jhgaB+54eySusm90SlvAFwgT
	 9YlLTpfvZtm4SpStLUYRocWHo53WmiUhH2ajyYfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/136] USB: uhci: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:43:40 +0100
Message-Id: <20230310133710.121753965@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 0a3f82c79c86278e7f144564b1cb6cc5c3657144 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230202153235.2412790-3-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/uhci-hcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index d90b869f5f409..d138f62ce84d7 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -536,8 +536,8 @@ static void release_uhci(struct uhci_hcd *uhci)
 	uhci->is_initialized = 0;
 	spin_unlock_irq(&uhci->lock);
 
-	debugfs_remove(debugfs_lookup(uhci_to_hcd(uhci)->self.bus_name,
-				      uhci_debugfs_root));
+	debugfs_lookup_and_remove(uhci_to_hcd(uhci)->self.bus_name,
+				  uhci_debugfs_root);
 
 	for (i = 0; i < UHCI_NUM_SKELQH; i++)
 		uhci_free_qh(uhci, uhci->skelqh[i]);
@@ -700,7 +700,7 @@ static int uhci_start(struct usb_hcd *hcd)
 			uhci->frame, uhci->frame_dma_handle);
 
 err_alloc_frame:
-	debugfs_remove(debugfs_lookup(hcd->self.bus_name, uhci_debugfs_root));
+	debugfs_lookup_and_remove(hcd->self.bus_name, uhci_debugfs_root);
 
 	return retval;
 }
-- 
2.39.2



