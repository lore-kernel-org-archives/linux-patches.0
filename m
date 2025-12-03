Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C76306D3D;
	Wed,  3 Dec 2025 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776189; cv=none; b=I7gK2TVgPIJqKdnK1U6ecwdVq3kLeS97aNoB/tkorUjeMpy8iz6ipFjZ2RKZ1Cc2X0sCclEE8bmxhHjgyOQ/ePT7nGoTUpmZ+qf2TDontP4ijh5aDCp/w6yHV5aykKmVUS1Wy+6e0NSSZGeX8VyOeCOx33+mjUbBi3M+2E5Z6DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776189; c=relaxed/simple;
	bh=fj/8QwchYFoQCdJR6pN1RSH41Kq+XUNrYbyoBb2pzHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7Xxr3yrAW6b5QjgpZOrb/ocpFWXZWNuggfPQncHClsOqzw/ArSKC6W7ItUfXLHIYldueU8nCBJ9Z0tsEU/j0BsgFvDmP5KBB7l0j6qBHFGwy0y1B/K4xU8PXAcDE3Zy/DF3orD3WGujPUkNB7GDBim780WiSy38X+g0CmH3rJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkYpy7mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkYpy7mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C12FC4CEF5;
	Wed,  3 Dec 2025 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776189;
	bh=fj/8QwchYFoQCdJR6pN1RSH41Kq+XUNrYbyoBb2pzHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkYpy7mjhtlUMFf6uORTwpbJ9eJCabWRr38iPJ+bCWRKyaXNexyAKyBJzPbKz1PiU
	 YM2/WU80NxfK5NL/ZK6Cxw5WRao+C57EgtiEVyuyqxFLD6NUkczc/7BpxbbYpWKz9v
	 9ph8a8rWUy1Un87srHEDjfxlbr/+3U8WNYNlyodo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/300] usb: gadget: f_hid: Fix zero length packet transfer
Date: Wed,  3 Dec 2025 16:25:12 +0100
Message-ID: <20251203152404.624173532@linuxfoundation.org>
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

From: William Wu <william.wu@rock-chips.com>

[ Upstream commit ed6f727c575b1eb8136e744acfd5e7306c9548f6 ]

Set the hid req->zero flag of ep0/in_ep to true by default,
then the UDC drivers can transfer a zero length packet at
the end if the hid transfer with size divisible to EPs max
packet size according to the USB 2.0 spec.

Signed-off-by: William Wu <william.wu@rock-chips.com>
Link: https://lore.kernel.org/r/1756204087-26111-1-git-send-email-william.wu@rock-chips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 2f30699f0426f..c285b23c3707c 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -490,7 +490,7 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	}
 
 	req->status   = 0;
-	req->zero     = 0;
+	req->zero     = 1;
 	req->length   = count;
 	req->complete = f_hidg_req_complete;
 	req->context  = hidg;
@@ -761,7 +761,7 @@ static int hidg_setup(struct usb_function *f,
 	return -EOPNOTSUPP;
 
 respond:
-	req->zero = 0;
+	req->zero = 1;
 	req->length = length;
 	status = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 	if (status < 0)
-- 
2.51.0



