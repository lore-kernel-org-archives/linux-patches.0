Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33A41A680C;
	Mon, 13 Apr 2026 16:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098611; cv=none; b=i22pAo4zQu4CRDpdjbuTkDj8NMSWirK525O2VlWjyvXalZJfPUIikmPxbGu4p1aq0umTwCIp/p7XMMpei3AZZBntBqJUKce21RCM9+Xmc+3UGZlkAcmDpw50IG4pNF3xchi+VvekgflLzCL/ylWlddx2/f1Vmoy6ayN1PtR5NC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098611; c=relaxed/simple;
	bh=CpieB8muzijWracogZbSvgLlmAOkRKErersyaijPhpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W09tcvh+BIpQw7gS6XZhCZMZGI4QEg8c+AutpS6YnMlHQAMblcIvcUlSUlfzRDNtfj4CfIU5DRHj/tUnJ8aNPhFlkf3ngm3Lh1mC/oiz/7FeWSsAuDq2+NWAmCle76i3xqb1bcB1Y8mvniVjWvlmmTcL5e62vjymha+1wBjaUK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duyCILUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duyCILUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A297C2BCAF;
	Mon, 13 Apr 2026 16:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098611;
	bh=CpieB8muzijWracogZbSvgLlmAOkRKErersyaijPhpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duyCILUFhYthvk1rnBMU9QZ4HxfpwuzAOzYGR/dUEubTDC/9g9WfDpLVqXJYhdTag
	 A1tFC7nLdfvdbAxrE7mxfJqXq5lg1aZlY0tb+cAg6nXCI1pVmHVLH0/nfGVwH5Hi4i
	 KIMx/pNkw39ZDwBDPqPmshhHedPmSGR27ZqQJjNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 020/491] nfc: pn533: properly drop the usb interface reference on disconnect
Date: Mon, 13 Apr 2026 17:54:25 +0200
Message-ID: <20260413155819.810991678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 12133a483dfa832241fbbf09321109a0ea8a520e upstream.

When the device is disconnected from the driver, there is a "dangling"
reference count on the usb interface that was grabbed in the probe
callback.  Fix this up by properly dropping the reference after we are
done with it.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
Link: https://patch.msgid.link/2026022329-flashing-ought-7573@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -633,6 +633,7 @@ static void pn533_usb_disconnect(struct
 	usb_free_urb(phy->out_urb);
 	usb_free_urb(phy->ack_urb);
 	kfree(phy->ack_buffer);
+	usb_put_dev(phy->udev);
 
 	nfc_info(&interface->dev, "NXP PN533 NFC device disconnected\n");
 }


