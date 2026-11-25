Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626311;
	b=komRTvxO1C4DfKcjdFWyD97jv/IGBeMY4aAbCWJ2AqVdH3GVOWbXkdDJ0OS222vkQpgM
	 RDyWTWMESD/ACl7Hofcu2NqIDMchCjnH7DvX1Z0YVPeApdWJI6CjVOo96gquvPfjS345U
	 VEphfBzLCj3Cfcm+jfyooAqXxuxyNiSuKXQW4jDDZxH+IWNHVqbTfvfeiqxuU33InLqoq
	 +mmLUd+Gea/5gAmQHdGTrir9FFfOalxdqr0kKA6wWMFyuHsJyU0hgOTJMggUqgnGsvsb8
	 RigebzoClwuHBkVIjEA43PgMFhsIglRpWbM82qab/uY0ZNpcVB4DNNhBAltWeJj7Xiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A+MOAA3FMQxcoa0XKVahedXkcurNgmXa9pmlgcQXiSo=;
	b=D6oRtqp8aBuJmZXcXWQ5F342zeN+7Z1JnmlyfXbOsKapR7MoUUepY1WdPLx8Sqaf+LWs
	 wN84NS3FJJbqNC9ruaPkSVay3fCsoZc/eQTEao6mhE9gec+t52zXT88VOBjqI90ebc7rS
	 o2nLhO+uWAtNqmbi+6EUQ/qg/aDpcUJq212q4pF1P1DQPH82mwKZVZPKMRjFrjV6btwnL
	 2cEE5ddPshYApxHNxTaJ9c3niRqukgNZAF3fRUgtKrHVo5aPz5eWgnACx5kO5iqOw6vbX
	 tOmvo0QgZSddZBM0ciroodwQusRoOgXvLGMcs9546Ku3TWfJsOuuCbfOQShsDnZRd9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpEubJw2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68643606A32C;
	Wed, 25 Nov 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpEubJw2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D311F000E0;
	Wed, 25 Nov 2026 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626311;
	bh=A+MOAA3FMQxcoa0XKVahedXkcurNgmXa9pmlgcQXiSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpEubJw2yd4zjSmmO4cnNB7yZTQH4ii5bZLYttuj7a8T5PuJZFxhia9yLDT0uXMaP
	 L4JLWfSrnEndnY3+E98d9jo078NSWgx3szKvTPBo+DEPUonCTlI+q+fH9sN0nBimRF
	 beg8RcYYD2FT3JidWA58nLruHX7llNbl1iE6+/Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 756/816] usb: dwc3: gadget: Reset endpoint flags on controller start
Date: Wed, 25 Nov 2026 15:38:24 +0100
Message-ID: <20261125143906.672759339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 7c9bc134e5b3315e0456cda9e8e59c752309ea78 upstream.

The flags of a disabled endpoint may be preserved while its End
Transfer command is pending. If the command never completes, the stale
flags persist across a soft disconnect or an error recovery, and the
endpoint can't be used again.

Reset the flags of all non-control endpoints when starting the
controller.

Fixes: 76bff31c7fba ("usb: dwc3: gadget: Do not clear ep delayed stop flag during ep disable")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/21cd189962b9d32a4f9df381df4947d35341d5a9.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2944,6 +2944,7 @@ static int __dwc3_gadget_start(struct dw
 {
 	struct dwc3_ep		*dep;
 	int			ret = 0;
+	u32			epnum;
 	u32			reg;
 
 	/*
@@ -3001,6 +3002,15 @@ static int __dwc3_gadget_start(struct dw
 		return ret;
 	}
 
+	for (epnum = 2; epnum < dwc->num_eps; epnum++) {
+		dep = dwc->eps[epnum];
+		if (!dep)
+			continue;
+
+		dep->flags &= (DWC3_EP_TXFIFO_RESIZED |
+			       DWC3_EP_RESOURCE_ALLOCATED);
+	}
+
 	dep = dwc->eps[0];
 	dep->flags = 0;
 	ret = __dwc3_gadget_ep_enable(dep, DWC3_DEPCFG_ACTION_INIT);


