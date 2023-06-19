Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD655381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5C7C433C0;
	Mon, 19 Jun 2023 10:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171328;
	bh=eJUs+vNvTtnAAzKgiwycz9jwX8FtdzI1ZjWf/9vdT+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC+uzBKD+6aayE8Qla7Gs0HYmtW4TWwkRrcCfV78rkjYmI+nlAVWdHZtvN7Y+R59h
	 iaRUApQ8/e/oUFr/DPjmL3V4hrIWvF9/qSzHw4xtNPJD50kPXgUI1G5ThFwnIFNFsR
	 A+Rb/VQdH5X5HA5dxesS7Rh3pWvoteuCRdyrdvhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 24/49] usb: dwc3: gadget: Reset num TRBs before giving back the request
Date: Mon, 19 Jun 2023 12:30:02 +0200
Message-ID: <20230619102131.132821821@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
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
@@ -178,6 +178,7 @@ static void dwc3_gadget_del_and_unmap_re
 	list_del(&req->list);
 	req->remaining = 0;
 	req->needs_extra_trb = false;
+	req->num_trbs = 0;
 
 	if (req->request.status == -EINPROGRESS)
 		req->request.status = status;


