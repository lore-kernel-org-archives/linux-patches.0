Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB52930BB91;
	Mon, 13 Apr 2026 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097463; cv=none; b=M4KTPf/o1Xawcqc59iwku7V0moyWeNPDUBRbJOdjK9PLLj2Pr9dEnhErxKr73HqV2Xr7LWFU8Z3Yq89gJcEy0BFztdSZtllEI+/MkZPMxwdc2VJE0ZPqrpx00qdIsklbo5qqg/MAR8BgsXvTBLBA4GU54Yrbb3OtzKIkg3I6M6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097463; c=relaxed/simple;
	bh=NCOJik7O6pjaQNUmc2q9yds9fQMaeLbEj4SuaSKZZp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGuYilMSlrMSLCF8UBdlI9XEUq78Q5zUAD6eza5OQUphqCjXEaaXuXA2eYC9EJfXVTTYS4RY/zL6NDLH9/JjHkYR1p4akX6XJgb0Q2eakwNcPm1cqfd2pRhwYOHal/Nt91TznG7VONEO2P1Dczwmd8LwFLIYUZdFDBM82AkOEuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0S0lcaOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0S0lcaOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41872C2BCB0;
	Mon, 13 Apr 2026 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097463;
	bh=NCOJik7O6pjaQNUmc2q9yds9fQMaeLbEj4SuaSKZZp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0S0lcaOQPibOSE/Fc9aDpiap+G0y0JB6wtDsMpbSYMFT2uyFJsUatb8RkllD0rfoa
	 Cldgj32z6v8+gZcNy4Z/WjBlPvOOBKum17zoW/1aPjFwHTcITxJ3HjP/SKYXAWEsmV
	 bW28gk5w/hMJRtJ+0nSYoPRaHqSUPa5v894JFR8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 146/570] usb: image: mdc800: kill download URB on timeout
Date: Mon, 13 Apr 2026 17:54:37 +0200
Message-ID: <20260413155835.920459256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

commit 1be3b77de4eb89af8ae2fd6610546be778e25589 upstream.

mdc800_device_read() submits download_urb and waits for completion.
If the timeout fires and the device has not responded, the function
returns without killing the URB, leaving it active.

A subsequent read() resubmits the same URB while it is still
in-flight, triggering the WARN in usb_submit_urb():

  "URB submitted while active"

Check the return value of wait_event_timeout() and kill the URB if
it indicates timeout, ensuring the URB is complete before its status
is inspected or the URB is resubmitted.

Similar to
- commit 372c93131998 ("USB: yurex: fix control-URB timeout handling")
- commit b98d5000c505 ("media: rc: iguanair: handle timeouts")

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260209151937.2247202-1-n7l8m4@u.northwestern.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/image/mdc800.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -731,9 +731,11 @@ static ssize_t mdc800_device_read (struc
 					mutex_unlock(&mdc800->io_lock);
 					return len-left;
 				}
-				wait_event_timeout(mdc800->download_wait,
+				retval = wait_event_timeout(mdc800->download_wait,
 				     mdc800->downloaded,
 				     msecs_to_jiffies(TO_DOWNLOAD_GET_READY));
+				if (!retval)
+					usb_kill_urb(mdc800->download_urb);
 				mdc800->downloaded = 0;
 				if (mdc800->download_urb->status != 0)
 				{


