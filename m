Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D7B17CA12;
	Mon, 10 Mar 2025 17:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626929; cv=none; b=juczki2Ex13pqR+jw9eQoHKR7Lha1VUNglimd6WGLG3e95V1Az9aOXflcFs3ezHIXcRRv0U3ocJxblnclkMVN1N4MVVSYixnON+PVWBJ88cL3D0bildnKgxEBjuPGv5e129YrgeVzg3yEEGPbvatNno9F+p+SWkOolaX4DXjges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626929; c=relaxed/simple;
	bh=QuWhwp6WbjTYvrqq7fBK0ZiigiqubdcPCelo+JqHpJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6MlEeZ4JMTt31SFFeasI/CeFr+ogtNMQ4WNSYLrps77M6+jgUj5zYoA9HlhMOvDWjEFj3rumFAf57JnLKhN3xVotQ7tZpTNUUX2yhzFazcRRUbmNT+6OOrfjWdQ693eVqo2fj1XtsjUlNeLJpWU9Lw4R72hTOrbdtyBgPbqznM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKaGdL7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKaGdL7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2236C4CEE5;
	Mon, 10 Mar 2025 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626929;
	bh=QuWhwp6WbjTYvrqq7fBK0ZiigiqubdcPCelo+JqHpJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKaGdL7LD1IGftI43XK5OxfWSFPk0qZ8rP1/8I0cCWHy4N1z1swDxZLstM594sr5Y
	 ijKE/aq3iSn/LOYxOJxN/nGGl3OZ5AH28b4BDCsGOtSVAZsky49YCMkSlg6nZ+nH3u
	 b7VztakRv7BAKMBZf7PtX+59eOieCqxMnMl9kbp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.13 161/207] usb: gadget: u_ether: Set is_suspend flag if remote wakeup fails
Date: Mon, 10 Mar 2025 18:05:54 +0100
Message-ID: <20250310170454.191227217@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 17c2c87c37862c3e95b55f660681cc6e8d66660e upstream.

Currently while UDC suspends, u_ether attempts to remote wakeup
the host if there are any pending transfers. However, if remote
wakeup fails, the UDC remains suspended but the is_suspend flag
is not set. And since is_suspend flag isn't set, the subsequent
eth_start_xmit() would queue USB requests to suspended UDC.

To fix this, bail out from gether_suspend() only if remote wakeup
operation is successful.

Cc: stable <stable@kernel.org>
Fixes: 0a1af6dfa077 ("usb: gadget: f_ecm: Add suspend/resume and remote wakeup support")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250212100840.3812153-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -1052,8 +1052,8 @@ void gether_suspend(struct gether *link)
 		 * There is a transfer in progress. So we trigger a remote
 		 * wakeup to inform the host.
 		 */
-		ether_wakeup_host(dev->port_usb);
-		return;
+		if (!ether_wakeup_host(dev->port_usb))
+			return;
 	}
 	spin_lock_irqsave(&dev->lock, flags);
 	link->is_suspend = true;


