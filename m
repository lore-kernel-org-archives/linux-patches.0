Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB8B3EDADD;
	Tue, 17 Mar 2026 16:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766101; cv=none; b=ia2y7Rk47nrj0MH7g9PKRExonJr60zufyRL09inMbxJo1HQwLd9W8lxbxH163GqyspHMY8GVgE4ejX7AVNLw22fzBVfIXubFdaYdojZshtqrmP1lWD905Kt0d0/yJOrW2i38YO/4EREAEyEppU1Cx6N6tXxuemrFIgiAs7dI9H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766101; c=relaxed/simple;
	bh=rLVBCMNeAWg9zxr9Un9x68mSoKsDLpT/GXM678u5yeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+Hw+ygEIvMrXFBpOCpdfT9ExbxANqxZQL38j+TENv5bFlEFJ4TmKcK9TfyKsXudscGHyqabYI+9OxD4spw6U2xTwMzY/9trd8//TT+8lIw/PHM9brX6wUCVLaeN4drxPvYk33NJJKDrqZh0cmEXvdcRF7z2vT9+c/pVHYBtGJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWC+uBz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWC+uBz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988E3C4CEF7;
	Tue, 17 Mar 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766101;
	bh=rLVBCMNeAWg9zxr9Un9x68mSoKsDLpT/GXM678u5yeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWC+uBz2EhOGIxkIznNqlVLBPjiYs+B+OcbyaUa06UYQg9Vx3zmo+EeFt89ves66k
	 EoNoQyG3Pl0Hpvj7VndS2IC9Bw/rVlvDi6GF62I1V4Y+i9r793JpAFnryK2C9TEEMR
	 hcEWmPJ2iICB1CGy4wZUwuGOWD+KKloyVcqR25uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 163/378] usb: image: mdc800: kill download URB on timeout
Date: Tue, 17 Mar 2026 17:32:00 +0100
Message-ID: <20260317163013.008564984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -730,9 +730,11 @@ static ssize_t mdc800_device_read (struc
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


