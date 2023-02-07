Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBD62C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C917C433D2;
	Tue,  7 Feb 2023 13:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775166;
	bh=FZT2osC+H4WvsZsg9w/cdCfwmx3I0ErHFAzT0Jyp6Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cK6pucL6b+AeVdK30o5YuacQr7AogZO4wRvmoEbcTSXfhZkSLDxHu6e8v3aZEOMWz
	 qlB6w1fqlyv6aBKIs5cIFWuDl4D7H8RDcu6pBBF9ACpFqyzjM9+p82mkHoJPxjSvkc
	 7eBnJnugBU0vKGF+TkEucxTl1LuCMZ00Krka8Usg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pratham Pratap <quic_ppratap@quicinc.com>,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.1 159/208] usb: gadget: f_uac2: Fix incorrect increment of bNumEndpoints
Date: Tue,  7 Feb 2023 13:56:53 +0100
Message-Id: <20230207125641.647563564@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pratham Pratap <quic_ppratap@quicinc.com>

commit 2fa89458af9993fab8054daf827f38881e2ad473 upstream.

Currently connect/disconnect of USB cable calls afunc_bind and
eventually increments the bNumEndpoints. Performing multiple
plugin/plugout will increment bNumEndpoints incorrectly, and on
the next plug-in it leads to invalid configuration of descriptor
and hence enumeration fails.

Fix this by resetting the value of bNumEndpoints to 1 on every
afunc_bind call.

Fixes: 40c73b30546e ("usb: gadget: f_uac2: add adaptive sync support for capture")
Cc: stable <stable@kernel.org>
Signed-off-by: Pratham Pratap <quic_ppratap@quicinc.com>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/1674631645-28888-1-git-send-email-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -1142,6 +1142,7 @@ afunc_bind(struct usb_configuration *cfg
 		}
 		std_as_out_if0_desc.bInterfaceNumber = ret;
 		std_as_out_if1_desc.bInterfaceNumber = ret;
+		std_as_out_if1_desc.bNumEndpoints = 1;
 		uac2->as_out_intf = ret;
 		uac2->as_out_alt = 0;
 


