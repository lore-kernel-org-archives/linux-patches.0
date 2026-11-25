Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626212;
	b=P9isYtreNpkzmBY8S1RVvy6ZksoE10I7DFs2Ef5nDwGPjOSKilE22W3CmfSV4B2RFmRf
	 3o1i3tqIO7QL6gpPT0N+Ku8UZ84l6MxWkwSk2EsVrXzv0CYp4ZBmBN1ZGRNZkYR63arW7
	 SH0D6Fj8JRX96qlcfNt647hTiCm37qHQeFbh2VkYItp/6XtAwvdDPxXQrOEny8y2hxk+U
	 uGIHgpDs9GHamhm6ZfgFDhFNYq0hJPyCr2JolezKM3YkPExW41glD/mbLFOjmfO9ERZJx
	 3psWLTU87fLt8+ZnzIsNdgWxe9RY3VHqp7GLdT4HRV8IXBR5WG7SbbFPg7HzRy3IV4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cs0nAiCib7/fwKgnCY2/eucMfzaFxTvsTf5T5k1CSJ8=;
	b=5UYGnzp8P497aCubr9HKrlvhWRsDGVuK8oJLwZ4yGbdqImZ5IGZcuOIRSfcpNfPRmc6Z
	 6c3FUlfAZeuclYXdanJwKfnsdKSZso47bNbPB81GytD/W4N+0qjKgF7gMIN4wtILUb9o7
	 e7VDNE+Yy1wzmHg0qLiyabFxhFl74lb0iWOmEcuHoMiVb8Zkln9hIzAGx+TFwhKImy+CO
	 +rRJtVNE9Lbn4tdMktNyCvqLaD2lNq0rF0ivxtzgHalWxkLVM4XxVbcbo2K0OGp1m65Q7
	 A/okxCi3KPEUSKM4G0R1/qA1MwMAeO7Wn2tFVlVeCkUjLccERcL2RPa4hspjVJwJGhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNORxvJK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3336606A326;
	Wed, 25 Nov 2026 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNORxvJK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413DE1F000C4;
	Wed, 25 Nov 2026 17:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626211;
	bh=Cs0nAiCib7/fwKgnCY2/eucMfzaFxTvsTf5T5k1CSJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNORxvJK8DEsOPKY8zavzsAsW57rS828u6FobNcq9sHBHpCba0ObQgzYtY8s/44y7
	 ENjxQ/Ozg5Kb695py1+CL8K/Hz+qM15HA4FZSKBN0Mbv9yRPKGLQRjCR1ip4vpbK5K
	 ca5t94nFI/Xx8lD2LRYUhdqvaUJ6AyJr6I5foR0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 752/816] usb: dwc3: gadget: Clear delayed stop on End Transfer completion
Date: Wed, 25 Nov 2026 15:38:20 +0100
Message-ID: <20261125143906.577807894@linuxfoundation.org>
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

commit f2bd20f92a7dc68980a6098397503067192ce63a upstream.

When an End Transfer command times out outside of the SETUP phase, the
driver sets DWC3_EP_DELAY_STOP to retry it on the next SETUP phase. If
the command completes in the meantime, the flag is left set. Requests
queued to the endpoint are then deferred, and the retry may end a
transfer that is started later.

Clear DWC3_EP_DELAY_STOP when the End Transfer command completes.

Fixes: 4db0fbb60136 ("usb: dwc3: gadget: Don't delay End Transfer on delayed_status")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/c28a9660f7b6bfa626077ddcfbadd50e6b503f86.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3834,6 +3834,7 @@ static void dwc3_gadget_endpoint_command
 	if (dep->stream_capable)
 		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
 
+	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
 	dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	dwc3_gadget_ep_cleanup_cancelled_requests(dep);


