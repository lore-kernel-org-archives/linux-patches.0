Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626278;
	b=M+0NzxAwDlyxMBMuysHL81cvQ2pJz83adsUf439BhuPfLl4kvKlmdviWW5MFYKcwwSwF
	 ef4lhQU+D5+WWbTg5WZQP11Bg9RvNuS61y9s/YB+YBAcQDQ+IjpfZRp0J0U/cp9rHp6Ae
	 wQORA2789ypy9ZvmmWVk/q+oWqMvlh3KU8qXBBY8s07n6xmO6yavg9C0yxtWd70Uw6qPi
	 Ey6m/pQXj191Fh8LT0xc5gtW0WY9xHw5+nywSYOhZ/g34FtD5bB3R/KlLD2wTDoVOg0n5
	 jVjM4D0uia/Ojr+AaRtlTFDdZUFdrCXJF4LMO3N1mOvHHtDUw1z5KHUdeAZU9c3zjpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8u1FhgJ93asVPEAlYbMbxRFUBlOM/qE4qts52wOoi7Q=;
	b=5PfPfQYAY6AixQjyBCOqobR1Aq5BIP3+5L3HhO9Eb+7j8eZ8JJQbKKRsWQ/SaqsWPX3C
	 t+jVjQlv0xxtSgiLybzNhEIsgi0GYtj1/Hsj0GxSXUMQsJU1Z3UiuwgZQb23MqytRwZOs
	 1+COUzn+dhmNwBeVr7x+zXvLdqkCRhsfBf9U8FVGh814YqtGRQvQbRYsyhM4T3Og+U7v7
	 Ddtd8JMzkNwpwqfeUhj491qEQXoQ/B2CN3oK86PhEz36SBVnovHiP+jLYqmjEeg1t/CDE
	 riac5WfF2OG9tAia4OuJKKKBiSLbr8eIJgb6wfnKeIbl4LTrrsnHnsc3iaVqUXZbnWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulbIBHMC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE3606A31E;
	Wed, 25 Nov 2026 17:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulbIBHMC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92681F000C0;
	Wed, 25 Nov 2026 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626278;
	bh=8u1FhgJ93asVPEAlYbMbxRFUBlOM/qE4qts52wOoi7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulbIBHMCUYKNzmS4445mbBfZgGPI+1OEz0xdleB517czqX1PUtlNEUsjjELKfpk9d
	 xXuvLG6Q+f/n79f5rYDa+mOb1J/k1QLaXYDsAqxIIEhCkfx6fuT4Umr/GoQfY/0Xgx
	 i5w7LfNh0gJEyxVzgKNb0634GHcaXn+nHiv2MRiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 754/816] usb: dwc3: gadget: Recover from End Transfer timeout
Date: Wed, 25 Nov 2026 15:38:22 +0100
Message-ID: <20261125143906.625624418@linuxfoundation.org>
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

commit 61575534fb05d52d36979f38976ece74649f091a upstream.

If the End Transfer command times out, the endpoint resource is never
released and every subsequent Start Transfer to the endpoint fails with
"No Resource". Schedule an error recovery to reset the controller.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/7523e9a11303a33acd0b92a092fb0e8218d509d2.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1743,6 +1743,8 @@ static int __dwc3_gadget_get_frame(struc
 	return DWC3_DSTS_SOFFN(reg);
 }
 
+static void dwc3_schedule_err_recovery(struct dwc3 *dwc);
+
 /**
  * __dwc3_stop_active_transfer - stop the current active transfer
  * @dep: isoc endpoint
@@ -1786,6 +1788,9 @@ static int __dwc3_stop_active_transfer(s
 		dev_err_ratelimited(dep->dwc->dev,
 				"end transfer failed: %d\n", ret);
 
+	if (ret == -ETIMEDOUT && dep->dwc->err_state == DWC3_ERR_NONE)
+		dwc3_schedule_err_recovery(dep->dwc);
+
 	dep->resource_index = 0;
 
 	if (!interrupt)


