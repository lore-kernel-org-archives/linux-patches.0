Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623629;
	b=VxI7Vy35tQoRRpUWpyV1Uyya0cl8opveT441WQrOP9Ol75X6SsO1BJhdB0Ya9IWB+59L
	 8kSeHogwDQZaHB8FJOOSOHDjETIdj8ybykS7sC+4Ca2mU+oyqVeHaZZ7V1O9lsShTSdEu
	 ujsAkZoZ0yJadM4pKzyeVYFcAMrxntm5+oUcx+PPxr/3eJI1G2nyY1/hpjUwy35So1qPY
	 /MhnxtvMLIfaj0F3tPF6j2RHje/VAYEp8eebXpudDY2bTZAxqI5NYFN9KlV1VdMawD6md
	 WQI8BsLBL2pKMQxRWZYMOIp/Qgqrmyvrpz41cLkfj8k0VuC6BfZI+nHVb1EzVVKx2vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G40r61dyAgbEf4BA2ibvX+vXHQOfUUnjSPgBzKhL64A=;
	b=KuDEbnFS6yZ3g01K3dyQj9f9m1JnA079GUuEy4ewjgoM77Ig7JiBUKETb49QiM2oVYse
	 Hh46y/DFZLJXeVzlAJWzY/bkPd4187oL5qNUGzvlmaGd4+kW4doOn7l8NhA3OPmjHFt84
	 6fnAfOjfXyXWjVFbnCtue81E7/FOc43Ia+3ooV/JLjLQBYayAPuzXRaQo1vqVak1pW3WA
	 e18ew4aC3B/SAohuXYuQ79FkZ4wsUFEJ5+nboZgwHKhykC0iYHfNSKWgGa4qPulDPLzt/
	 3DHzlUT+dXzu/TucCJ/aCQFmvJOK0CfQBdSXf5ezxHtYtZJuhB/an3mYlntEVGu2iFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6hrT2UF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8DB606A332;
	Wed, 25 Nov 2026 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6hrT2UF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ADA1F000D2;
	Wed, 25 Nov 2026 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623629;
	bh=G40r61dyAgbEf4BA2ibvX+vXHQOfUUnjSPgBzKhL64A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6hrT2UFWg0ytcubSvOGwaid7/V/9id1Q0pIyoEVq2ganDKH/YlO+QvhgB2xtDf4Z
	 xDREx7WhJYvuV1jp3vLIg5iiD6XVdYusg7E8lFIAtFsFGlcIsVbyDZ3N9QG4y7Y1nm
	 XO16yFRbcxPRdxQJbVCvvM5wFMZTRSj5xRvEsSmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 919/990] usb: dwc3: gadget: Reset endpoint flags on controller start
Date: Wed, 25 Nov 2026 15:38:06 +0100
Message-ID: <20261125143843.527968113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2958,6 +2958,7 @@ static int __dwc3_gadget_start(struct dw
 {
 	struct dwc3_ep		*dep;
 	int			ret = 0;
+	u32			epnum;
 	u32			reg;
 
 	/*
@@ -3015,6 +3016,15 @@ static int __dwc3_gadget_start(struct dw
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


