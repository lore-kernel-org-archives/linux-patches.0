Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43E4343D7A;
	Wed,  3 Dec 2025 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777475; cv=none; b=WuvP4BNkW7QG7Jzux/YNPc3ihoCKXMo6NxM4Z8Hv8QKnUVF/SrTljX+s1NylYik4SzHA0DnrlNKhNGThSS37HtBzUpwWtMxUhQfi41rGzjOXpQ5oOO6bF+891pqwC83hn/AA2y9x6hJIi+cVCdsnp8PkJQ47cb6XAn1yQY7cdH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777475; c=relaxed/simple;
	bh=NNSOpLK0sTYwX5MWgoBawKCAIgwTzoxtP2Wh+o5ZOaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcG8hmfSqyvBE8APza+nmqXfjHNiRQ98bPZ6cIZ28dHXmbLeXBNPL+luH4FmJNRNn7BWeybJJJ98w6omrHSSoi0+cZS1Zkjg/YvVR/el/gqsA2rIUPoWT8Jn1MkMF4sG/WfI8LXvGfVXZCUq7Js1vJt+fDZ6J386U4tzkq0YysI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUU9+kxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUU9+kxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2526FC4CEF5;
	Wed,  3 Dec 2025 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777475;
	bh=NNSOpLK0sTYwX5MWgoBawKCAIgwTzoxtP2Wh+o5ZOaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUU9+kxo03MJXIPlEAW3Jyxeu3kKtCe15JRNsBJsKdNyXBFfYOl5LlJ0OgRAVB5iS
	 uP9cQauSag9B7I0oQ6Y36bQ2YE7fIuCxW6j06gUzAzT4HjEvTPxa/hLDt7j8Nx++R4
	 zUjTtxD3fAK7kRg9oFASB8xVnBa/hT5Iz7kDyhd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Owen Gu <guhuinan@xiaomi.com>
Subject: [PATCH 5.15 049/392] usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
Date: Wed,  3 Dec 2025 16:23:19 +0100
Message-ID: <20251203152415.917545995@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Owen Gu <guhuinan@xiaomi.com>

commit cfd6f1a7b42f62523c96d9703ef32b0dbc495ba4 upstream.

A race condition occurs when ffs_func_eps_enable() runs concurrently
with ffs_data_reset(). The ffs_data_clear() called in ffs_data_reset()
sets ffs->epfiles to NULL before resetting ffs->eps_count to 0, leading
to a NULL pointer dereference when accessing epfile->ep in
ffs_func_eps_enable() after successful usb_ep_enable().

The ffs->epfiles pointer is set to NULL in both ffs_data_clear() and
ffs_data_close() functions, and its modification is protected by the
spinlock ffs->eps_lock. And the whole ffs_func_eps_enable() function
is also protected by ffs->eps_lock.

Thus, add NULL pointer handling for ffs->epfiles in the
ffs_func_eps_enable() function to fix issues

Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Link: https://lore.kernel.org/r/20250915092907.17802-1-guhuinan@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2005,7 +2005,12 @@ static int ffs_func_eps_enable(struct ff
 	ep = func->eps;
 	epfile = ffs->epfiles;
 	count = ffs->eps_count;
-	while(count--) {
+	if (!epfile) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	while (count--) {
 		ep->ep->driver_data = ep;
 
 		ret = config_ep_by_speed(func->gadget, &func->function, ep->ep);
@@ -2029,6 +2034,7 @@ static int ffs_func_eps_enable(struct ff
 	}
 
 	wake_up_interruptible(&ffs->wait);
+done:
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 
 	return ret;


