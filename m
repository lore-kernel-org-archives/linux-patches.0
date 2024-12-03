Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1121F892F;
	Tue,  3 Dec 2024 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242724; cv=none; b=a0ZHikBYG/rGxBeQmGNISOa13wSLRjuoqCoiITzBLG63Ro/AfPBRjCitECfHHe/t0Uzq113I08soQwJ1piHFtVrIHHJHGnNqTmextICij8y4QXhsPJGwp232YQfSmyIoVkNC7QoMow5Ucgna+kJt+PPdRKKCC1lOXO//XHmdxaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242724; c=relaxed/simple;
	bh=x79uz0oi1yFxj63+klQITSkWPAu+IocBFggur2gzXD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnmKv4acirGEEBEIPbUlMjuSOQRLGlL6n0/G2uUUCw2i552L3+eXb088QWCCMOWfu1CcFOR0v1tlWB4x3R/ogV4NlcdwqG7PN0C3Jt7IpSa2B8pxVoLQvBh384ryYrvcYiZqPpGIPAlPgJHYted7UdIKhdIyV69xo9znG6nf8EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lNnJA2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lNnJA2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7A8C4CECF;
	Tue,  3 Dec 2024 16:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242724;
	bh=x79uz0oi1yFxj63+klQITSkWPAu+IocBFggur2gzXD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lNnJA2I1q/53CV3L8MvB+fQQyNXqUr1v3u1fTpgUJetcI1tVPr2utbAIZJHhlHCn
	 Ti39L/GkUlU7dshuVn9PB1dDE0Emjg0KvcaaoYIbOpwJvZOq3w1QqZpwa2TnoPqhCt
	 nQTq0ffUBE9x7RSIAk0uxm62li/Z5TcNvd7NPdZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 758/826] usb: dwc3: ep0: Dont clear ep0 DWC3_EP_TRANSFER_STARTED
Date: Tue,  3 Dec 2024 15:48:05 +0100
Message-ID: <20241203144813.333996144@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 5d2fb074dea289c41f5aaf2c3f68286bee370634 upstream.

The driver cannot issue the End Transfer command to the SETUP transfer.
Don't clear DWC3_EP_TRANSFER_STARTED flag to make sure that the driver
won't send Start Transfer command again, which can cause no-resource
error. For example this can occur if the host issues a reset to the
device.

Cc: stable@vger.kernel.org
Fixes: 76cb323f80ac ("usb: dwc3: ep0: clear all EP0 flags")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/d3d618185fd614bb7426352a9fc1199641d3b5f5.1731545781.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -232,7 +232,7 @@ void dwc3_ep0_stall_and_restart(struct d
 	/* stall is always issued on EP0 */
 	dep = dwc->eps[0];
 	__dwc3_gadget_ep_set_halt(dep, 1, false);
-	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED;
+	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED | DWC3_EP_TRANSFER_STARTED;
 	dep->flags |= DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 


