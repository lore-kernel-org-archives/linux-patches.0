Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623620;
	b=JUY5nhzVZ6P3Q2glHPK2wZngAYi4MTgsGu/Wq0GYoooUX9Hphv9TxsJSXcDC8u9mxGtB
	 WHFfhAo9Lnq+JgiOrlIaZnwQiquWX7fgp/YyoTkvc9Xd4fqzs5Zp9cdxgjeQeASY04WxY
	 CPRCgoTfdKySdJnzFvfq/7a/zBr83kKgB91VYLcDRPJpbWtTQz70dnm0grjw1Zo+C0L42
	 O5NRR8mswQDC7dp7Z6p7CqaqDVeS08utj6MzYHKhzc1GzlaFg12TnJdOQ/tqe6gdESsXY
	 ix6zL7V3dLmFFZTubAJIDVPeED866iU9RFCvQr+6bqSGpQJ+Bkqp0sFhoO+0/WAAggg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z5JIJwzokUkJh+IUN0MOIIsAlSaPNNUrHtwwt9RzJm4=;
	b=UUMIa7DLrHXlbCKcmgL82nWfHrKK7zCbv5pvrcmQ0fj+2iUN/ZVSmTrenE+c+dP3phAC
	 MRUL2qEbbJWC5UKdn8ur1moH+nCIFfwTF9HkGjGV/1UCEMm2Bg6FfH9lYKAlhcGJM5azj
	 fRHFIw90Yl4NwT9zmFa21Ecs5Wcc+Rl2AyYbX/EjcouIQrVXWcK8kgGTFkKkAlJ/jO0r8
	 yDGkNzEh70oZ9w3svv4gXLhpzzI1TkPzA9gcwtXO+vXfTbTzQUiOB5Gqk85hx2zayY25q
	 TIZzXGAJTEkhmNB2JrcW4NjYWzc7Ubx4D6vb1YxQkr5i202ilw/ro/oqXR+xJbEevjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Vujk/zBy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73153606A321;
	Wed, 25 Nov 2026 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vujk/zBy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6321F000C0;
	Wed, 25 Nov 2026 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623620;
	bh=z5JIJwzokUkJh+IUN0MOIIsAlSaPNNUrHtwwt9RzJm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vujk/zByHkldwJiByFfgPJHIcPY1esDoTQHOWmWNsmXnXSbuCynY9b5DALavclUY7
	 s5j1WwHcJT7eCV63sDfDxm1UJAHL2b7zTxxiK8qkEmb+/XFDtVktOHfiNaq3mpigWf
	 Hnlx1DVStJLsZ+W7m5uS1+gSODESUPdOdewa3V6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 917/990] usb: dwc3: gadget: Recover from End Transfer timeout
Date: Wed, 25 Nov 2026 15:38:04 +0100
Message-ID: <20261125143843.483794063@linuxfoundation.org>
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
@@ -1754,6 +1754,8 @@ static int __dwc3_gadget_get_frame(struc
 	return DWC3_DSTS_SOFFN(reg);
 }
 
+static void dwc3_schedule_err_recovery(struct dwc3 *dwc);
+
 /**
  * __dwc3_stop_active_transfer - stop the current active transfer
  * @dep: isoc endpoint
@@ -1797,6 +1799,9 @@ static int __dwc3_stop_active_transfer(s
 		dev_err_ratelimited(dep->dwc->dev,
 				"end transfer failed: %d\n", ret);
 
+	if (ret == -ETIMEDOUT && dep->dwc->err_state == DWC3_ERR_NONE)
+		dwc3_schedule_err_recovery(dep->dwc);
+
 	dep->resource_index = 0;
 
 	if (!interrupt)


