Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EFA418A58;
	Tue, 21 Jul 2026 21:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671158; cv=none; b=gJma3BImbLaqGI0xnl6dlSv6Y7JJFJ7sCqXAARnLjd7uGMZsW9ewBwVc7b1qtNEWxkjd+o8igJQMUydkXc/B67IuAhI1cxxsTmjPK/G4r0zGEQQvY3CwFJSFk4Gk1DZn/2436sPNInwnuW/Nvxka+HmQK1Kox5/ANyKP6/ZBQUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671158; c=relaxed/simple;
	bh=VP/yeYYgECBk4VvdVZzto/D9vYdD7v8t5u2JoWuH/8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPYeyZjxxnEGTrk5C4DFkOYNRF29BVKAVWx8GnSBYiNfPcfTJpJcjuIf96WX83dtQ1A0/3ux72OjHQDRdVELpvQFoaZ+zMx9UtJpfztNCfTT1x/KPjYzpYMxVHJiV5/SOC22s1yHFZsoDGtQtSEuBkhUUugLmzUWbUkkwP87Vlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of+AzkUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of+AzkUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2A11F000E9;
	Tue, 21 Jul 2026 21:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671156;
	bh=Y8gGDZ9vFKFxb1LC1kMLJX8RuQxoRqgildLZeXvN2oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=of+AzkUj+hDBdeB3eddEYeLCQUCxpwamFV3GL1TBFLY/48hDAeMa+OnD9n1cEM+7r
	 ODVGjOQM/UbRHNOXuT72bjHDatlZOLeOF0ZEsR+eia7L+2JCiNxoFpGBKC8nMdG/y1
	 Az2jtSKMGrm57/ZwmPe1bIlB5oL6Ow8gaLui/ngU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alex Henrie <alexhenrie24@gmail.com>
Subject: [PATCH 5.15 141/843] USB: misc: uss720: unregister parport on probe failure
Date: Tue, 21 Jul 2026 17:16:16 +0200
Message-ID: <20260721152409.185211594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


