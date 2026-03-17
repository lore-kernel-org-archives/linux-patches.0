Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CB02116F6;
	Tue, 17 Mar 2026 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767668; cv=none; b=f0GpNdMGm//SJKr0oirEjVme74ZJyFvdRhG7xc4R+YDlrMdlo62pJAb+v/3TRQYp4ROgnDuRckW7ZKDxMbXjrY0/BAvVP1c5IkXVPMkiLrfcFVpS2YgsJ4stZuTwtkfj+dyHic/+wRjU5lvtRxXVYOx3HNmt777KnQhoXaB3/3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767668; c=relaxed/simple;
	bh=zhAz7256xZJVoCstLunHsPrJRZR99/ZdLqkio1HVaeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6ZpKAe7URRMilZkQlDk/lyLNC+1nclbENL4/U7/xq3+YWltBm0NgeD4tN62/xKQJCkMhsKPBFpYvD2Ga79oGv+AzBXTyvKSPZl2Quxh3CHZX7NMe4Fu/qSGFNqZRHIQP0IMZnk/ZVv3UWmRaaZcw/bdhuj/+EKf8aDnwXVX4pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mejAQAQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mejAQAQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70DAC4CEF7;
	Tue, 17 Mar 2026 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767668;
	bh=zhAz7256xZJVoCstLunHsPrJRZR99/ZdLqkio1HVaeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mejAQAQEYyBAegS6M4SsF9WcRDGRyuN12UZTTmwXwEG3jsFd2iuyKH6FTv2/cyrl1
	 PeSnUMvHbwBxN/WZrsIYozg0TxcvrdJJG+Tf7RaPsN+eNOIMhx4Lv7ndrjYWV/hy32
	 nYZ0QyI+BEDBJCRotTy/MT9jRp6brFl0N4wEN8pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 133/333] usb: misc: uss720: properly clean up reference in uss720_probe()
Date: Tue, 17 Mar 2026 17:32:42 +0100
Message-ID: <20260317163004.294453708@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


