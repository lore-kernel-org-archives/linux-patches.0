Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4290823DD;
	Mon, 23 Mar 2026 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275577; cv=none; b=fIUODUtVpX5XXQZEsJHAgXFNWxoS9nC6yAluXTuEYu1zsC08IrJMAMajd8WBrA9qtoE2upHxxBgEjKC3gbC3+4tH8SbylYWcN1v+DAy/umWHNQtZoSsp5VWImpMUNEtLLpmFIXEWfxdLlM5Vnc3MS4KOjZlFJUlAsOxHyBRKWbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275577; c=relaxed/simple;
	bh=oNGmEKz3Wsp0eKAe3BKs9kv7oGzokVWdh9xItNRYcvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNczDzN6Rhbu6YxFOE7kPyJTZwbFgbknzGbRH7kTqzfTZ+wEbgRUV0Za1vWsYjzlOqmpuwm/Rch2YgwNpio1XmStqGNKvbOq7wBFG7y9EJRcVPSWapZczFTE5EqAYYzZpfxtvBYRtvs6SR3vhLrUyAtI0XJDnpjGMs7AsozDlmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6NkfPgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6NkfPgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2687EC4CEF7;
	Mon, 23 Mar 2026 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275577;
	bh=oNGmEKz3Wsp0eKAe3BKs9kv7oGzokVWdh9xItNRYcvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6NkfPgmu9PG/cHwDv61PCKH5V1RYx/+LP0DmtISXuSFledOLTJsLogV6FFPCk2EF
	 7M8QRABd74DFuvNYINFDBgHcq7ZViAZ1Vt0oTSVIAmNQN2dNV3a3WF4uVZXby+boMA
	 x/2zvuST7Cn1bRg7xMQvxgUr/HcFQbZzlboGMc7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 105/460] usb: misc: uss720: properly clean up reference in uss720_probe()
Date: Mon, 23 Mar 2026 14:41:41 +0100
Message-ID: <20260323134529.226762421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
@@ -736,7 +736,7 @@ static int uss720_probe(struct usb_inter
 	ret = get_1284_register(pp, 0, &reg, GFP_KERNEL);
 	dev_dbg(&intf->dev, "reg: %7ph\n", priv->reg);
 	if (ret < 0)
-		return ret;
+		goto probe_abort;
 
 	ret = usb_find_last_int_in_endpoint(interface, &epd);
 	if (!ret) {


