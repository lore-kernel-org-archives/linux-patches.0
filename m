Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B37B3803DF;
	Tue, 21 Jul 2026 21:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668450; cv=none; b=NE+2xpF1Oyqs+71X36a2KH9p/8354SOEU3BTzZaFfd2o9ILMTwojeXQyTH+kbbL2HGYOltKpeTdKUgsqmBEZI7QifeShWtNsELSgVdMeGQ39lV7/5YrxtkGVTIFb9nXcv2B3ulSJBoXD732WgGxeAUfL0L+nqxCCP4w1cHejJwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668450; c=relaxed/simple;
	bh=HP0g1U00s8iCs4/2AAsyjuQnfQHsNg+ml/Wwa9XBjhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iANOUAZagDNgG0lHEDLs47mut8q9f6a0GSlonClUbe1xV2vEsw/YIYvTnHkj0eHXeST8zj4djf0IKcq5PbDbY3NDRnGCcfmt240uSlCBVJ1PtBJ4BaiKPC0oRYwRyxcfLY0UiO/+MXaEryJbKO+5yvQ8pEcp2e5FjipXayr1Wmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTiKyzX+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTiKyzX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF3C1F000E9;
	Tue, 21 Jul 2026 21:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668449;
	bh=EapRw9kmEVhCd2RUtt5upfGLBmzJsAMRPDJaPejzTpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTiKyzX+/sSlC5S9Q7bgfnKpSx4LwwEOkBftzXn6b5ICC24ccKTw8NwFHXUOewrBE
	 MOQIaaiJWKTMPDZApsElgGq25+LXAe7QTs7JLWS+NMcnTcRGK2QDW7T79pYpjbVqF2
	 Td2YrHgTD50RhM99HSewUhrQFlDjP150dg96DsZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alex Henrie <alexhenrie24@gmail.com>
Subject: [PATCH 6.1 0179/1067] USB: misc: uss720: unregister parport on probe failure
Date: Tue, 21 Jul 2026 17:13:00 +0200
Message-ID: <20260721152428.594110056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit b4ecbdc4f8830f5586c4a5cfc384c00f20f8f8b3 upstream.

uss720_probe() registers a parport before reading the 1284 register used
to detect unsupported Belkin F5U002 adapters. If get_1284_register()
fails, the error path drops the driver private data and the USB device
reference, but leaves the parport device registered.

Leaving the port registered is more than a private allocation leak:
parport_register_port() has already reserved a parport number and
registered the parport bus device, while pp->private_data still points at
the private data that the common error path is about to release.

Undo the pre-announce registration in the get_1284_register() failure
branch before jumping to the common private-data cleanup path. Clear
priv->pp first, matching the disconnect path and avoiding a stale pointer
in the private data.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 3295f1b866bf ("usb: misc: uss720: check for incompatible versions of the Belkin F5U002")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Alex Henrie <alexhenrie24@gmail.com>
Link: https://patch.msgid.link/20260706151049.63470-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/uss720.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -732,8 +732,11 @@ static int uss720_probe(struct usb_inter
 	 * here. */
 	ret = get_1284_register(pp, 0, &reg, GFP_KERNEL);
 	dev_dbg(&intf->dev, "reg: %7ph\n", priv->reg);
-	if (ret < 0)
+	if (ret < 0) {
+		priv->pp = NULL;
+		parport_del_port(pp);
 		goto probe_abort;
+	}
 
 	ret = usb_find_last_int_in_endpoint(interface, &epd);
 	if (!ret) {


