Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C2D286413;
	Mon, 23 Mar 2026 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282579; cv=none; b=E/U5fK6G9ZDMta7k6QQh0j8i36sJeUr4kAFW1138k/S00enmGGA0zDffDyMUuNEn84UoBVY+3wwSYidESZJr5gAbXf6eSRmprV2Zm42iEw6JHqfWoeF+UGJkxV2AzuVnB0kNMuaJPfJ/jROSnbsxARhg/zC5qmHK1d3QcG7ODxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282579; c=relaxed/simple;
	bh=oDPPaadqxAsKO5RTSVoMOLYmcoVphfhjP1jej0QqVr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/An7ZvmZqPo+IvhqryGKnWyUGYsmkx04Ad6w5KQ7beE7ilqLC5Lte5XspcazqA+HKRYUvK/mE+FnY28SWDANnacdo5KdpOD4X8axrEd/TYSJqGwfnE5HCQGDdTwae7kD8GzEx9bU2sfNI4A7Waoqiw2ANO/XqW2vRa8LHhzg70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8n17HaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8n17HaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F680C2BC9E;
	Mon, 23 Mar 2026 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282579;
	bh=oDPPaadqxAsKO5RTSVoMOLYmcoVphfhjP1jej0QqVr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8n17HaAsyrbvYkewWolA/PinYl3SkkglBIVvXALLsoXhabvEyNpQdn06JHoJohBu
	 QQOGF13NLHQuFNaSIfwjZfeISvefElOtXGopkFn63ABNBYzh83xg7oU4hxQFmVGt1Z
	 9sF9XzgV4hoH4RvzmJ61jaXRFQc7Vi4whdH+kVw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 209/481] usb: misc: uss720: properly clean up reference in uss720_probe()
Date: Mon, 23 Mar 2026 14:43:11 +0100
Message-ID: <20260323134530.260372801@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 45dba8011efac11a2f360383221b541f5ea53ce5 upstream.

If get_1284_register() fails, the usb device reference count is
incorrect and needs to be properly dropped before returning.  That will
happen when the kref is dropped in the call to destroy_priv(), so jump
to that error path instead of returning directly.

Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Link: https://patch.msgid.link/2026022342-smokiness-stove-d792@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/uss720.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -733,7 +733,7 @@ static int uss720_probe(struct usb_inter
 	ret = get_1284_register(pp, 0, &reg, GFP_KERNEL);
 	dev_dbg(&intf->dev, "reg: %7ph\n", priv->reg);
 	if (ret < 0)
-		return ret;
+		goto probe_abort;
 
 	ret = usb_find_last_int_in_endpoint(interface, &epd);
 	if (!ret) {


