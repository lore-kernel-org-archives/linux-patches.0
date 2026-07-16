Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9F626AF4;
	Thu, 16 Jul 2026 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212214; cv=none; b=M0Pooyndyt34SvMfPo8D+nZciRR+ug5K7w6JvoM46TaSo4gTfd9D0jOa801TtRAR9/UhafO5Wj/Mv89G15NWA/iWH7LFxfg4ShUPgIwLWybvaaVqcl9ucqE8lfy5oWiQ8qBNZJX/+OGIEnMA1igPoYc53SOXxhddr0CklGlZsKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212214; c=relaxed/simple;
	bh=ohDDK6fex12Rf2/fganrHjjT6V4dxTKYE3wFNMXrtWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nF+XBbqjnFcGrSOBOhLMgMD9GB38B1HMncMmCNfiCIIxvkMST+0Dl9jNASmcORdr4Ar1d3Digz28nP+/2U7LfSUQeLFID+D1E80SiOT7BvUenHWxYR1eDUKApF1gmGb5r2anyD0stjl6TIIhY1fWlQB/Q8DDQz50WD44QNTEaGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mj4yvPLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mj4yvPLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208F01F000E9;
	Thu, 16 Jul 2026 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212213;
	bh=PCcZY5rOOUaeHWlNAupXwYekjbg2OGtJuCKPojkuGzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mj4yvPLWqZB6bh5p9dHz2+VoqBHQE48JV3yXR9MLXTHmGdKl4K84LQ9WWQm9sjQX+
	 c52K+iU6Xdi6zJJx8yeWa4h6r1tPz00xbANBOk9pFGLoVT9ja76bYt2rcOJh3U5lml
	 yFqW6o/rMajep63MGONcMM+kuw/mU87yK31Ja87o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alex Henrie <alexhenrie24@gmail.com>
Subject: [PATCH 6.12 235/349] USB: misc: uss720: unregister parport on probe failure
Date: Thu, 16 Jul 2026 15:32:49 +0200
Message-ID: <20260716133038.623143857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -735,8 +735,11 @@ static int uss720_probe(struct usb_inter
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


