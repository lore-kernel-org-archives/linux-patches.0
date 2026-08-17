Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEBC39A807;
	Mon, 17 Aug 2026 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980201; cv=none; b=sX8nMceogVUx1C7IgItpEAgbYyulZ7oV0mpcY5iWB7rLdGo5yiK9zWniA6XilmuwiGW0+J5GZwFRp/3BKo3bxJbc8Lo6HZRfWQvJHwxfyc6UASJzyGG76wbW/BXvdP43GnOgJQhgynXx/ubU8AUatCngH472wJySjQGP6hYpXKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980201; c=relaxed/simple;
	bh=9GPYsXhSx8d0dKXpxSoKGbcWcACDa8fI3I/rEMXHOB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzGgUey5iNK1E8CWmBHBihbXwMInyyp4pMAndVm3czOM6E/G0mq+zGboqkLYxn4MGeZ08OctSkO9XXZ9UCvBKxkcg31T/EbPkIb52SxzokRiiEtZhoPqk/AIJz8Wrzhuq0sY9Fapc6/VgGKN4Rdk3m2HauPgTuEP2BfUi3ZcfGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9MAXYJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9MAXYJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546921F000E9;
	Mon, 17 Aug 2026 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980199;
	bh=cp35874Ap9j4RgXNwJxfhYWLvM70yq0ydCPiYNcx+Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9MAXYJlSp97otRws8c322kf3eHJoFP5mPuKgKHF+DdA6HPEe2nA7aCEVPNr6qpbV
	 Mumf/ohbTCdqHqBPTV9GEh/q3hTsS3J2/A6vxEo5u98/rQazj9G2f4mC3+2TnNb3Mb
	 sAXaUR/VdwNhSOwRQQ3+AxQS2Tx3nAVCY3ghCoMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 451/609] can: etas_es58x: es58x_read_bulk_callback(): fix RX buffer leak on URB resubmit failure
Date: Mon, 17 Aug 2026 15:32:27 +0200
Message-ID: <20260817132559.143217760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 7a0cf2b2497c757c3cb1286eddf2986abb0d387b upstream.

es58x_read_bulk_callback() resubmits the RX URB after processing a received
packet. If the resubmit succeeds, the URB remains anchored and will be
handled by the normal RX path or by teardown.

However, if usb_submit_urb() fails, the callback unanchors the URB and then
returns directly. This skips the existing free_urb path, so the coherent
transfer buffer allocated with usb_alloc_coherent() is not released.

Reuse the existing free_urb path after a resubmit failure so that the RX
coherent buffer is freed before leaving the callback.

Fixes: 5eaad4f76826 ("can: usb: etas_es58x: correctly anchor the urb in the read bulk callback")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20260706014601.415445-1-lgs201920130244@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1475,7 +1475,6 @@ static void es58x_read_bulk_callback(str
 		dev_err_ratelimited(dev,
 				    "Failed resubmitting read bulk urb: %pe\n",
 				    ERR_PTR(ret));
-	return;
 
  free_urb:
 	usb_free_coherent(urb->dev, urb->transfer_buffer_length,


