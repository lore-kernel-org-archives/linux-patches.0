Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B19B13C918;
	Thu, 12 Dec 2024 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025571; cv=none; b=BF7je/sQ8OyAFwRfIo2UlZMtMvLoIzcRKiovdj84nofajxOyTNrlgfbaIPIs3NyOOaGxXXZOHXgDvWJN9ev952hPmfjrgQYw0NAk/oo+P0ZL/B4CacX8fp/6DY5IsZKTBxN6bxhdkMLL9+vrAb0Zn2U0/7jQ6FhMAG9IIEdjtUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025571; c=relaxed/simple;
	bh=OoHRxY6CLgkSwCErZ0bGuyxSDfwrTM+azY6HJ/vaiQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ffgg5d9sVPcFmjSNwi4MSYpN2o4r/Ylx1Qc0G6gW7Z1kj42FS+vRiM1OdRFh5KIAmOQCdESWAhbhyIMONs6C/IbGaL19sK8TgknfJCvTG2dBytw07+4opVYBA3Zts6AJR9ZUUkafS9THxTCQz+xT96RMwhH7+VnxfflKgjTgcNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RicFZRhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RicFZRhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99177C4CECE;
	Thu, 12 Dec 2024 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025571;
	bh=OoHRxY6CLgkSwCErZ0bGuyxSDfwrTM+azY6HJ/vaiQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RicFZRhkCLvkHsX4ie2n8zWWXlM5w31kaz+GeXeinwNoK9VKXle40UpxYdD4Dpca6
	 AtA+gR1f+kFFUj541lFkP5O5kzZsClyqZjnOr9rGQqvcNaWtsBWSR6/yLTLwhcB+6I
	 FYZomkqOjNB1XFfnmDtAE7xKzKU3xIDNyqwdMLM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 173/321] usb: dwc3: gadget: Fix checking for number of TRBs left
Date: Thu, 12 Dec 2024 16:01:31 +0100
Message-ID: <20241212144236.817801334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 02a6982b0ccfcdc39e20016f5fc9a1b7826a6ee7 upstream.

The check whether the TRB ring is full or empty in dwc3_calc_trbs_left()
is insufficient. It assumes there are active TRBs if there's any request
in the started_list. However, that's not the case for requests with a
large SG list.

That is, if we have a single usb request that requires more TRBs than
the total TRBs in the TRB ring, the queued TRBs will be available when
all the TRBs in the ring are completed. But the request is only
partially completed and remains in the started_list. With the current
logic, the TRB ring is empty, but dwc3_calc_trbs_left() returns 0.

Fix this by additionally checking for the request->num_trbs for active
TRB count.

Cc: stable@vger.kernel.org
Fixes: 51f1954ad853 ("usb: dwc3: gadget: Fix dwc3_calc_trbs_left()")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/708dc62b56b77da1f704cc2ae9b6ddb1f2dbef1f.1731545781.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -903,11 +903,14 @@ static u32 dwc3_calc_trbs_left(struct dw
 	 * pending to be processed by the driver.
 	 */
 	if (dep->trb_enqueue == dep->trb_dequeue) {
+		struct dwc3_request *req;
+
 		/*
-		 * If there is any request remained in the started_list at
-		 * this point, that means there is no TRB available.
+		 * If there is any request remained in the started_list with
+		 * active TRBs at this point, then there is no TRB available.
 		 */
-		if (!list_empty(&dep->started_list))
+		req = next_request(&dep->started_list);
+		if (req && req->num_trbs)
 			return 0;
 
 		return DWC3_TRB_NUM - 1;


