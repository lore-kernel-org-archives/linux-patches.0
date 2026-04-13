Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB823093B2;
	Mon, 13 Apr 2026 16:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097437; cv=none; b=BfUcPqPNC1Z10mWi7a2Y7ZO1Ya2+X1JoNVWxpdUiNGkzsM66nWipauYrQr4dmUlkJsH0TOvzptH46oAK9dkpnEVpAVwie3zvUW96Y01n0fxJDu5DFKrmlMgqIAxMOsyVMInrxEApfAwAIN8kLnRyZ+TgDECaE079v1p1EUQbOj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097437; c=relaxed/simple;
	bh=B3ll49EtEC8hlmZaQ/8G46/bTnyIESo4E1EbPI1fmMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCPW0D8YcC0cg+9DHwP2i2IUJf3XGL05JrVocxOjVQk88/QlT9gfCAKm0LWy5lSfuXJU/Kmu/1MuN4qxv+VfbmjQCXLW9SOnrgImXPAnMT83PlbpzsB1HQW6og3mblDfO4w33mc6y0UQdNTWLkh8W9gA4tyEcl62sy8QulEsLIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sves/wtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sves/wtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731B9C2BCAF;
	Mon, 13 Apr 2026 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097437;
	bh=B3ll49EtEC8hlmZaQ/8G46/bTnyIESo4E1EbPI1fmMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sves/wtVmN0QKijDUD/M386/jYRgcVtjVxFVO6FRanrnx28FjYQZjblzqYvpjNc9V
	 P+suye3ZGLUnuLr4gCTq6OtVLwIrXMVBWhXMg8OxNPoePFiiQaYrv7rDVBU0/Binf3
	 5LJ5HoWQWNTEZ6F6TvUUxOL2+Hsx3XSRbUbEB8pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 137/570] usb: misc: uss720: properly clean up reference in uss720_probe()
Date: Mon, 13 Apr 2026 17:54:28 +0200
Message-ID: <20260413155835.574446901@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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


