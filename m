Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A096D1D7;
	Tue, 14 May 2024 10:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683663; cv=none; b=Lx1PGK9wxukVyHqIUwwug1L4tQnoQSjakCSqze9I0Y9d7QrVJlZzH/r5720mxPTPRj4IyaSOa4bt8suvFY6Y+5ENj+A+gJ4EZY65SWq23WLsqLB37bkTpNpYiQuiexw1MydtzO70jKiQK1nxr29hdPEzkJHkUECwMfTtoH10Hcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683663; c=relaxed/simple;
	bh=TP0oI6VrWfeLIAoqAkaCp5YOacA79hMyQbi+4GGtHmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzOQe1CavwOpKU2/AqH5a3phYJtzFCbccxnxaW0lzAjbUX+lrWhne+U6s3aj3Bu+wP/Z/vChxQMht+ruuwZPwRZgIbF7oeYa1htnr8B0A7zNUKZabEDimRemzo3PTRouDNafgLtNfp5ZoogIB2I4QsLQPBz3+baZtIL/O6mrbYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqRq0qac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqRq0qac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF9AC2BD10;
	Tue, 14 May 2024 10:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683663;
	bh=TP0oI6VrWfeLIAoqAkaCp5YOacA79hMyQbi+4GGtHmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqRq0qaczwjBHCGZ42DxssbU2B3Rt7oeu5Pt0KIe5z+9FDRhWqaVp5yk95mK1U2SX
	 5TEkYEeRSsAe0j8UKpn/aUv3avW18gY68MipKx3kSRYs+YbqRXPjHWkv9D+EOJO9ft
	 Gi3YaAGJ2YrO5817u7+Jb3gPC4rsqP1txuB/Fi5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Chris Wulff <chris.wulff@biamp.com>
Subject: [PATCH 6.8 253/336] usb: gadget: f_fs: Fix a race condition when processing setup packets.
Date: Tue, 14 May 2024 12:17:37 +0200
Message-ID: <20240514101048.169484560@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wulff <Chris.Wulff@biamp.com>

commit 0aea736ddb877b93f6d2dd8cf439840d6b4970a9 upstream.

If the USB driver passes a pointer into the TRB buffer for creq, this
buffer can be overwritten with the status response as soon as the event
is queued. This can make the final check return USB_GADGET_DELAYED_STATUS
when it shouldn't. Instead use the stored wLength.

Fixes: 4d644abf2569 ("usb: gadget: f_fs: Only return delayed status when len is 0")
Cc: stable <stable@kernel.org>
Signed-off-by: Chris Wulff <chris.wulff@biamp.com>
Link: https://lore.kernel.org/r/CO1PR17MB5419BD664264A558B2395E28E1112@CO1PR17MB5419.namprd17.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3335,7 +3335,7 @@ static int ffs_func_setup(struct usb_fun
 	__ffs_event_add(ffs, FUNCTIONFS_SETUP);
 	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
 
-	return creq->wLength == 0 ? USB_GADGET_DELAYED_STATUS : 0;
+	return ffs->ev.setup.wLength == 0 ? USB_GADGET_DELAYED_STATUS : 0;
 }
 
 static bool ffs_func_req_match(struct usb_function *f,


