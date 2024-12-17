Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95321F7577;
	Tue, 17 Dec 2024 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455949; cv=none; b=qwoSV4E9ASPlLGbZfjDuZdcRdFsyWYd+hj38F8AWd8ARsYLuSqqQY1QdKV73AD6CxVzqwulDsRK/RxG5wvwB2iRB6/D96IDVaH34BZIZFUKclODE+lGPT8UYLTBfgoSTj1vz28VkvV43hd9rF5kBznVH3wzub5FIx6xcQPvloQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455949; c=relaxed/simple;
	bh=SZ35sFwWeAx5QqGV6l47DNMlB0Rv9yUkg2I1Kw+skeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPRwksI/DC+3pB2dMHPGH/VGeKKitigGGecKT+ytkOcGo7m6llhA1wFa8S1cbjXo5EUsi3j/50nGDoA2lirk+NCWKppcZtQgFAXS1lombqWJCQ0KSR8rDZp2Rnp/SXB1AndUNleRJMWJ1Kv2CnZMA7KkosDaa3kkBjFHwclnK0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOwnL3nT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOwnL3nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECBAC4CED3;
	Tue, 17 Dec 2024 17:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455949;
	bh=SZ35sFwWeAx5QqGV6l47DNMlB0Rv9yUkg2I1Kw+skeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOwnL3nTxTZ9tPaPNIqMBSk4FjZ5GxQN42kNL4bkrJZMgs7lMNRCL3EHe6D4wyMdP
	 lox/DFkNybd7zySnGMxoybTkogL016RARRsNt0bKa7vDaXFF22sz+aH0Vd/vR/MTRl
	 5ErRjsqJc4ekAPe/Z4InOiyrTSyOD+6ARx9kXfzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH 6.6 010/109] usb: host: max3421-hcd: Correctly abort a USB request.
Date: Tue, 17 Dec 2024 18:06:54 +0100
Message-ID: <20241217170533.782226769@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

commit 0d2ada05227881f3d0722ca2364e3f7a860a301f upstream.

If the current USB request was aborted, the spi thread would not respond
to any further requests. This is because the "curr_urb" pointer would
not become NULL, so no further requests would be taken off the queue.
The solution here is to set the "urb_done" flag, as this will cause the
correct handling of the URB. Also clear interrupts that should only be
expected if an URB is in progress.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Cc: stable <stable@kernel.org>
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20241124221430.1106080-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/max3421-hcd.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -779,11 +779,17 @@ max3421_check_unlink(struct usb_hcd *hcd
 				retval = 1;
 				dev_dbg(&spi->dev, "%s: URB %p unlinked=%d",
 					__func__, urb, urb->unlinked);
-				usb_hcd_unlink_urb_from_ep(hcd, urb);
-				spin_unlock_irqrestore(&max3421_hcd->lock,
-						       flags);
-				usb_hcd_giveback_urb(hcd, urb, 0);
-				spin_lock_irqsave(&max3421_hcd->lock, flags);
+				if (urb == max3421_hcd->curr_urb) {
+					max3421_hcd->urb_done = 1;
+					max3421_hcd->hien &= ~(BIT(MAX3421_HI_HXFRDN_BIT) |
+							       BIT(MAX3421_HI_RCVDAV_BIT));
+				} else {
+					usb_hcd_unlink_urb_from_ep(hcd, urb);
+					spin_unlock_irqrestore(&max3421_hcd->lock,
+							       flags);
+					usb_hcd_giveback_urb(hcd, urb, 0);
+					spin_lock_irqsave(&max3421_hcd->lock, flags);
+				}
 			}
 		}
 	}


