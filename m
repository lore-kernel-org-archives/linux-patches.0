Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A938BE56
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E319FC433C8;
	Mon, 19 Jun 2023 10:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172120;
	bh=pS2N2lntY2VpsyD69X43BDpNELB8gRZ8brV56N2u4WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUfFKWcdVzWLuOvZEDp71Xl6AKTQH167QAFMpL3GmnIFhuCn1LCioycy33uNVo3Gc
	 Wss1S+O6yYCIUusltnCOSkE634h2RwO48yCFXxhcfZm71FG71nkTxOu+3SPI4l2qQO
	 fTWS8qlpnRJiEBZOZQRwjVZ3TZ9T4HYrX18Xilt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 44/89] usb: dwc3: gadget: Reset num TRBs before giving back the request
Date: Mon, 19 Jun 2023 12:30:32 +0200
Message-ID: <20230619102140.295723212@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Elson Roy Serrao <quic_eserrao@quicinc.com>

commit 00f8205ffcf112dcef14f8151d78075d38d22c08 upstream.

Consider a scenario where cable disconnect happens when there is an active
usb reqest queued to the UDC. As part of the disconnect we would issue an
end transfer with no interrupt-on-completion before giving back this
request. Since we are giving back the request without skipping TRBs the
num_trbs field of dwc3_request still holds the stale value previously used.
Function drivers re-use same request for a given bind-unbind session and
hence their dwc3_request context gets preserved across cable
disconnect/connect. When such a request gets re-queued after cable connect,
we would increase the num_trbs field on top of the previous stale value
thus incorrectly representing the number of TRBs used. Fix this by
resetting num_trbs field before giving back the request.

Fixes: 09fe1f8d7e2f ("usb: dwc3: gadget: track number of TRBs per request")
Cc: stable <stable@kernel.org>
Signed-off-by: Elson Roy Serrao <quic_eserrao@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Message-ID: <1685654850-8468-1-git-send-email-quic_eserrao@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -180,6 +180,7 @@ static void dwc3_gadget_del_and_unmap_re
 	list_del(&req->list);
 	req->remaining = 0;
 	req->needs_extra_trb = false;
+	req->num_trbs = 0;
 
 	if (req->request.status == -EINPROGRESS)
 		req->request.status = status;


